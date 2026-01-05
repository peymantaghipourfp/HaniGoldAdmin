import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/account/controller/account_level.controller.dart';
import 'package:hanigold_admin/src/domain/account/model/account_level.model.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../config/repository/url/base_url.dart';
import '../../../widget/app_drawer.widget.dart';
import '../../../widget/background_image_total.widget.dart';
import '../../../widget/custom_appbar1.widget.dart';
import '../../../widget/err_page.dart';

class AccountLevelView extends GetView<AccountLevelController> {
  const AccountLevelView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    return Obx(() => Scaffold(
      appBar: CustomAppbar1(
        title: 'لیست سطوح کاربری',
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
                  controller.getAccountLevelList();
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
        label: Text('نام سطح (تعداد اکانت)', style: AppTextStyle.labelText.copyWith(fontSize: 11)),
        headingRowAlignment: MainAxisAlignment.center,
      ),
      const DataColumn(
        label: Text('عملیات',style: AppTextStyle.labelText),
        headingRowAlignment: MainAxisAlignment.center,
      ),
    ];
  }

  List<DataRow> _buildDataRows(BuildContext context) {
    return controller.accountLevelList.asMap().entries.map((entry) {
      final index = entry.key;
      final accLevel = entry.value;
      final rowColor = index.isEven
          ? AppColor.backGroundColor
          : AppColor.secondaryColor.withAlpha(100);
      return DataRow(
          color: WidgetStateProperty.all(rowColor),
          cells: [
            DataCell(Center(
              child: Text("${accLevel.rowNum ?? ''}", style: AppTextStyle.bodyText),
            )),
            DataCell(Center(
              child: Text("${accLevel.name ?? ""} (${accLevel.accountCount})", style: AppTextStyle.bodyText.copyWith(fontSize: 11)),
            )),
            /*DataCell(Center(
        child: _ColorDot(hexColor: sub.color),
      )),*/
            DataCell(Center(
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // جزئیات سطح
                  Tooltip(
                    message: "جزئیات سطح",
                    child: GestureDetector(
                      onTap: () {
                        _showDetailsDialog(context, accLevel.id ?? 0, isDesktop: true);
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
                  // ویرایش سطح
                  Tooltip(
                    message: "ویرایش سطح",
                    child: GestureDetector(
                      onTap: () {
                        final id = accLevel.id ?? 0;
                        if (id > 0) {
                          _showEditDialog(context, id, isDesktop: true);
                        } else {
                          Get.snackbar('خطا', 'شناسه سطح نامعتبر است', snackPosition: SnackPosition.BOTTOM, backgroundColor: AppColor.accentColor, colorText: AppColor.textColor);
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
          SizedBox(width: 10,),
          Expanded(
            child: ListView.builder(
              itemCount: controller.accountLevelList.length,
              itemBuilder: (ctx, index) {
                final accLevel = controller.accountLevelList[index];
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
                        Expanded(child: Text("${accLevel.rowNum ?? ''}", style: AppTextStyle.labelText.copyWith(fontSize: 10, color: AppColor.textColor.withAlpha(200)))),

                      ],
                    ),
                    const SizedBox(height: 8),
                    Divider(height: 0.5, color: AppColor.dividerColor),
                    const SizedBox(height: 5),
                    _mobileLine('بالانس سطح', (accLevel.balance! < 0 ) ? "-${accLevel.balance?.abs().toStringAsFixed(0).seRagham() ?? ""}" : accLevel.balance?.toStringAsFixed(0).seRagham() ?? "" ,
                        valueColor: (accLevel.balance! < 0 ) ? AppColor.accentColor : AppColor.primaryColor, trailing: 'ریال'),
                    _mobileLine('حد مثبت طلایی سطح', accLevel.positiveGold?.toString() ?? "" ,color: AppColor.textPrimaryColor,valueColor: AppColor.textPrimaryColor, trailing: ''),
                    _mobileLine('حد منفی طلایی سطح', accLevel.negativeGold?.toString() ?? "" ,color: AppColor.textAccentColor,valueColor: AppColor.textAccentColor, trailing: ''),
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
                            "${accLevel.name ?? ""} (${accLevel.accountCount})",
                            style: AppTextStyle.labelText.copyWith(fontSize: 13, fontWeight: FontWeight.bold, color: AppColor.textColor),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          children: [
                            // جزئیات گروه
                            GestureDetector(
                              onTap: () {
                                _showDetailsDialog(context, accLevel.id ?? 0, isDesktop: false);
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
                                final id = accLevel.id ?? 0;
                                if (id > 0) {
                                  _showEditDialog(context, id, isDesktop: false);
                                } else {
                                  Get.snackbar('خطا', 'شناسه سطح نامعتبر است', snackPosition: SnackPosition.BOTTOM, backgroundColor: AppColor.accentColor, colorText: AppColor.textColor);
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

  Widget _mobileLine(String label, String value, {Color? color,Color? valueColor,String? trailing}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label, style: AppTextStyle.labelText.copyWith(fontSize: 11, color:color ?? AppColor.textColor))),
          const SizedBox(width: 8),
          Row(children: [
            Text(value, style: AppTextStyle.labelText.copyWith(fontSize: 12, color:valueColor ?? AppColor.textColor, fontWeight: FontWeight.bold), textDirection: TextDirection.ltr),
            if (trailing != null) ...[
              const SizedBox(width: 4),
              Text(trailing, style: AppTextStyle.labelText.copyWith(fontSize: 10, color: AppColor.textColor, fontWeight: FontWeight.bold)),
            ]
          ])
        ],
      ),
    );
  }

  void _showDetailsDialog(BuildContext context, int accountLevelId, {required bool isDesktop}) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return FutureBuilder(
          future: controller.getOneAccountLevel(accountLevelId),
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

            final accountLevel = snapshot.data!;

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
                          'جزئیات سطح کاربر',
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
                      'نام سطح:',
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
                            accountLevel.name ?? 'نامشخص',
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
                                "(${accountLevel.accountCount ?? 0})",
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
                    const SizedBox(height: 8),
                    // detail accountlevel
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColor.primaryColor.withAlpha(30),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFF64748B)),
                        ),
                        child:
                        isDesktop ?
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildPriceInfo(
                                'بالانس سطح:',
                                (accountLevel.balance! < 0 ) ? "-${accountLevel.balance?.abs().toStringAsFixed(0).seRagham() ?? ""}" : accountLevel.balance?.toStringAsFixed(0).seRagham() ?? "" ,
                                isDesktop,
                                valueColor: (accountLevel.balance! < 0 ) ? AppColor.accentColor : AppColor.primaryColor,
                                unit: "ریال"
                            ),
                            _buildPriceInfo(
                                'حد مثبت طلایی سطح:',
                                accountLevel.positiveGold?.toString() ?? "",
                                isDesktop,
                                valueColor: AppColor.textPrimaryColor,
                                unit: ""
                            ),
                            _buildPriceInfo(
                                'حد منفی طلایی سطح:',
                                accountLevel.negativeGold?.toString() ?? "",
                                isDesktop,
                                valueColor: AppColor.textAccentColor,
                                unit: ""
                            ),
                          ],
                        ):
                        Column(
                          children: [
                            _mobileLine('بالانس سطح', (accountLevel.balance! < 0 ) ? "-${accountLevel.balance?.abs().toStringAsFixed(0).seRagham() ?? ""}" : accountLevel.balance?.toStringAsFixed(0).seRagham() ?? "" ,
                                valueColor: (accountLevel.balance! < 0 ) ? AppColor.accentColor : AppColor.primaryColor, trailing: 'ریال'),
                            _mobileLine('حد مثبت طلایی سطح', accountLevel.positiveGold?.toString() ?? "" ,color: AppColor.textPrimaryColor,valueColor: AppColor.textPrimaryColor, trailing: ''),
                            _mobileLine('حد منفی طلایی سطح', accountLevel.negativeGold?.toString() ?? "" ,color: AppColor.textAccentColor,valueColor: AppColor.textAccentColor, trailing: ''),
                          ],
                        )
                    ),
                    const SizedBox(height: 24),
                    // accountLevel Section
                    Text(
                      'لیست بازه محصولات:',
                      style: AppTextStyle.labelText.copyWith(
                        fontSize: isDesktop ? 14 : 13,
                        fontWeight: FontWeight.bold,
                        color: AppColor.textColor.withAlpha(175),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // accountLevelItem List
                    Flexible(
                      child: (accountLevel.accountLevelItems == null || accountLevel.accountLevelItems!.isEmpty)
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
                        itemCount: accountLevel.accountLevelItems!.length,
                        itemBuilder: (context, index) {
                          final accountLevelItem = accountLevel.accountLevelItems![index];
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
                                    Image.network('${BaseUrl.baseUrl}Attachment/downloadResource?fileName=${accountLevelItem.itemIcon}',
                                      width: 25,
                                      height: 25,),
                                    SizedBox(width: 5,),
                                    Text(
                                      accountLevelItem.itemName ?? 'نامشخص',
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
                                          'سقف خرید:',
                                          accountLevelItem.maxBuy.toString() ?? '0',
                                          isDesktop,unit: ""
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _buildPriceInfo(
                                          'سقف فروش:',
                                          accountLevelItem.maxSell.toString() ?? '0',
                                          isDesktop,unit: ""
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

  Widget _buildPriceInfo(String label, String value, bool isDesktop,{Color? valueColor,String? unit}) {
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
                color: valueColor ?? AppColor.textColor,
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

  void _showEditDialog(BuildContext context, int accountLevelId, {required bool isDesktop}) {
    // Reason: Fetch current account level data to populate edit form
    // Minimum input required: accountLevelId > 0
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return FutureBuilder(
          future: controller.getOneAccountLevel(accountLevelId),
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
                        'خطا در دریافت اطلاعات برای ویرایش',
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

            final accountLevel = snapshot.data!;
            // Reason: Initialize controller state with account level data before showing dialog
            // Minimum input required: accountLevel (AccountLevelModel with valid data)
            controller.initializeEditDialog(accountLevel);
            return _EditAccountLevelDialog(
              controller: controller,
              isDesktop: isDesktop,
              dialogContext: dialogContext,
            );
          },
        );
      },
    );
  }

}

// Helper class for edit dialog - uses controller state
class _EditAccountLevelDialog extends StatelessWidget {
  final AccountLevelController controller;
  final bool isDesktop;
  final BuildContext dialogContext;

  const _EditAccountLevelDialog({
    required this.controller,
    required this.isDesktop,
    required this.dialogContext,
  });

  Future<void> _handleSave() async {
    // Reason: Call controller's save method which handles all validation and state management
    // Minimum input required: Controller state must be initialized with account level data
    final success = await controller.saveEditedAccountLevel();

    // Validation: Check save result
    // Auto-correction: Close dialog only on success
    if (success) {
      Navigator.of(dialogContext).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Reason: Use Obx to reactively rebuild when controller state changes
    return Obx(() {
      final accountLevel = controller.editingAccountLevel.value;
      if (accountLevel == null) {
        return const SizedBox.shrink();
      }

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
                    'ویرایش سطح کاربر',
                    style: AppTextStyle.labelText.copyWith(
                      fontSize: isDesktop ? 20 : 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      controller.resetEditDialog();
                      Navigator.of(dialogContext).pop();
                    },
                    color: AppColor.textColor,
                  ),
                ],
              ),
              const Divider(height: 24),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name field (display only)
                      Text(
                        'نام سطح:',
                        style: AppTextStyle.labelText.copyWith(
                          fontSize: isDesktop ? 14 : 13,
                          fontWeight: FontWeight.bold,
                          color: AppColor.textColor.withAlpha(175),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColor.dividerColor.withAlpha(40),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFF64748B)),
                        ),
                        child: Text(
                          accountLevel.name ?? 'نامشخص',
                          style: AppTextStyle.bodyText.copyWith(
                            fontSize: isDesktop ? 15 : 14,
                            color: AppColor.dividerColor.withAlpha(200),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Balance, PositiveGold, NegativeGold fields
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        decoration: BoxDecoration(
                          color: AppColor.primaryColor.withAlpha(30),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFF64748B)),
                        ),
                        child: isDesktop
                            ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: _buildBalanceField(
                                'بالانس سطح:',
                                controller.balanceController,
                                'ریال',
                                isDesktop,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildPositiveGoldField(
                                'حد مثبت طلایی سطح:',
                                controller.positiveGoldController,
                                '',
                                isDesktop,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildNegativeGoldField(
                                'حد منفی طلایی سطح:',
                                controller.negativeGoldController,
                                '',
                                isDesktop,
                              ),
                            ),
                          ],
                        )
                            : Column(
                          children: [
                            _buildBalanceField(
                              'بالانس سطح:',
                              controller.balanceController,
                              'ریال',
                              isDesktop,
                            ),
                            const SizedBox(height: 12),
                            _buildPositiveGoldField(
                              'حد مثبت طلایی سطح:',
                              controller.positiveGoldController,
                              '',
                              isDesktop,
                            ),
                            const SizedBox(height: 12),
                            _buildNegativeGoldField(
                              'حد منفی طلایی سطح:',
                              controller.negativeGoldController,
                              '',
                              isDesktop,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Account Level Items section
                      Text(
                        'لیست بازه محصولات:',
                        style: AppTextStyle.labelText.copyWith(
                          fontSize: isDesktop ? 14 : 13,
                          fontWeight: FontWeight.bold,
                          color: AppColor.textColor.withAlpha(175),
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (accountLevel.accountLevelItems == null ||
                          accountLevel.accountLevelItems!.isEmpty)
                        Center(
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
                      else
                        ...accountLevel.accountLevelItems!.map((item) {
                          final itemId = item.itemId ?? 0;
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColor.secondary10Color,
                                  AppColor.backGroundColor1
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black45,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
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
                                    Image.network(
                                      '${BaseUrl.baseUrl}Attachment/downloadResource?fileName=${item.itemIcon}',
                                      width: 25,
                                      height: 25,
                                    ),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        item.itemName ?? 'نامشخص',
                                        style: AppTextStyle.labelText.copyWith(
                                          fontSize: isDesktop ? 14 : 13,
                                          fontWeight: FontWeight.bold,
                                          color: AppColor.dividerColor.withAlpha(220),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                isDesktop
                                    ? Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: _buildEditablePriceField(
                                        'سقف خرید:',
                                        controller.maxBuyControllers[itemId] ?? TextEditingController(text: '0'),
                                        '',
                                        isDesktop,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _buildEditablePriceField(
                                        'سقف فروش:',
                                        controller.maxSellControllers[itemId] ?? TextEditingController(text: '0'),
                                        '',
                                        isDesktop,
                                      ),
                                    ),
                                  ],
                                )
                                    : Column(
                                  children: [
                                    _buildEditablePriceField(
                                      'سقف خرید:',
                                      controller.maxBuyControllers[itemId] ?? TextEditingController(text: '0'),
                                      '',
                                      isDesktop,
                                    ),
                                    const SizedBox(height: 12),
                                    _buildEditablePriceField(
                                      'سقف فروش:',
                                      controller.maxSellControllers[itemId] ?? TextEditingController(text: '0'),
                                      '',
                                      isDesktop,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        controller.resetEditDialog();
                        Navigator.of(dialogContext).pop();
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColor.textColor,
                        side: BorderSide(color: AppColor.dividerColor),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'انصراف',
                        style: AppTextStyle.labelText.copyWith(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Obx(() => ElevatedButton(
                      onPressed: controller.isSaving.value ? null : _handleSave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.buttonColor,
                        foregroundColor: AppColor.textColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: controller.isSaving.value
                          ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                          : Text(
                        'ذخیره',
                        style: AppTextStyle.labelText.copyWith(fontSize: 16),
                      ),
                    )),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildEditablePriceField(
      String label,
      TextEditingController textController,
      String unit,
      bool isDesktopParam,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyle.bodyText.copyWith(
            fontSize: isDesktopParam ? 12 : 11,
            color: AppColor.textColor.withAlpha(175),
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: textController,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          textDirection: TextDirection.ltr,
          style: AppTextStyle.bodyText.copyWith(
            fontSize: isDesktopParam ? 14 : 13,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            suffixText: unit,
            suffixStyle: AppTextStyle.bodyText.copyWith(
              fontSize: isDesktopParam ? 13 : 12,
              color: AppColor.textPrimaryColor.withAlpha(200),
            ),
            filled: true,
            fillColor: AppColor.backGroundColor1,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColor.dividerColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColor.dividerColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColor.primaryColor, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
      ],
    );
  }

  // Build field for balance (positive and negative integers with thousand separators)
  // Reason: Allow positive/negative numbers and format with comma separators (three digits)
  // Minimum input required: Integer number (no decimals)
  Widget _buildBalanceField(
      String label,
      TextEditingController textController,
      String unit,
      bool isDesktopParam,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyle.bodyText.copyWith(
            fontSize: isDesktopParam ? 12 : 11,
            color: AppColor.textColor.withAlpha(175),
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: textController,
          keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: true),
          textDirection: TextDirection.ltr,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[۰-۹0-9,-]')),
          ],
          onChanged: (value) {
            // Reason: Format number with thousand separators (three digits)
            // Validation: Remove existing commas, ensure minus sign is only at start
            String cleanedValue = value.replaceAll(',', '');
            // Ensure minus sign is only at the start
            if (cleanedValue.contains('-') && !cleanedValue.startsWith('-')) {
              cleanedValue = cleanedValue.replaceAll('-', '');
            }
            if (cleanedValue.isNotEmpty || cleanedValue == '-') {
              final hasMinus = cleanedValue.startsWith('-');
              final digitsOnly = hasMinus ? cleanedValue.substring(1) : cleanedValue;
              if (digitsOnly.isNotEmpty || cleanedValue == '-') {
                // Format with thousand separators using seRagham
                final formatted = digitsOnly.seRagham();
                textController.value = TextEditingValue(
                  text: hasMinus ? '-$formatted' : formatted,
                  selection: TextSelection.collapsed(
                    offset: (hasMinus ? '-$formatted' : formatted).length,
                  ),
                );
              }
            }
          },
          style: AppTextStyle.bodyText.copyWith(
            fontSize: isDesktopParam ? 14 : 13,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            suffixText: unit,
            suffixStyle: AppTextStyle.bodyText.copyWith(
              fontSize: isDesktopParam ? 13 : 12,
              color: AppColor.textPrimaryColor.withAlpha(200),
            ),
            filled: true,
            fillColor: AppColor.backGroundColor1,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColor.dividerColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColor.dividerColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColor.primaryColor, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
      ],
    );
  }

  // Build field for positive gold (only positive numbers and zero)
  // Reason: Restrict input to >= 0 (no negative sign allowed)
  Widget _buildPositiveGoldField(
      String label,
      TextEditingController textController,
      String unit,
      bool isDesktopParam,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyle.bodyText.copyWith(
            fontSize: isDesktopParam ? 12 : 11,
            color: AppColor.textColor.withAlpha(175),
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: textController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: false),
          textDirection: TextDirection.ltr,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^[\d۰-۹]*\.?[\d۰-۹]*$')),
          ],
          onChanged: (value) {
            // Reason: Auto-correct to ensure value is >= 0
            // Validation: If negative value is entered, set to 0
            final parsed = double.tryParse(value);
            if (parsed != null && parsed < 0) {
              textController.text = '0';
              textController.selection = TextSelection.collapsed(offset: 1);
            }
          },
          style: AppTextStyle.bodyText.copyWith(
            fontSize: isDesktopParam ? 14 : 13,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            suffixText: unit,
            suffixStyle: AppTextStyle.bodyText.copyWith(
              fontSize: isDesktopParam ? 13 : 12,
              color: AppColor.textPrimaryColor.withAlpha(200),
            ),
            filled: true,
            fillColor: AppColor.backGroundColor1,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColor.dividerColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColor.dividerColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColor.primaryColor, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
      ],
    );
  }

  // Build field for negative gold (only negative numbers and zero)
  // Reason: Restrict input to <= 0 (must have negative sign or be zero)
  Widget _buildNegativeGoldField(
      String label,
      TextEditingController textController,
      String unit,
      bool isDesktopParam,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyle.bodyText.copyWith(
            fontSize: isDesktopParam ? 12 : 11,
            color: AppColor.textColor.withAlpha(175),
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: textController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
          textDirection: TextDirection.ltr,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^-?[\d۰-۹]*\.?[\d۰-۹]*$')),
            TextInputFormatter.withFunction((oldValue, newValue) {
              // Reason: Ensure minus sign is only at the start
              // Validation: If minus sign is not at start, remove it
              String text = newValue.text;
              if (text.contains('-') && !text.startsWith('-')) {
                text = text.replaceAll('-', '');
                if (text.isEmpty) {
                  return newValue.copyWith(text: '');
                }
              }
              return newValue.copyWith(text: text);
            }),
          ],
          onChanged: (value) {
            // Reason: Auto-correct to ensure value is <= 0
            // Validation: If positive value entered, convert to negative or set to 0
            if (value.isNotEmpty && value != '-') {
              final parsed = double.tryParse(value);
              if (parsed != null) {
                if (parsed > 0) {
                  // Auto-correct: convert positive to negative
                  textController.value = TextEditingValue(
                    text: '-$value',
                    selection: TextSelection.collapsed(offset: value.length + 1),
                  );
                } else if (parsed == 0 && value.startsWith('-')) {
                  // If zero with minus, remove minus
                  textController.value = TextEditingValue(
                    text: '0',
                    selection: TextSelection.collapsed(offset: 1),
                  );
                }
              }
            }
          },
          style: AppTextStyle.bodyText.copyWith(
            fontSize: isDesktopParam ? 14 : 13,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            suffixText: unit,
            suffixStyle: AppTextStyle.bodyText.copyWith(
              fontSize: isDesktopParam ? 13 : 12,
              color: AppColor.textPrimaryColor.withAlpha(200),
            ),
            filled: true,
            fillColor: AppColor.backGroundColor1,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColor.dividerColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColor.dividerColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColor.primaryColor, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
      ],
    );
  }
}
