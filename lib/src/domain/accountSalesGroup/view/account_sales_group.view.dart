import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../config/repository/url/base_url.dart';
import '../../../widget/app_drawer.widget.dart';
import '../../../widget/background_image_total.widget.dart';
import '../../../widget/custom_appbar1.widget.dart';
import '../../../widget/err_page.dart';
import '../../accountSalesGroup/controller/account_sales_group.controller.dart';
import '../model/account_sales_group.model.dart';
import '../widget/assign_accounts_dialog.widget.dart';

class AccountSalesGroupView extends GetView<AccountSalesGroupController> {
  const AccountSalesGroupView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    return Obx(() => Scaffold(
      appBar: CustomAppbar1(
        title: 'لیست گروه های قیمت گذاری',
        onBackTap: () => Get.offNamed('/home'),
      ),
      drawer: const AppDrawer(),
      body: Stack(
        children: [
          BackgroundImageTotal(),
          SafeArea(
            child: controller.state.value == PageState.loading
                ? const Center(child: CircularProgressIndicator())
                : controller.state.value == PageState.list
                ? (isDesktop
                ? SizedBox(
                height: Get.height,
                width: Get.width,
                child: _buildDesktopTable(context))
                : _buildMobileList(context))
                : Center(
              child: ErrPage(
                callback: () {
                  controller.getAccountSalesGroupList();
                },
                title: "خطا در دریافت لیست",
                des: 'دوباره تلاش کنید',
              ),
            ),
          ),
        ],
      ),
    ));
  }

  Widget _buildDesktopTable(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      color: AppColor.backGroundColor1.withAlpha(100),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SingleChildScrollView(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Get.toNamed('/insertAccountSalesGroup');
                              },
                              icon: const Icon(Icons.add),
                              label: const Text('افزودن گروه قیمت گذاری جدید'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColor.buttonColor,
                                foregroundColor: AppColor.textColor,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: Get.width*0.8,
                            ),
                            child: DataTable(
                              columns: _buildDataColumns(),
                              decoration: BoxDecoration(
                                color: AppColor.secondary2Color.withAlpha(30),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColor.textColor.withAlpha(75)),
                              ),
                              border: TableBorder.symmetric(
                                inside: BorderSide(color: AppColor.textColor, width: 0.3),
                                outside: BorderSide(color: AppColor.textColor, width: 0.3),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              dividerThickness: 0.3,
                              rows: _buildDataRows(context),
                              headingRowColor: WidgetStatePropertyAll(AppColor.buttonColor.withAlpha(40)),
                              headingRowHeight: 40,
                              columnSpacing: 40,
                              horizontalMargin: 8,
                              //dataRowMaxHeight: 65,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<DataColumn> _buildDataColumns() {
    return [
      DataColumn(
        label:  Text('ردیف', style: AppTextStyle.labelText),
        headingRowAlignment: MainAxisAlignment.center,
      ),
      DataColumn(
        label: Text('نام گروه قیمت گذاری (تعداد اکانت)', style: AppTextStyle.labelText.copyWith(fontSize: 11)),
        headingRowAlignment: MainAxisAlignment.center,
      ),
      /*const DataColumn(
        label: Text('رنگ'),
        headingRowAlignment: MainAxisAlignment.center,
      ),*/
      const DataColumn(
        label: Text('عملیات',style: AppTextStyle.labelText),
        headingRowAlignment: MainAxisAlignment.center,
      ),
    ];
  }

  List<DataRow> _buildDataRows(BuildContext context) {
    return controller.accountSalesGroupList.asMap().entries.map((entry) {
      final index = entry.key;
      final sub = entry.value;
      final rowColor = index.isEven
          ? AppColor.backGroundColor
          : AppColor.secondaryColor.withAlpha(100);
      return DataRow(
          color: WidgetStateProperty.all(rowColor),
          cells: [
            DataCell(Center(
              child: Text("${sub.rowNum ?? ''}", style: AppTextStyle.bodyText),
            )),
            DataCell(Center(
              child: Text("${sub.name ?? ""} (${sub.accountCount})" , style: AppTextStyle.bodyText.copyWith(fontSize: 11)),
            )),
            /*DataCell(Center(
        child: _ColorDot(hexColor: sub.color),
      )),*/
            DataCell(Center(
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // جزئیات گروه
                  Tooltip(
                    message: "جزئیات گروه",
                    child: GestureDetector(
                      onTap: () {
                        _showDetailsDialog(context, sub.id ?? 0, isDesktop: true);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: AppColor.secondary3Color.withAlpha(40),
                        ),
                        padding: EdgeInsets.all(5),
                        child: Icon(Icons.info_outline, size: 20, color: AppColor.secondary3Color),
                      ),
                    ),
                  ),
                  // ویرایش گروه
                  Tooltip(
                    message: "ویرایش گروه",
                    child: GestureDetector(
                      onTap: () {
                        final id = sub.id ?? 0;
                        if (id > 0) {
                          Get.toNamed('/updateAccountSalesGroup', arguments: {'id': id});
                        } else {
                          Get.snackbar('خطا', 'شناسه زیرگروه نامعتبر است', snackPosition: SnackPosition.BOTTOM, backgroundColor: AppColor.accentColor, colorText: AppColor.textColor);
                        }
                      },
                      child: SvgPicture.asset(
                          'assets/svg/edit.svg',height: 25,
                          colorFilter: ColorFilter
                              .mode(AppColor
                              .dividerColor,
                            BlendMode.srcIn,)
                      ),
                    ),
                  ),
                  //حذف گروه
                  Tooltip(
                    message: "حذف گروه",
                    child: GestureDetector(
                      onTap: () {
                        Get.defaultDialog(
                            backgroundColor: AppColor.backGroundColor,
                            title: "حذف گروه",
                            titleStyle: AppTextStyle.smallTitleText,
                            middleText: "آیا از حذف گروه مطمئن هستید؟",
                            middleTextStyle: AppTextStyle.bodyText,
                            confirm: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(
                                        AppColor.primaryColor)),
                                onPressed: () {
                                  controller.deleteAccountSalesGroup(sub.id ?? 0, true);
                                },
                                child: Text(
                                  'حذف',
                                  style: AppTextStyle.bodyText,
                                )));
                      },
                      child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),color: AppColor.accentColor.withAlpha(40)),
                          padding: EdgeInsets.all(5),
                          child: SvgPicture.asset('assets/svg/trash-bin.svg', height: 25, colorFilter: ColorFilter.mode(AppColor.accentColor.withAlpha(200), BlendMode.srcIn))),
                    ),
                  ),
                  // اختصاص حساب
                  Tooltip(
                    message: "اختصاص حساب",
                    child: GestureDetector(
                      onTap: () {
                        if ((sub.id ?? 0) > 0) {
                          _showAssignAccountsDialog(context, sub,
                              isDesktop: true);
                        } else {
                          Get.snackbar(
                            'خطا',
                            'شناسه زیرگروه نامعتبر است',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: AppColor.accentColor,
                            colorText: AppColor.textColor,
                          );
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: AppColor.primaryColor.withAlpha(40),
                        ),
                        padding: const EdgeInsets.all(5),
                        child: Icon(Icons.group_add_outlined,
                            size: 20, color: AppColor.primaryColor),
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ]);
    }
    ).toList();
  }

  Widget _buildMobileList(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Get.toNamed('/insertAccountSalesGroup');
              },
              icon: const Icon(Icons.add),
              label: const Text('افزودن گروه قیمت گذاری جدید'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.buttonColor,
                foregroundColor: AppColor.textColor,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(width: 10,),
          Expanded(
            child: ListView.builder(
              itemCount: controller.accountSalesGroupList.length,
              itemBuilder: (ctx, index) {
                final sub = controller.accountSalesGroupList[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColor.secondary100Color, AppColor.secondaryColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColor.textColor.withAlpha(75)),
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text("${sub.rowNum ?? ''}", style: AppTextStyle.labelText.copyWith(fontSize: 10, color: AppColor.textColor.withAlpha(200)))),

                      ],
                    ),
                    const SizedBox(height: 8),
                    Divider(height: 0.5, color: AppColor.dividerColor),
                    const SizedBox(height: 5),
                    //_mobileLine('بیعانه', sub.deposit?.toStringAsFixed(0).seRagham() ?? "" , trailing: 'ریال'),
                    //_mobileLine('بالانس', sub.balance?.toStringAsFixed(0).seRagham() ?? "" , trailing: 'ریال'),
                    /*Row(children: [
                      Text('رنگ:', style: AppTextStyle.labelText.copyWith(fontSize: 11, color: AppColor.textColor)),
                      const SizedBox(width: 6),
                      _ColorDot(hexColor: sub.color),
                    ]),*/
                    const SizedBox(height: 8),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "${sub.name ?? ""} (${sub.accountCount})",
                            style: AppTextStyle.labelText.copyWith(fontSize: 13, fontWeight: FontWeight.bold, color: AppColor.textColor),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          children: [
                            // جزئیات گروه
                            GestureDetector(
                              onTap: () {
                                _showDetailsDialog(context, sub.id ?? 0, isDesktop: false);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: AppColor.secondary3Color.withAlpha(40),
                                ),
                                padding: EdgeInsets.all(5),
                                child: Icon(Icons.info_outline, size: 22, color: AppColor.secondary3Color),
                              ),
                            ),
                            SizedBox(width: 15,),
                            // ویرایش گروه
                            GestureDetector(
                              onTap: () {
                                final id = sub.id ?? 0;
                                if (id > 0) {
                                  Get.toNamed('/updateAccountSalesGroup', arguments: {'id': id});
                                } else {
                                  Get.snackbar('خطا', 'شناسه زیرگروه نامعتبر است', snackPosition: SnackPosition.BOTTOM, backgroundColor: AppColor.accentColor, colorText: AppColor.textColor);
                                }
                              },
                              child: SvgPicture.asset(
                                  'assets/svg/edit.svg',height: 25,
                                  colorFilter: ColorFilter
                                      .mode(AppColor
                                      .dividerColor,
                                    BlendMode.srcIn,)
                              ),
                            ),
                            SizedBox(width: 15,),
                            //حذف گروه
                            GestureDetector(
                              onTap: () {
                                Get.defaultDialog(
                                    backgroundColor: AppColor.backGroundColor,
                                    title: "حذف گروه",
                                    titleStyle: AppTextStyle.smallTitleText,
                                    middleText: "آیا از حذف گروه مطمئن هستید؟",
                                    middleTextStyle: AppTextStyle.bodyText,
                                    confirm: ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor: WidgetStatePropertyAll(
                                                AppColor.primaryColor)),
                                        onPressed: () {
                                          controller.deleteAccountSalesGroup(sub.id ?? 0, true);
                                        },
                                        child: Text(
                                          'حذف',
                                          style: AppTextStyle.bodyText,
                                        )));
                              },
                              child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),color: AppColor.accentColor.withAlpha(40)),
                                  padding: EdgeInsets.all(5),
                                  child: SvgPicture.asset('assets/svg/trash-bin.svg', height: 25, colorFilter: ColorFilter.mode(AppColor.accentColor.withAlpha(200), BlendMode.srcIn))),
                            ),
                            // اختصاص حساب
                            SizedBox(
                              width: 15,
                            ),
                            GestureDetector(
                              onTap: () {
                                if ((sub.id ?? 0) > 0) {
                                  _showAssignAccountsDialog(context, sub,
                                      isDesktop: false);
                                } else {
                                  Get.snackbar(
                                    'خطا',
                                    'شناسه زیرگروه نامعتبر است',
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: AppColor.accentColor,
                                    colorText: AppColor.textColor,
                                  );
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color:
                                  AppColor.primaryColor.withAlpha(40),
                                ),
                                padding: const EdgeInsets.all(5),
                                child: Icon(Icons.group_add_outlined,
                                    size: 22, color: AppColor.primaryColor),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /*Widget _mobileLine(String label, String value, {String? trailing}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label, style: AppTextStyle.labelText.copyWith(fontSize: 11, color: AppColor.textColor))),
          const SizedBox(width: 8),
          Row(children: [
            Text(value, style: AppTextStyle.labelText.copyWith(fontSize: 12, color: AppColor.textColor, fontWeight: FontWeight.bold), textDirection: TextDirection.ltr),
            if (trailing != null) ...[
              const SizedBox(width: 4),
              Text(trailing, style: AppTextStyle.labelText.copyWith(fontSize: 10, color: AppColor.textColor, fontWeight: FontWeight.bold)),
            ]
          ])
        ],
      ),
    );
  }*/

  void _showDetailsDialog(BuildContext context, int accountSalesGroupId, {required bool isDesktop}) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return FutureBuilder(
          future: controller.getOneAccountSalesGroup(accountSalesGroupId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Dialog(
                backgroundColor: AppColor.backGroundColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Container(
                  width: isDesktop ? Get.width * 0.5 : Get.width * 0.9,
                  padding: const EdgeInsets.all(40),
                  child: const Center(child: CircularProgressIndicator()),
                ),
              );
            }

            if (snapshot.hasError || !snapshot.hasData) {
              return Dialog(
                backgroundColor: AppColor.backGroundColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Container(
                  width: isDesktop ? Get.width * 0.5 : Get.width * 0.9,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'خطا',
                        style: AppTextStyle.labelText.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'خطا در دریافت جزئیات',
                        style: AppTextStyle.bodyText,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primaryColor,
                          foregroundColor: AppColor.textColor,
                        ),
                        child: const Text('بستن'),
                      ),
                    ],
                  ),
                ),
              );
            }

            final accountSalesGroup = snapshot.data!;

            return Dialog(
              backgroundColor: AppColor.backGroundColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Container(
                width: isDesktop ? Get.width * 0.6 : Get.width * 0.9,
                constraints: BoxConstraints(
                  maxHeight: Get.height * 0.8,
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'جزئیات گروه قیمت گذاری',
                          style: AppTextStyle.labelText.copyWith(
                            fontSize: isDesktop ? 20 : 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.of(dialogContext).pop(),
                          color: AppColor.textColor,
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    // Group Name
                    Text(
                      'نام گروه:',
                      style: AppTextStyle.labelText.copyWith(
                        fontSize: isDesktop ? 14 : 13,
                        fontWeight: FontWeight.bold,
                        color: AppColor.textColor.withAlpha(175),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColor.dividerColor.withAlpha(40),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFF64748B)),
                          ),
                          child: Text(
                            accountSalesGroup.name ?? 'نامشخص',
                            style: AppTextStyle.bodyText.copyWith(
                              fontSize: isDesktop ? 15 : 14,
                              color: AppColor.dividerColor.withAlpha(200)
                            ),
                          ),
                        ),
                        SizedBox(width: 10,),
                        Row(
                          children: [
                            Text(
                              'تعداد اکانت: ',
                              style: AppTextStyle.labelText.copyWith(
                                fontSize: isDesktop ? 12 : 11,
                                fontWeight: FontWeight.bold,
                                color: AppColor.textColor.withAlpha(175),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                              padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                              decoration: BoxDecoration(
                                color: AppColor.textPrimaryColor.withAlpha(40),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: const Color(0xFF64748B)),
                              ),
                              child: Text(
                                "(${accountSalesGroup.accountCount ?? 0})",
                                style: AppTextStyle.bodyText.copyWith(
                                    fontSize: isDesktop ? 14 : 13,
                                    color: AppColor.primaryColor
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Item Prices Section
                    Text(
                      'لیست محدوده قیمت محصولات:',
                      style: AppTextStyle.labelText.copyWith(
                        fontSize: isDesktop ? 14 : 13,
                        fontWeight: FontWeight.bold,
                        color: AppColor.textColor.withAlpha(175),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Item Prices List
                    Flexible(
                      child: (accountSalesGroup.accountSalesGroupItems == null || accountSalesGroup.accountSalesGroupItems!.isEmpty)
                          ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(40),
                          child: Text(
                            'هیچ محصولی ثبت نشده است',
                            style: AppTextStyle.bodyText.copyWith(
                              color: AppColor.textColor.withAlpha(130),
                            ),
                          ),
                        ),
                      )
                          : ListView.builder(
                        shrinkWrap: true,
                        itemCount: accountSalesGroup.accountSalesGroupItems!.length,
                        itemBuilder: (context, index) {
                          final itemPrice = accountSalesGroup.accountSalesGroupItems![index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12,),
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [AppColor.secondary10Color, AppColor.backGroundColor1],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black45,
                                  blurRadius: 5,
                                  offset: const Offset(0,3),
                                ),
                              ],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColor.textColor.withAlpha(50),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Image.network('${BaseUrl.baseUrl}Attachment/downloadResource?fileName=${itemPrice.itemIcon}',
                                      width: 25,
                                      height: 25,),
                                    SizedBox(width: 5,),
                                    Text(
                                      itemPrice.itemName ?? 'نامشخص',
                                      style: AppTextStyle.labelText.copyWith(
                                        fontSize: isDesktop ? 14 : 13,
                                        fontWeight: FontWeight.bold,
                                        color: AppColor.dividerColor.withAlpha(220)
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: _buildPriceInfo(
                                        'محدوده خرید:',
                                    (itemPrice.buyRange ?? 0 ) < 0 ? "-${itemPrice.buyRange?.abs().toStringAsFixed(0).seRagham() ?? '0'}" :  itemPrice.buyRange?.toStringAsFixed(0).seRagham() ?? '0',
                                        isDesktop,
                                        unit: "ریال"
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _buildPriceInfo(
                                        'محدوده فروش:',
                                      (itemPrice.salesRange ?? 0) < 0 ? "-${itemPrice.salesRange?.abs().toStringAsFixed(0).seRagham() ?? '0'}" : itemPrice.salesRange?.toStringAsFixed(0).seRagham() ?? '0',
                                        isDesktop,
                                          unit: "ریال"
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Text(
                                            'وضعیت خرید: ',
                                            style: AppTextStyle.bodyText.copyWith(
                                              fontSize: isDesktop ? 12 : 11,
                                              color: AppColor.textColor.withAlpha(175),
                                            ),
                                          ),
                                          Text(
                                            itemPrice.buyStatus==true ? "فعال" : "غیر فعال",
                                            style: AppTextStyle.bodyText.copyWith(
                                              fontSize: isDesktop ? 13 : 12,fontWeight: FontWeight.bold,
                                              color: itemPrice.buyStatus==true ? AppColor.primaryColor : AppColor.accentColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 25),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Text(
                                            'وضعیت فروش: ',
                                            style: AppTextStyle.bodyText.copyWith(
                                              fontSize: isDesktop ? 12 : 11,
                                              color: AppColor.textColor.withAlpha(175),
                                            ),
                                          ),
                                          Text(
                                            itemPrice.sellStatus==true ? "فعال" : "غیر فعال",
                                            style: AppTextStyle.bodyText.copyWith(
                                              fontSize: isDesktop ? 13 : 12,fontWeight: FontWeight.bold,
                                              color: itemPrice.sellStatus==true ? AppColor.primaryColor : AppColor.accentColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Close Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.buttonColor,
                          foregroundColor: AppColor.textColor,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'بستن',
                          style: AppTextStyle.labelText.copyWith(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPriceInfo(String label, String value, bool isDesktop,{String? unit}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyle.bodyText.copyWith(
            fontSize: isDesktop ? 12 : 11,
            color: AppColor.textColor.withAlpha(175),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              value,
              style: AppTextStyle.bodyText.copyWith(
                fontSize: isDesktop ? 14 : 13,
                fontWeight: FontWeight.bold,
              ),
              textDirection: TextDirection.ltr,
            ),
            SizedBox(width: 4),
            Text(
              unit ?? "",
              style: AppTextStyle.bodyText.copyWith(
                fontSize: isDesktop ? 13 : 12,
                color: AppColor.textPrimaryColor.withAlpha(200),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showAssignAccountsDialog(BuildContext context, AccountSalesGroupModel accountSalesGroup,
      {required bool isDesktop}) {
    controller.resetAssignmentState();
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: AppColor.backGroundColor,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: SizedBox(
            width: isDesktop ? Get.width * 0.5
                : Get.width * 0.9,
            height: isDesktop ? Get.height * 0.8
                : Get.height * 0.9,
            child: AssignAccountsDialog(
              controller: controller,
              accountSalesGroup: accountSalesGroup,
              isDesktop: isDesktop,
            ),
          ),
        );
      },
    );
  }

}

/*class _ColorDot extends StatelessWidget {
  final String? hexColor;
  const _ColorDot({required this.hexColor});

  Color _parseHex(String? hex) {
    if (hex == null || hex.isEmpty) return AppColor.textColor;
    var value = hex.replaceAll('#', '');
    if (value.length == 6) value = 'FF$value';
    try {
      return Color(int.parse(value, radix: 16));
    } catch (_) {
      return AppColor.textColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _parseHex(hexColor),
        border: Border.all(color: AppColor.textColor.withAlpha(130)),
      ),
    );
  }
}*/


