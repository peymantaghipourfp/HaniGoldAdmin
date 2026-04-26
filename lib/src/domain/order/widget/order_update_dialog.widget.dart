import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/const/app_color.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:hanigold_admin/src/domain/order/controller/order_update.controller.dart';
import 'package:hanigold_admin/src/widget/custom_dropdown.widget.dart';
import 'package:hanigold_admin/src/widget/custom_dropdown1.widget.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../account/model/account.model.dart';
import '../../account/widget/account_level_get_one_item.widget.dart';
import '../../accountSalesGroup/widget/account_sales_group_get_one_item.widget.dart';
import '../../users/widgets/balance.widget.dart';

class OrderUpdateDialogWidget extends StatefulWidget {
  final int orderId;

  const OrderUpdateDialogWidget({super.key, required this.orderId});

  @override
  State<OrderUpdateDialogWidget> createState() => _OrderUpdateDialogWidgetState();
}

class _OrderUpdateDialogWidgetState extends State<OrderUpdateDialogWidget>
    with SingleTickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  late TabController _tabController;
  late OrderUpdateController orderUpdateController;
  bool _isInitialized = false;

  // For draggable functionality
  Offset _dialogOffset = Offset.zero;
  // For quantity validation
  bool _isValidatingQuantity = false;
  Timer? _limitCheckDebounce;
  bool _isDialogShowing = false;

  OrderUpdateController _getOrUpdateController() {
    if (Get.isRegistered<OrderUpdateController>()) {
      final controller = Get.find<OrderUpdateController>();
      // Re-initialize with new order ID if different
      if (controller.orderId.value != widget.orderId) {
        Get.delete<OrderUpdateController>(force: true);
        return Get.put(OrderUpdateController());
      }
      return controller;
    } else {
      return Get.put(OrderUpdateController());
    }
  }

  @override
  void initState() {
    super.initState();
    orderUpdateController = _getOrUpdateController();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
    _initializeOrder();
  }

  Future<void> _initializeOrder() async {
    orderUpdateController.orderId.value = widget.orderId;
    await orderUpdateController.fetchGetOneOrder(widget.orderId);
    if (orderUpdateController.getOneOrder.value != null) {
      orderUpdateController.existingOrder = orderUpdateController.getOneOrder.value!;
      orderUpdateController.setOrderDetails(orderUpdateController.existingOrder);
      // Set tab based on order type
      if (orderUpdateController.selectedBuySell.value?.id == 1) {
        _tabController.index = 1; // Buy
      } else {
        _tabController.index = 0; // Sell
      }
    }
    setState(() {
      _isInitialized = true;
    });
  }

  void _handleTabChange() {
    if (!_tabController.indexIsChanging) {
      // Tab 0 = فروش (Sell) -> type 0
      // Tab 1 = خرید (Buy) -> type 1
      int typeId = _tabController.index == 0 ? 0 : 1;
      var selectedType = orderUpdateController.orderTypeList.firstWhere(
            (t) => t.id == typeId,
        orElse: () => orderUpdateController.orderTypeList.first,
      );
      orderUpdateController.changeSelectedBuySell(selectedType);
      setState(() {});
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    _limitCheckDebounce?.cancel();
    super.dispose();
  }

  String formatQuantity(double value) {
    if (value == value.truncate()) {
      return value.toInt().toString();
    } else {
      return value.toStringAsFixed(2);
    }
  }

  void _showConfirmDialog() {
    bool isBuy = orderUpdateController.selectedBuySell.value?.id == 1;
    String title = isBuy ? "ویرایش سفارش خرید" : "ویرایش سفارش فروش";
    String detailTitle = isBuy ? "جزئیات خرید" : "جزئیات فروش";
    String priceLabel = isBuy ? "قیمت خرید:" : "قیمت فروش:";

    Get.defaultDialog(
      backgroundColor: AppColor.backGroundColor,
      title: title,
      titleStyle: AppTextStyle.smallTitleText,
      middleText: "آیا از ویرایش سفارش مطمئن هستید؟",
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
              _buildDetailRow('نام کاربر:', orderUpdateController.selectedAccount.value?.name ?? ''),
              SizedBox(height: 5),
              _buildDetailRow('محصول:', orderUpdateController.selectedItem.value?.name ?? ''),
              SizedBox(height: 5),
              _buildDetailRow(
                'مقدار:',
                formatQuantity(
                  double.tryParse(orderUpdateController.quantityController.text) ?? 0,
                ),
              ),
              SizedBox(height: 5),
              _buildDetailRow(
                priceLabel,
                orderUpdateController.priceController.text.seRagham(separator: ','),
              ),
              SizedBox(height: 5),
              _buildDetailRow(
                'مبلغ کل:',
                orderUpdateController.totalPriceController.text.seRagham(separator: ','),
              ),
              SizedBox(height: 5),
              _buildDetailRow('تاریخ:', orderUpdateController.dateController.text),
            ],
          ),
        ),
      ),
      confirm: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(
            AppColor.primaryColor,
          ),
        ),
        onPressed: () async {
          await orderUpdateController.updateOrder();
        },
        child: Text('ویرایش', style: AppTextStyle.bodyText),
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
            textDirection: TextDirection.ltr,
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
            maxHeight: Get.height * 0.9,
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
                          Text('ویرایش سفارش', style: AppTextStyle.smallTitleText),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          orderUpdateController.clearList();
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
                child: IgnorePointer(
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
              ),
              // Content
              Flexible(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: !_isInitialized
                      ? Center(child: CircularProgressIndicator())
                      : Obx(() {
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
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Row(
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
                  orderUpdateController.isLoadingBalance.value == true
                      ? Center(child: CircularProgressIndicator())
                      : LayoutBuilder(
                      builder: (context, constraints) {
                          return BalanceWidget(
                            title: orderUpdateController.selectedAccount.value?.name,
                            listBalance: orderUpdateController.balanceList,
                            size: constraints.maxWidth,
                          );
                        }
                      ),
                  _buildErrorWidget(),
                  const SizedBox(height: 8),
                  Obx(() {
                    return AccountSalesGroupGetOneItemWidget(
                      data: orderUpdateController.selectedAccountSalesGroupItem.value,
                      width: double.infinity,
                      title: orderUpdateController
                          .selectedAccount.value?.accountSalesGroup?.name,
                      isLoading:
                      orderUpdateController.isLoadingAccountSalesGroupItem.value,
                      selectedItemId: orderUpdateController.selectedItem.value?.id,
                      selectedBuySellId: orderUpdateController.selectedBuySell.value?.id,
                      onPriceSelected: (mesghalPrice) {
                        orderUpdateController.setPriceFromSalesGroup(mesghalPrice);
                      },
                    );
                  }),
                  const SizedBox(height: 8),
                  Obx(() {
                    return AccountLevelGetOneItemWidget(
                      data: orderUpdateController.selectedAccountLevelItem.value,
                      width: double.infinity,
                      title: orderUpdateController
                          .selectedAccount.value?.accountLevel?.name,
                      isLoading:
                      orderUpdateController.isLoadingAccountLevelItem.value,
                    );
                  }),
                ],
              ),
          ),

        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        orderUpdateController.isLoadingBalance.value == true
            ? Center(child: CircularProgressIndicator())
            : BalanceWidget(
          title: orderUpdateController.selectedAccount.value?.name,
          listBalance: orderUpdateController.balanceList,
          size: double.infinity,
        ),
        _buildErrorWidget(),
        const SizedBox(height: 8),
        Obx(() {
          return AccountSalesGroupGetOneItemWidget(
            data: orderUpdateController.selectedAccountSalesGroupItem.value,
            width: double.infinity,
            title: orderUpdateController
                .selectedAccount.value?.accountSalesGroup?.name,
            isLoading: orderUpdateController.isLoadingAccountSalesGroupItem.value,
            selectedItemId: orderUpdateController.selectedItem.value?.id,
            selectedBuySellId: orderUpdateController.selectedBuySell.value?.id,
            onPriceSelected: (mesghalPrice) {
              orderUpdateController.setPriceFromSalesGroup(mesghalPrice);
            },
          );
        }),
        const SizedBox(height: 8),
        Obx(() {
          return AccountLevelGetOneItemWidget(
            data: orderUpdateController.selectedAccountLevelItem.value,
            width: double.infinity,
            title: orderUpdateController
                .selectedAccount.value?.accountLevel?.name,
            isLoading: orderUpdateController.isLoadingAccountLevelItem.value,
          );
        }),
        SizedBox(height: 16),
        _buildOrderForm(),
      ],
    );
  }

  Widget _buildErrorWidget() {
    return Obx(() => orderUpdateController.errorMessage.value.isNotEmpty
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
            child: Text(
              orderUpdateController.errorMessage.value,
              style: AppTextStyle.bodyText.copyWith(
                color: Colors.red.shade600,
                fontSize: 12,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => orderUpdateController.errorMessage.value = '',
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
            color:orderUpdateController.selectedBuySell.value?.id == 0 ? AppColor.accentColor.withAlpha(20) : AppColor.primaryColor.withAlpha(20),
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
                orderUpdateController.accountList.isEmpty
                    ? Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor),
                  ),
                )
                    : Container(
                  padding: EdgeInsets.only(bottom: 5),
                  child: CustomDropdown<AccountModel>(
                    items: orderUpdateController.accountList,
                    selectedItem: orderUpdateController.selectedAccount.value,
                    enableSearch: true,
                    errorText: orderUpdateController.dropdownError.value,
                    itemLabel: (account) => account.name ?? "",
                    onChanged: (account) {
                      setState(() {
                        orderUpdateController.selectedAccount.value = account;
                        orderUpdateController.dropdownError.value = "";
                        orderUpdateController.changeSelectedAccount(account);
                      });
                    },
                    isIcon: false,
                  ),
                ),

                // Product selection
                _buildLabelCompact('انتخاب محصول'),
                SizedBox(height: 4),
                Container(
                  padding: EdgeInsets.only(bottom: isDesktop ? 2 : 5),
                  child: CustomDropdownWidget(
                    validator: (value) {
                      if (value == 'انتخاب کنید' || value == null || value.isEmpty) {
                        return 'محصول را انتخاب کنید';
                      }
                      return null;
                    },
                    items: [
                      'انتخاب کنید',
                      ...orderUpdateController.itemList.map((item) => item.name ?? '')
                    ].toList(),
                    selectedValue: orderUpdateController.selectedItem.value?.name,
                    onChanged: (String? newValue) {
                      if (newValue == 'انتخاب کنید') {
                        orderUpdateController.changeSelectedItem(null);
                      } else {
                        var selectedItem = orderUpdateController.itemList.firstWhere(
                              (item) => item.name == newValue,
                        );
                        orderUpdateController.changeSelectedItem(selectedItem);
                      }
                    },
                    backgroundColor: AppColor.textFieldColor,
                    borderRadius: 7,
                    borderColor: AppColor.secondaryColor,
                    hideUnderline: true,
                  ),
                ),

                // Card reader checkbox
                orderUpdateController.selectedBuySell.value?.id == 0 &&
                    orderUpdateController.selectedItem.value?.hasCard == true
                    ? Container(
                  padding: EdgeInsets.only(bottom: 5),
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
                        value: orderUpdateController.isCardChecked.value,
                        onChanged: (value) async {
                          orderUpdateController.isCardChecked.value = value!;
                          if (value) {
                            orderUpdateController.priceController.text =
                                ((orderUpdateController.selectedItem.value!.mesghalPrice)! +
                                    (orderUpdateController.selectedItem.value?.cardPrice)!
                                        .toDouble())
                                    .toString()
                                    .seRagham(separator: ',');
                          } else {
                            orderUpdateController.priceController.text =
                                (orderUpdateController.selectedItem.value!.mesghalPrice)
                                    .toString()
                                    .seRagham(separator: ',');
                          }
                          orderUpdateController.updateTotalPrice();
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
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'لطفا قیمت سفارش را وارد کنید';
                      }
                      return null;
                    },
                    controller: orderUpdateController.priceController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    style: AppTextStyle.labelText.copyWith(fontSize: 12),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[۰-۹0-9]')),
                    ],
                    onChanged: (value) {
                      String cleanedValue = value.replaceAll(',', '');
                      if (cleanedValue.isNotEmpty) {
                        orderUpdateController.priceController.text =
                            cleanedValue.toPersianDigit().seRagham();
                        orderUpdateController.priceController.selection =
                            TextSelection.collapsed(
                              offset: orderUpdateController.priceController.text.length,
                            );
                      }
                      orderUpdateController.updateTotalPrice();
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

                // Price display row
                orderUpdateController.selectedItem.value?.itemUnit?.name == 'گرم'
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
                            orderUpdateController.priceTemp.value.seRagham(separator: ','),
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
                                            orderUpdateController.quantityController.clear();
                                            _isValidatingQuantity = false;
                                            // Update total price with cleared value
                                            orderUpdateController.updateTotalPrice();
                                          }
                                        }
                                      });
                                    }
                                  }
                                }
                                orderUpdateController.updateTotalPrice();
                              },
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              controller: orderUpdateController.quantityController,
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
                              controller: orderUpdateController.dateController,
                              readOnly: true,
                              style: AppTextStyle.labelText.copyWith(fontSize: 10),
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
                                // انتخاب تاریخ
                                Jalali? pickedDate = await showPersianDatePicker(
                                  context: context,
                                  initialDate: Jalali.now(),
                                  firstDate: Jalali(1400, 1, 1),
                                  lastDate: Jalali(1450, 12, 29),
                                  initialEntryMode: PersianDatePickerEntryMode.calendar,
                                  initialDatePickerMode: PersianDatePickerMode.day,
                                  locale: const Locale("fa", "IR"),
                                );

                                if (pickedDate != null) {
                                  // انتخاب زمان
                                  TimeOfDay? pickedTime = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                    builder: (context, child) {
                                      return Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: child!,
                                      );
                                    },
                                  );
                                  if (pickedTime != null) {
                                    final formattedDate =
                                        "${pickedDate.year}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.day.toString().padLeft(2, '0')}";
                                    final formattedTime =
                                        "${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}";

                                    orderUpdateController.dateController.text = "$formattedDate $formattedTime";
                                  }
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
                    controller: orderUpdateController.totalPriceController,
                    style: AppTextStyle.labelText.copyWith(fontSize: 12),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      String cleanedValue = value.replaceAll(',', '');
                      if (cleanedValue.isNotEmpty) {
                        orderUpdateController.totalPriceController.text =
                            cleanedValue.toPersianDigit().seRagham();
                        orderUpdateController.totalPriceController.selection =
                            TextSelection.collapsed(
                              offset: orderUpdateController.totalPriceController.text.length,
                            );
                      }
                      orderUpdateController.updateQuantity();
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
                    controller: orderUpdateController.descriptionController,
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
                        orderUpdateController.selectedBuySell.value?.id == 1
                            ? AppColor.primaryColor
                            : AppColor.accentColor,
                      ),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        if (orderUpdateController.selectedAccount.value != null) {
                          _showConfirmDialog();
                        } else {
                          orderUpdateController.dropdownError.value = 'لطفا کاربر را انتخاب کنید';
                        }
                      }
                    },
                    child: orderUpdateController.isLoading.value
                        ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor),
                    )
                        : Text(
                      'ویرایش سفارش',
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

  /// Get the current limit (maxSell for sell, maxBuy for buy)
  double? _getCurrentLimit() {
    final accountLevelItem = orderUpdateController.selectedAccountLevelItem.value;
    if (accountLevelItem == null ||
        accountLevelItem.accountLevelItems == null ||
        accountLevelItem.accountLevelItems!.isEmpty) {
      return null;
    }

    final item = accountLevelItem.accountLevelItems!.first;
    final buySellId = orderUpdateController.selectedBuySell.value?.id;

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
  /// Returns true if user clicks Continue, false if Cancel
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

