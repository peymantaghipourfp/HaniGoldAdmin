import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/const/app_color.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:hanigold_admin/src/domain/order/controller/order_create.controller.dart';
import 'package:hanigold_admin/src/widget/custom_dropdown.widget.dart';
import 'package:hanigold_admin/src/widget/custom_dropdown1.widget.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../account/model/account.model.dart';
import '../../account/widget/account_level_get_one_item.widget.dart';
import '../../accountSalesGroup/widget/account_sales_group_get_one_item.widget.dart';
import '../../product/model/item.model.dart';
import '../../users/widgets/balance.widget.dart';
import '../../users/widgets/user_create_dialog.widget.dart';

class OrderCreateDialogWidget extends StatefulWidget {
  const OrderCreateDialogWidget({super.key});

  @override
  State<OrderCreateDialogWidget> createState() => _OrderCreateDialogWidgetState();
}

class _OrderCreateDialogWidgetState extends State<OrderCreateDialogWidget>
    with SingleTickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  late TabController _tabController;
  late OrderCreateController orderCreateController;

  // For draggable functionality
  Offset _dialogOffset = Offset.zero;
  // For quantity validation
  bool _isValidatingQuantity = false;
  Timer? _limitCheckDebounce;
  bool _isDialogShowing = false;

  OrderCreateController _getOrCreateController() {
    if (Get.isRegistered<OrderCreateController>()) {
      return Get.find<OrderCreateController>();
    } else {
      return Get.put(OrderCreateController());
    }
  }

  @override
  void initState() {
    super.initState();
    // Get or create the controller
    orderCreateController = _getOrCreateController();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Clear previous state and initialize fresh
      orderCreateController.clearList();
      // Initialize with sell type (0) by default
      orderCreateController.changeSelectedBuySell(
        orderCreateController.orderTypeList.firstWhere((t) => t.id == 0),
      );
    });
  }

  void _handleTabChange() {
    if (!_tabController.indexIsChanging) {
      // Tab 0 = فروش (Sell) -> type 0
      // Tab 1 = خرید ارز (Buy) -> type 1
      int typeId = _tabController.index == 0 ? 0 : 1;
      var selectedType = orderCreateController.orderTypeList.firstWhere(
            (t) => t.id == typeId,
        orElse: () => orderCreateController.orderTypeList.first,
      );
      orderCreateController.changeSelectedBuySell(selectedType);
      setState(() {});
    }
  }

  void _resetFormAfterOrderCreation() {
    // Clear the form but preserve the current tab selection
    orderCreateController.clearList();
    // Restore selectedBuySell based on current tab index
    int currentTabIndex = _tabController.index;
    int typeId = currentTabIndex == 0 ? 0 : 1;
    if (orderCreateController.orderTypeList.isNotEmpty) {
      var selectedType = orderCreateController.orderTypeList.firstWhere(
            (t) => t.id == typeId,
        orElse: () => orderCreateController.orderTypeList.first,
      );
      orderCreateController.changeSelectedBuySell(selectedType);
    }
    // Reset form key to allow validation on next submission
    formKey.currentState?.reset();
    orderCreateController.priceController.clear();
    orderCreateController.quantityController.clear();
    orderCreateController.totalPriceController.clear();
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    _limitCheckDebounce?.cancel();
    super.dispose();
  }

  bool _isPriceDifferent() {
    if (orderCreateController.socketPrice.value.isEmpty ||
        orderCreateController.currentPrice.value.isEmpty) {
      return false;
    }

    String socketPriceClean =
    orderCreateController.socketPrice.value.replaceAll(',', '').toEnglishDigit();
    String textFieldPriceClean =
    orderCreateController.currentPrice.value.replaceAll(',', '').toEnglishDigit();

    if (orderCreateController.selectedItem.value?.itemUnit?.name == 'گرم') {
      double textFieldPriceInMesghal = double.tryParse(textFieldPriceClean) ?? 0;
      double socketPriceInMesghal = double.tryParse(socketPriceClean) ?? 0;
      return textFieldPriceInMesghal != socketPriceInMesghal;
    } else {
      return socketPriceClean != textFieldPriceClean;
    }
  }

  Color _getSocketPriceDisplayColor() {
    return _isPriceDifferent() ? Colors.red.withAlpha(25) : Colors.green.withAlpha(25);
  }

  Color _getSocketPriceBorderColor() {
    return _isPriceDifferent() ? Colors.red : Colors.green;
  }

  IconData _getSocketPriceIcon() {
    return _isPriceDifferent() ? Icons.warning : Icons.check_circle;
  }

  String _getSocketPriceValue() {
    return orderCreateController.socketPrice.value;
  }

  String _cleanNumber(String input) {
    return input.replaceAll(',', '').toEnglishDigit();
  }

  double? _priceDiffRatio() {
    final socketText = orderCreateController.socketPrice.value;
    if (socketText.isEmpty) return null;
    final inputText = orderCreateController.priceController.text;
    final socket = double.tryParse(_cleanNumber(socketText)) ?? 0;
    final input = double.tryParse(_cleanNumber(inputText)) ?? 0;
    if (socket <= 0) return null;
    return ((input - socket).abs()) / socket;
  }

  bool _isPriceOverOnePercent() {
    final diffRatio = _priceDiffRatio();
    if (diffRatio == null) return false;
    return diffRatio > 0.1;
  }

  String formatQuantity(double value) {
    if (value == value.truncate()) {
      return value.toInt().toString();
    } else {
      return value.toStringAsFixed(2);
    }
  }

  void _showConfirmDialog() {
    bool isBuy = orderCreateController.selectedBuySell.value?.id == 1;
    String title = isBuy ? "ایجاد سفارش خرید" : "ایجاد سفارش فروش";
    String detailTitle = isBuy ? "جزئیات خرید" : "جزئیات فروش";
    String priceLabel = isBuy ? "قیمت خرید:" : "قیمت فروش:";

    Get.defaultDialog(
      backgroundColor: AppColor.backGroundColor,
      title: title,
      titleStyle: AppTextStyle.smallTitleText,
      middleText: "آیا از ایجاد سفارش مطمئن هستید؟",
      middleTextStyle: AppTextStyle.bodyText,
      content: Card(
        color: AppColor.backGroundColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                detailTitle,
                style: AppTextStyle.bodyText.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 2),
              Divider(height: 1, color: AppColor.dividerColor),
              SizedBox(height: 5),
              _buildDetailRow('نام کاربر:', orderCreateController.selectedAccount.value?.name ?? ''),
              SizedBox(height: 5),
              _buildDetailRow('محصول:', orderCreateController.selectedItem.value?.name ?? ''),
              SizedBox(height: 5),
              _buildDetailRow(
                'مقدار:',
                formatQuantity(
                  double.tryParse(orderCreateController.quantityController.text) ?? 0,
                ),
              ),
              SizedBox(height: 5),
              _buildDetailRow(
                priceLabel,
                orderCreateController.priceController.text.seRagham(separator: ','),
              ),
              SizedBox(height: 5),
              _buildDetailRow(
                'مبلغ کل:',
                orderCreateController.totalPriceController.text.seRagham(separator: ','),
              ),
              SizedBox(height: 5),
              _buildDetailRow('تاریخ:', orderCreateController.dateController.text),
            ],
          ),
        ),
      ),
      confirm: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(AppColor.primaryColor,),
        ),
        onPressed: () async {
          await orderCreateController.insertOrder();
          if (!orderCreateController.hasError.value) {
            Get.back();
            _resetFormAfterOrderCreation();
          }
        },
        child: Text('ایجاد', style: AppTextStyle.bodyText),
      ),
      cancel: ElevatedButton(
        style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(AppColor.accentColor)),
        onPressed: () => Get.back(),
        child: Text('لغو', style: AppTextStyle.bodyText),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      children: [
        SizedBox(width: 3),
        Icon(Icons.circle, size: 5, color: AppColor.primaryColor),
        SizedBox(width: 5),
        Text(label, style: AppTextStyle.bodyText.copyWith(fontWeight: FontWeight.bold)),
        SizedBox(width: 5),
        Expanded(
          child: Text(
            value,
            style: AppTextStyle.bodyText.copyWith(color: AppColor.dividerColor),
            textDirection:  TextDirection.ltr,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Transform.translate(
      offset: _dialogOffset,
      child: Dialog(
        backgroundColor: AppColor.backGroundColor2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),side: BorderSide(color: AppColor.secondaryColor)),
        insetPadding: EdgeInsets.symmetric(horizontal: isDesktop ? 40 : 16, vertical: 24),
        child: Container(
          width: isDesktop ? Get.width * 0.65 : Get.width * 0.95,
          constraints: BoxConstraints(
            maxHeight: Get.height * 0.85,
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Draggable header
              GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _dialogOffset += details.delta;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColor.backGroundColor2,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.drag_indicator, color: AppColor.textColor.withAlpha(150), size: 20),
                          SizedBox(width: 8),
                          Text('ثبت سفارش جدید', style: AppTextStyle.smallTitleText),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          orderCreateController.clearList();
                          Get.back();
                        },
                        icon: Icon(Icons.close, color: AppColor.textColor),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                      ),
                    ],
                  ),
                ),
              ),
              // Tab bar
              Container(
                width:isDesktop ? Get.width*0.3 : Get.width,
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColor.backGroundColor2,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: AnimatedBuilder(
                  animation: _tabController,
                  builder: (context, child) {
                    final currentIndex = _tabController.index;
                    return TabBar(
                      controller: _tabController,
                      indicator: UnderlineTabIndicator(
                        borderSide: BorderSide(
                          color: currentIndex == 0 ? AppColor.accentColor : AppColor.primaryColor,
                          width: 3,
                        ),
                        insets: EdgeInsets.symmetric(horizontal: 16),
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelColor: AppColor.textColor,
                      dividerColor: AppColor.backGroundColor1,
                      unselectedLabelColor: AppColor.textColor.withAlpha(150),
                      labelStyle: AppTextStyle.labelText.copyWith(fontWeight: FontWeight.bold,fontSize: 12),
                      tabs: [
                        Tab(text: 'فروش'),
                        Tab(text: 'خرید'),
                      ],
                    );
                  },
                ),
              ),
              // Content - desktop no scroll, mobile allows scroll
              Flexible(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Obx(() {
                    if (isDesktop) {
                      return _buildDesktopLayout();
                    } else {
                      return SingleChildScrollView(
                        child: _buildMobileLayout(),
                      );
                    }
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Right side - Form
        Expanded(
          child: _buildOrderForm(),
        ),
        SizedBox(width: 16),
        // Left side - Balance
         Expanded(
           child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                orderCreateController.isLoadingBalance.value == false
                    ? Center(child: CircularProgressIndicator())
                    : LayoutBuilder(
                    builder: (context, constraints) {
                        return BalanceWidget(
                          title: orderCreateController.selectedAccount.value?.name,
                          listBalance: orderCreateController.balanceList,
                          size: constraints.maxWidth,
                        );
                      }
                    ),
                _buildErrorWidget(),
                const SizedBox(height: 8),
                Obx(() {
                  return AccountSalesGroupGetOneItemWidget(
                    data: orderCreateController.selectedAccountSalesGroupItem.value,
                    width: double.infinity,
                    title: orderCreateController
                        .selectedAccount.value?.accountSalesGroup?.name,
                    isLoading:
                    orderCreateController.isLoadingAccountSalesGroupItem.value,
                    selectedItemId: orderCreateController.selectedItem.value?.id,
                    selectedBuySellId: orderCreateController.selectedBuySell.value?.id,
                    onPriceSelected: (mesghlPrice) {
                      orderCreateController.setPriceFromSalesGroup(mesghlPrice);
                    },
                  );
                }),
                SizedBox(height: 8),
                Obx(() {
                  return AccountLevelGetOneItemWidget(
                    data: orderCreateController.selectedAccountLevelItem.value,
                    width: double.infinity,
                    title: orderCreateController
                        .selectedAccount.value?.accountLevel?.name,
                    isLoading:
                    orderCreateController.isLoadingAccountLevelItem.value,
                  );
                }),
              ],
            ),
         ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        orderCreateController.isLoadingBalance.value == false
            ? Center(child: CircularProgressIndicator())
            : BalanceWidget(
          title: orderCreateController.selectedAccount.value?.name,
          listBalance: orderCreateController.balanceList,
          size: double.infinity,
        ),
        _buildErrorWidget(),
        const SizedBox(height: 8),
        Obx(() {
          return AccountSalesGroupGetOneItemWidget(
            data: orderCreateController.selectedAccountSalesGroupItem.value,
            width: double.infinity,
            title: orderCreateController
                .selectedAccount.value?.accountSalesGroup?.name,
            isLoading: orderCreateController.isLoadingAccountSalesGroupItem.value,
            selectedItemId: orderCreateController.selectedItem.value?.id,
            selectedBuySellId: orderCreateController.selectedBuySell.value?.id,
            onPriceSelected: (mesghlPrice) {
              orderCreateController.setPriceFromSalesGroup(mesghlPrice);
            },
          );
        }),
        const SizedBox(height: 8),
        Obx(() {
          return AccountLevelGetOneItemWidget(
            data: orderCreateController.selectedAccountLevelItem.value,
            width: double.infinity,
            title: orderCreateController
                .selectedAccount.value?.accountLevel?.name,
            isLoading: orderCreateController.isLoadingAccountLevelItem.value,
          );
        }),
        SizedBox(height: 16),
        _buildOrderForm(),
      ],
    );
  }

  Widget _buildErrorWidget() {
    return Obx(() => orderCreateController.hasError.value
        ? Container(
      margin: EdgeInsets.only(top: 16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        border: Border.all(color: Colors.red.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade600, size: 20),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  orderCreateController.errorTitle.value,
                  style: AppTextStyle.bodyText.copyWith(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  orderCreateController.errorMessage.value,
                  style: AppTextStyle.bodyText.copyWith(
                    color: Colors.red.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => orderCreateController.clearError(),
            child: Icon(Icons.close, color: Colors.red.shade600, size: 18),
          ),
        ],
      ),
    )
        : SizedBox.shrink());
  }

  Widget _buildOrderForm() {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Obx(() {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: isDesktop ? 12 : 16, vertical: isDesktop ? 4 : 8),
          decoration: BoxDecoration(
            color:orderCreateController.selectedBuySell.value?.id == 0 ? AppColor.accentColor.withAlpha(20) : AppColor.primaryColor.withAlpha(20),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColor.secondaryColor),
          ),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // User selection
                _buildLabelCompact('انتخاب کاربر'),
                SizedBox(height: 4),
                orderCreateController.accountList.isEmpty
                    ? Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor),
                  ),
                )
                    : Row(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            child: CustomDropdown<AccountModel>(
                          items: orderCreateController.accountList,
                          selectedItem: orderCreateController.selectedAccount.value,
                          enableSearch: true,
                          errorText: orderCreateController.dropdownError.value,
                          itemLabel: (account) => account.name ?? "",
                          onChanged: (account) async {
                            setState(() {
                              orderCreateController.selectedAccount.value = account;
                              orderCreateController.dropdownError.value = "";
                            });
                            await orderCreateController.changeSelectedAccount(
                                account);
                          },
                          isIcon: false,
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        Tooltip(
                          message: "ایجاد کاربری جدید",
                          child: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: GestureDetector(
                              onTap: () async {
                                await Get.dialog(const UserCreateDialogWidget());
                                await orderCreateController.fetchAccountList();
                              },
                              child: SvgPicture.asset(
                                'assets/svg/add-plus.svg',
                                height: 30,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                // Product selection
                Row(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildLabelCompact('انتخاب محصول'),
                    SizedBox(width: 8),
                    // Most-used products (itemId 1 and 2)
                    Obx(() {
                      final hasAccountSelected = orderCreateController.selectedAccount.value != null;
                      final mostUsedProducts = _getMostUsedProducts();
                      return hasAccountSelected &&
                          !orderCreateController.isLoadingItems.value &&
                          mostUsedProducts.isNotEmpty
                          ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(bottom: isDesktop ? 2 : 5),
                            child: Row(
                              children: mostUsedProducts.asMap().entries.map((entry) {
                                final index = entry.key;
                                final item = entry.value;
                                final isSelected = orderCreateController.selectedItem.value?.id == item.id;
                                return Container(
                                  margin: EdgeInsets.only(
                                    left: 2,
                                  ),
                                  child: _buildMostUsedProductCard(item, isSelected, isDesktop),
                                );
                              }).toList(),
                            ),
                          ),
                          SizedBox(height: 5),
                        ],
                      )
                          : SizedBox.shrink();
                    }),
                  ],
                ),
                SizedBox(height: 4),
                Container(
                  padding: EdgeInsets.only(bottom: isDesktop ? 2 : 5),
                  child: Obx(() {
                    final hasAccountSelected = orderCreateController.selectedAccount.value != null;
                    if(orderCreateController.isLoadingItems.value){
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              AppColor.textColor),
                        ),
                      );
                    }
                    return CustomDropdownWidget(
                      validator: (value) {
                        if(!hasAccountSelected){
                          return 'ابتدا کاربر را انتخاب کنید';
                        }
                        if (value == 'انتخاب کنید' ||
                            value == null ||
                            value.isEmpty) {
                          return 'محصول را انتخاب کنید';
                        }
                        return null;
                      },
                      items: hasAccountSelected
                          ? [
                        'انتخاب کنید',
                        ...orderCreateController.itemList.map((item) => item.name ?? '')
                      ].toList()
                          : ['ابتدا کاربر را انتخاب کنید'],
                      selectedValue: hasAccountSelected
                          ? orderCreateController.selectedItem.value?.name
                          : 'ابتدا کاربر را انتخاب کنید',
                      onChanged: hasAccountSelected ? (String? newValue) {
                        if (newValue == 'انتخاب کنید') {
                          orderCreateController.changeSelectedItem(null);
                        } else {
                          var selectedItem = orderCreateController
                              .itemList
                              .firstWhere((item) =>
                          item.name == newValue);
                          orderCreateController
                              .changeSelectedItem(
                              selectedItem);
                        }
                      } : null,
                      backgroundColor: AppColor
                          .textFieldColor,
                      borderRadius: 7,
                      borderColor: AppColor
                          .secondaryColor,
                      hideUnderline: true,
                    );
                  }),
                ),

                // Card reader checkbox
                orderCreateController.selectedBuySell.value?.id == 0 &&
                    orderCreateController.selectedItem.value?.hasCard == true
                    ? Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'کارتخوان',
                        style: AppTextStyle.labelText.copyWith(
                          fontSize: isDesktop ? 12 : 10,
                          fontWeight: FontWeight.bold,
                          color: AppColor.primaryColor,
                        ),
                      ),
                      SizedBox(width: 3),
                      Checkbox(
                        hoverColor: AppColor.textFieldColor.withAlpha(200),
                        value: orderCreateController.isCardChecked.value,
                        onChanged: (value) async {
                          orderCreateController.isCardChecked.value = value!;
                          if (value) {
                            orderCreateController.priceController.text =
                                ((orderCreateController.selectedItem.value!.mesghalPrice)! +
                                    (orderCreateController.selectedItem.value?.cardPrice)!
                                        .toDouble())
                                    .toString()
                                    .seRagham(separator: ',');
                          } else {
                            orderCreateController.priceController.text =
                                (orderCreateController.selectedItem.value!.mesghalPrice)
                                    .toString()
                                    .seRagham(separator: ',');
                          }
                          orderCreateController.updateTotalPrice();
                        },
                      ),
                    ],
                  ),
                )
                    : SizedBox.shrink(),

                // Price input
                _buildLabelCompact('قیمت (ریال)'),
                SizedBox(height: 4),
                Container(
                  height: isDesktop ? 48 : 56,
                  padding: EdgeInsets.only(bottom: isDesktop ? 2 : 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        child: IntrinsicHeight(
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'لطفا قیمت سفارش را وارد کنید';
                              }
                              return null;
                            },
                            controller: orderCreateController.priceController,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            style: AppTextStyle.labelText.copyWith(fontSize: 12),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[۰-۹0-9]')),
                            ],
                            onChanged: (value) {
                              String cleanedValue = value.replaceAll(',', '');
                              if (cleanedValue.isNotEmpty) {
                                orderCreateController.priceController.text =
                                    cleanedValue.toPersianDigit().seRagham();
                                orderCreateController.priceController.selection =
                                    TextSelection.collapsed(
                                      offset: orderCreateController.priceController.text.length,
                                    );
                              }
                              orderCreateController.updateTotalPrice();
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: isDesktop ? 12 : 16),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: AppColor.textFieldColor,
                            ),
                          ),
                        ),
                      ),
                      //SizedBox(width: 8),
                      /*SizedBox(
                        height: isDesktop ? 40 : 48,
                        child: ElevatedButton(
                          onPressed: () async {
                            await orderCreateController.fetchPriceFromSocket();
                          },
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(AppColor.primaryColor),
                            padding: WidgetStatePropertyAll(
                              EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                            ),
                            elevation: WidgetStatePropertyAll(1),
                            shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                          child: Text(
                            orderCreateController.selectedBuySell.value?.id == 0
                                ? 'افزودن قیمت فروش'
                                : 'افزودن قیمت خرید',
                            style: AppTextStyle.labelText.copyWith(color: Colors.white, fontSize: 11),
                          ),
                        ),
                      ),*/
                    ],
                  ),
                ),

                // Socket price display
                Obx(() {
                  orderCreateController.socketPrice.value;
                  orderCreateController.currentPrice.value;
                  return orderCreateController.socketPrice.value.isNotEmpty
                      ? Container(
                    margin: EdgeInsets.only(bottom: isDesktop ? 4 : 8),
                    padding: EdgeInsets.symmetric(horizontal: isDesktop ? 8 : 12, vertical: isDesktop ? 4 : 8),
                    decoration: BoxDecoration(
                      color: _getSocketPriceDisplayColor(),
                      border: Border.all(color: _getSocketPriceBorderColor(), width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              _getSocketPriceIcon(),
                              color: _getSocketPriceBorderColor(),
                              size: 16,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'قیمت آیتم: ',
                              style: AppTextStyle.labelText.copyWith(
                                color: AppColor.textColor.withAlpha(175),
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              _getSocketPriceValue(),
                              style: AppTextStyle.labelText.copyWith(
                                color: _getSocketPriceBorderColor(),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                           Tooltip(
                             message: "افزودن قیمت",
                             child: GestureDetector(
                               onTap: () async {
                                 await orderCreateController.fetchPriceFromSocket();
                               },
                               child: Transform.rotate(
                                angle: math.pi / 2,
                                child: SvgPicture.asset(
                                  'assets/svg/add-price.svg',
                                  height: 28,
                                  colorFilter: ColorFilter.mode(
                                    AppColor.primaryColor,
                                    BlendMode.srcIn,
                                ),
                                ),
                               ),
                             ),
                           ),
                        /*ElevatedButton(
                          onPressed: () async {
                            await orderCreateController.fetchPriceFromSocket();
                          },
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(AppColor.buttonColor),
                            padding: WidgetStatePropertyAll(
                              EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                            ),
                            elevation: WidgetStatePropertyAll(1),
                            shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                          child: Text(
                            orderCreateController.selectedBuySell.value?.id == 0
                                ? 'افزودن قیمت فروش'
                                : 'افزودن قیمت خرید',
                            style: AppTextStyle.bodyText.copyWith(color: Colors.white, fontSize: 10),
                          ),
                        ),*/
                      ],
                    ),
                  )
                      : SizedBox();
                }),
                // Price display row
                orderCreateController.selectedItem.value?.itemUnit?.name == 'گرم'
                    ? Container(
                  margin: EdgeInsets.symmetric(vertical: isDesktop ? 4 : 8),
                  padding: EdgeInsets.all(isDesktop ? 8 : 12),
                  decoration: BoxDecoration(
                    color: AppColor.textFieldColor.withAlpha(100),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColor.primaryColor.withAlpha(100)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'قیمت آیتم به گرم:',
                            style: AppTextStyle.labelText.copyWith(
                              fontSize: 11,
                              color: AppColor.textColor.withAlpha(180),
                            ),
                          ),
                          Text(
                            orderCreateController.priceTemp.value.seRagham(separator: ','),
                            style: AppTextStyle.labelText.copyWith(
                              fontSize: 12,
                              color: AppColor.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
                    : SizedBox.shrink(),

                // Quantity and Date row
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabelCompact('گرم/عدد'),
                          SizedBox(height: 4),
                          Container(
                            height: isDesktop ? 48 : 56,
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'لطفا مقدار سفارش را وارد کنید';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                if (_isValidatingQuantity) return;
                                // Cancel previous debounce timer if active
                                _limitCheckDebounce?.cancel();
                                // Check limit if value is not empty
                                if (value.isNotEmpty) {
                                  final enteredValue = double.tryParse(value.toEnglishDigit());
                                  if (enteredValue != null) {
                                    final limit = _getCurrentLimit();
                                    if (limit != null && enteredValue > limit) {
                                      // Debounce: wait for user to stop typing before showing dialog
                                      _limitCheckDebounce = Timer(const Duration(milliseconds: 500), () async {
                                        if (!_isDialogShowing) {
                                          _isDialogShowing = true;
                                          final shouldContinue = await _showLimitExceededDialog();
                                          _isDialogShowing = false;

                                          if (!shouldContinue) {
                                            // Cancel: clear the field as per requirement
                                            _isValidatingQuantity = true;
                                            orderCreateController.quantityController.clear();
                                            _isValidatingQuantity = false;
                                            // Update total price with cleared value
                                            orderCreateController.updateTotalPrice();
                                          }
                                        }
                                      });
                                    }
                                  }
                                }
                                orderCreateController.updateTotalPrice();
                              },
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              controller: orderCreateController.quantityController,
                              style: AppTextStyle.labelText.copyWith(fontSize: 12),
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'^[\d٠-٩۰-۹]*\.?[\d٠-٩۰-۹]*$'),
                                ),
                              ],
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: isDesktop ? 12 : 16),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: AppColor.textFieldColor,
                                errorMaxLines: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: isDesktop ? 8 : 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabelCompact('تاریخ سفارش'),
                          SizedBox(height: 4),
                          Container(
                            height: isDesktop ? 48 : 56,
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'لطفا تاریخ را انتخاب کنید';
                                }
                                return null;
                              },
                              controller: orderCreateController.dateController,
                              readOnly: true,
                              style: AppTextStyle.labelText.copyWith(fontSize: 11),
                              textDirection: TextDirection.ltr,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(top: 15,bottom: 15, right: isDesktop ? 5 : 5,),suffixIconConstraints: BoxConstraints(minWidth: 25),
                                suffixIcon: Icon(Icons.calendar_month, color: AppColor.textColor,size:isDesktop? 20 : 17,),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: AppColor.textFieldColor,
                                errorMaxLines: 1,
                              ),
                              onTap: () async {
                                Jalali? pickedDate = await showPersianDatePicker(
                                  context: context,
                                  initialDate: Jalali.now(),
                                  firstDate: Jalali(1400, 1, 1),
                                  lastDate: Jalali(1450, 12, 29),
                                  initialEntryMode: PersianDatePickerEntryMode.calendar,
                                  initialDatePickerMode: PersianDatePickerMode.day,
                                  locale: Locale("fa", "IR"),
                                );
                                DateTime date = DateTime.now();

                                if (pickedDate != null) {
                                  orderCreateController.dateController.text =
                                  "${pickedDate.year}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}";
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: isDesktop ? 4 : 12),

                // Total price
                _buildLabelCompact('مبلغ کل (ریال)'),
                SizedBox(height: 4),
                Container(
                  height: isDesktop ? 48 : 56,
                  padding: EdgeInsets.only(bottom: isDesktop ? 2 : 5),
                  child: TextFormField(
                    controller: orderCreateController.totalPriceController,
                    style: AppTextStyle.labelText.copyWith(fontSize: 12),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      String cleanedValue = value.replaceAll(',', '');
                      if (cleanedValue.isNotEmpty) {
                        orderCreateController.totalPriceController.text =
                            cleanedValue.toPersianDigit().seRagham();
                        orderCreateController.totalPriceController.selection =
                            TextSelection.collapsed(
                              offset: orderCreateController.totalPriceController.text.length,
                            );
                      }
                      orderCreateController.updateQuantity();
                    },
                    onTap: () {
                      orderCreateController.totalPriceController.selection = TextSelection(
                        baseOffset: 0,
                        extentOffset: orderCreateController.totalPriceController.text.length,
                      );
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: isDesktop ? 12 : 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: AppColor.textFieldColor,
                    ),
                  ),
                ),

                // Description
                _buildLabelCompact('توضیحات'),
                SizedBox(height: 4),
                Container(
                  padding: EdgeInsets.only(bottom: isDesktop ? 2 : 5),
                  child: TextFormField(
                    controller: orderCreateController.descriptionController,
                    maxLines: isDesktop ? 2 : 3,
                    style: AppTextStyle.labelText,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: isDesktop ? 12 : 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: AppColor.textFieldColor,
                    ),
                  ),
                ),

                SizedBox(height: isDesktop ? 8 : 16),

                // Submit button
                SizedBox(
                  width: double.infinity,
                  height: isDesktop ? 40 : 48,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 16)),
                      elevation: WidgetStatePropertyAll(1),
                      backgroundColor: WidgetStatePropertyAll(
                        orderCreateController.selectedBuySell.value?.id == 1
                            ? AppColor.primaryColor
                            : AppColor.accentColor,
                      ),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        if (orderCreateController.selectedAccount.value != null) {
                          if (_isPriceOverOnePercent()) {
                            Get.defaultDialog(
                              backgroundColor: AppColor.backGroundColor,
                              title: "اخطار قیمت",
                              titleStyle: AppTextStyle.smallTitleText,
                              middleText:
                              "قیمت در محدوده غیر مجاز است. آیا مایل به ادامه دادن هستید؟",
                              middleTextStyle: AppTextStyle.bodyText,
                              confirm: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(AppColor.primaryColor),
                                ),
                                onPressed: () {
                                  Get.back();
                                  _showConfirmDialog();
                                },
                                child: Text('ادامه', style: AppTextStyle.bodyText),
                              ),
                              cancel: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(AppColor.accentColor),
                                ),
                                onPressed: () => Get.back(),
                                child: Text('لغو', style: AppTextStyle.bodyText),
                              ),
                            );
                          } else {
                            _showConfirmDialog();
                          }
                        } else {
                          orderCreateController.dropdownError.value = 'لطفا کاربر را انتخاب کنید';
                        }
                      }
                    },
                    child: orderCreateController.isLoading.value
                        ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor),
                    )
                        : Text(
                      orderCreateController.selectedBuySell.value?.id == 1
                          ? 'خرید'
                          : 'فروش',
                      style: AppTextStyle.labelText.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  Widget _buildLabel(String text) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    return Container(
      padding: EdgeInsets.only(bottom: 3, top: 5),
      child: Text(
        text,
        style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 12 : 10),
      ),
    );
  }

  Widget _buildLabelCompact(String text) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    return Container(
      padding: EdgeInsets.only(bottom: isDesktop ? 1 : 3, top: isDesktop ? 2 : 5),
      child: Text(
        text,
        style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 11 : 10),
      ),
    );
  }

  /// Get most-used products (items with id == 1 and id == 2)
  List<ItemModel> _getMostUsedProducts() {
    return orderCreateController.itemList
        .where((item) => item.id == 1 || item.id == 2 || item.id == 3)
        .toList();
  }

  /// Build a clickable card for most-used products
  Widget _buildMostUsedProductCard(ItemModel item, bool isSelected, bool isDesktop) {
    return GestureDetector(
      onTap: () {
        orderCreateController.changeSelectedItem(item);
      },
      child: Obx(() {
        final buySellId = orderCreateController.selectedBuySell.value?.id;
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: 4,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? (buySellId == 0
                ? AppColor.accentColor.withAlpha(30)
                : AppColor.primaryColor.withAlpha(30))
                : AppColor.secondary200Color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? (buySellId == 0
                  ? AppColor.accentColor.withAlpha(200)
                  : AppColor.primaryColor.withAlpha(200))
                  : AppColor.secondary200Color,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Center(
            child: Text(
              item.name ?? '',
              style: AppTextStyle.labelText.copyWith(
                fontSize: isDesktop ? 10 : 9,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.bold,
                color: isSelected
                    ? (buySellId == 0
                    ? AppColor.accentColor
                    : AppColor.primaryColor)
                    : AppColor.dividerColor,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      }),
    );
  }

  /// Get the current limit (maxSell for sell, maxBuy for buy)
  double? _getCurrentLimit() {
    final accountLevelItem = orderCreateController.selectedAccountLevelItem.value;
    if (accountLevelItem == null ||
        accountLevelItem.accountLevelItems == null ||
        accountLevelItem.accountLevelItems!.isEmpty) {
      return null;
    }

    final item = accountLevelItem.accountLevelItems!.first;
    final buySellId = orderCreateController.selectedBuySell.value?.id;

    // id == 0 means sell, id == 1 means buy
    if (buySellId == 0) {
      // Sell order - check maxSell
      return item.maxSell;
    } else if (buySellId == 1) {
      // Buy order - check maxBuy
      return item.maxBuy;
    }

    return null;
  }

  /// Show dialog when entered amount exceeds the allowed limit
  Future<bool> _showLimitExceededDialog() async {
    bool? result = false;

    await Get.defaultDialog(
      backgroundColor: AppColor.backGroundColor,
      title: "هشدار",
      titleStyle: AppTextStyle.smallTitleText,
      middleText: "مقدار وارد شده از حد مجاز سطح بیشتر است",
      middleTextStyle: AppTextStyle.bodyText,
      confirm: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(AppColor.primaryColor),
        ),
        onPressed: () {
          result = true;
          Get.back();
        },
        child: Text('ادامه', style: AppTextStyle.bodyText),
      ),
      cancel: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(AppColor.accentColor),
        ),
        onPressed: () {
          result = false;
          Get.back();
        },
        child: Text('لغو', style: AppTextStyle.bodyText),
      ),
    );

    return result ?? false;
  }

}

