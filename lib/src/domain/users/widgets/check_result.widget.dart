import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:shamsi_date/shamsi_date.dart';
import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../controller/check_result.controller.dart';
import '../model/check_result.model.dart';

class CheckResult extends StatefulWidget {
  final int id;
  final bool isDesktop;

  const CheckResult({super.key, required this.id, required this.isDesktop});

  @override
  State<CheckResult> createState() => _CheckResultState();
}

class _CheckResultState extends State<CheckResult> {
  late CheckResultController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(CheckResultController(), permanent: false);
    // Fetch results for provided id
    controller.getCheckResult(id: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = widget.isDesktop;
    final width = isDesktop ? Get.width * 0.5 : Get.width * 0.9;
    final height = isDesktop ? Get.height * 0.7 : Get.height * 0.8;

    return Dialog(
      backgroundColor: AppColor.backGroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: width,
        height: height,
        padding: EdgeInsets.all(isDesktop ? 16 : 5),
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }

          final List<CheckResultModel> results = controller.checkResultList;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.library_add_check, color: AppColor.primaryColor),
                  const SizedBox(width: 8),
                  Text(
                    'بررسی تراکنش ها',
                    style: AppTextStyle.smallTitleText.copyWith(color: AppColor.primaryColor),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.close, color: AppColor.textColor),
                  )
                ],
              ),
              Container(height: 0.6, color: AppColor.textColor, margin: const EdgeInsets.symmetric(vertical: 8)),
              Expanded(
                child: results.isEmpty
                    ? Center(
                    child: Text(
                      'موردی یافت نشد',
                      style: AppTextStyle.bodyText.copyWith(color: AppColor.textColor.withAlpha(175)),
                    ))
                    : Scrollbar(
                  child: ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (ctx, index) {
                      final item = results[index];
                      return _ResultSection(item: item);
                    },
                  ),
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}

class _ResultSection extends StatelessWidget {
  final CheckResultModel item;
  const _ResultSection({required this.item});

  String _typeLabel(String? type) {
    switch (type) {
      case 'issue':
        return 'حواله دریافتی';
      case 'reciept':
        return 'حواله پرداختی';
      case 'payment':
        return 'پرداخت';
      case 'receive':
        return 'دریافت';
      case 'sell':
        return 'فروش';
      case 'buy':
        return 'خرید';
      case 'deposit':
        return 'واریز';
      case 'withdraw':
        return 'برداشت';
      case 'initial':
        return 'اول دوره';
      default:
        return type ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColor.secondaryColor.withAlpha(100),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColor.textColor.withAlpha(75)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColor.iconViewColor.withAlpha(40),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColor.iconViewColor.withAlpha(100)),
                ),
                child: Text(
                  _typeLabel(item.type),
                  style: AppTextStyle.bodyText.copyWith(color: AppColor.iconViewColor, fontWeight: FontWeight.bold, fontSize: 11),
                ),
              ),
              const SizedBox(width: 8),
              Row(
                children: [
                  Text(
                    'بررسی تعداد: ',
                    style: AppTextStyle.bodyText.copyWith(
                      color: const Color(0xFF94A3B8),
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    item.countCheck==false ? "خیر" : "بله",
                    style: AppTextStyle.bodyText.copyWith(fontWeight: FontWeight.bold,color: item.countCheck==false ? AppColor.accentColor : AppColor.primaryColor ),
                  ),
                ],
              ),
              const Spacer(),
              if (item.similarCount != null)
                Row(
                  children: [
                    Text(
                      'تعداد مشابه: ',
                      style: AppTextStyle.bodyText.copyWith(
                        color: const Color(0xFF94A3B8),
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      '${item.similarCount}',
                      style: AppTextStyle.bodyText.copyWith(color: AppColor.textColor),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Row(
                children: [
                  Text(
                    'حذف شده: ',
                    style: AppTextStyle.bodyText.copyWith(
                      color: const Color(0xFF94A3B8),
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    item.isDeleted==false ? "خیر" : "بله",
                    style: AppTextStyle.bodyText.copyWith(fontWeight: FontWeight.bold,color: item.isDeleted==false ? AppColor.accentColor : AppColor.primaryColor ),
                  ),
                ],
              ),
              SizedBox(width: 20,),
              Row(
                children: [
                  Text(
                    'والد: ',
                    style: AppTextStyle.bodyText.copyWith(
                      color: const Color(0xFF94A3B8),
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    item.hasParent==false ? "ندارد" : "دارد",
                    style: AppTextStyle.bodyText.copyWith(fontWeight: FontWeight.bold,color: item.hasParent==false ? AppColor.accentColor : AppColor.primaryColor ),
                  ),
                ],
              ),
              SizedBox(width: 20,),
              Row(
                children: [
                  Text(
                    'وضعیت: ',
                      style: AppTextStyle.bodyText.copyWith(
                        color: const Color(0xFF94A3B8),
                        fontSize: 12,
                      ),
                  ),
                  Text(
                    '${item.status == 0 ? 'در انتظار' : item.status == 1
                        ? 'تایید شده'
                        :item.status == 2 ? 'تایید نشده' : item.status == 4 ? "برگشتی" : "ویرایش شده"} ',
                    style: AppTextStyle
                        .bodyText.copyWith(
                        color: item.status == 1
                            ? AppColor.primaryColor
                            : item.status == 2
                            ? AppColor.accentColor
                            : item.status == 4
                            ? AppColor.accentColor
                            : AppColor.textColor,
                        fontWeight: item.status == 4 ? FontWeight.bold :FontWeight.normal
                    ),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 10),
          if ((item.transactions ?? []).isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: AppColor.backGroundColor.withAlpha(130),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColor.textColor.withAlpha(50)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('تراکنش ها', style: AppTextStyle.labelText.copyWith(fontSize: 12)),
                  const SizedBox(height: 8),
                  ...item.transactions!.map((t) => _TransactionRow(trans: t)),
                ],
              ),
            )
          else
            Text('تراکنش ها خالی', style: AppTextStyle.bodyText.copyWith(color: AppColor.textColor.withAlpha(175), fontSize: 12)),
        ],
      ),
    );
  }
}

class _TransactionRow extends StatelessWidget {
  final dynamic trans; // TransactionInfoItemModel
  const _TransactionRow({required this.trans});

  Widget _buildTransactionTypeChip(String? type) {
    String typeText = '';
    Color chipColor = AppColor.textColor;

    switch (type) {
      case 'issue':
        typeText = 'حواله دریافتی';
        chipColor = const Color(0xFF3B82F6);
        break;
      case 'receive':
        typeText = 'دریافت';
        chipColor = const Color(0xFF10B981);
        break;
      case 'payment':
        typeText = 'پرداخت';
        chipColor = const Color(0xFFEF4444);
        break;
      case 'sell':
        typeText = 'فروش';
        chipColor = const Color(0xFFF59E0B);
        break;
      case 'buy':
        typeText = 'خرید';
        chipColor = const Color(0xFF10B981);
        break;
      case 'deposit':
        typeText = 'واریز';
        chipColor = const Color(0xFF8B5CF6);
        break;
      case 'withdraw':
        typeText = 'برداشت';
        chipColor = const Color(0xFFEF4444);
        break;
      case 'reciept':
        typeText = 'حواله پرداختی';
        chipColor = const Color(0xFF3B82F6);
        break;
      case 'toTransfer':
      case 'fromTransfer':
        typeText = 'انتقال ولت';
        chipColor = const Color(0xFF64748B);
        break;
      default:
        typeText = '';
        chipColor = AppColor.textColor;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withAlpha(40),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: chipColor.withAlpha(130)),
      ),
      child: Text(
        typeText,
        style: AppTextStyle.bodyText.copyWith(
          color: chipColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _formatAmountValue(dynamic trans) {
    final unitId = trans.item?.itemUnit?.id;
    final amt = trans.amount ?? 0;
    if (unitId == 1) {
      return amt.toString();
    } else if (unitId == 2) {
      if (amt < 0) return "-${amt.abs().toString().seRagham()} ";
      if (amt > 0) return "${amt.toString().seRagham()} ";
    } else if (unitId == 3) {
      if (amt < 0) return "-${amt.abs().toString().seRagham()} ";
      if (amt > 0) return "${amt.toString().seRagham()} ";
    }
    return "${amt.toString().seRagham()} ";
  }

  String _unitName(dynamic t) {
    final id = t.item?.itemUnit?.id;
    if (id == 1) return 'عدد';
    if (id == 2) return 'گرم';
    if (id == 4) return 'دلار';
    if (id == 5) return 'یورو';
    return 'ریال';
  }

  Widget _buildMobileDescriptionSection(dynamic trans) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColor.textFieldColor.withAlpha(50),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF64748B)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // If details are empty, show high-level description rows
          if ((trans.details == null) || trans.details!.isEmpty) ...[
            if (trans.type == "fromTransfer")
              Row(
                children: [
                  SelectableText(
                    " از ولت ",
                    style: AppTextStyle.bodyText.copyWith(color: AppColor.textColor, fontSize: 12),
                  ),
                  SelectableText(
                    " ${trans.wallet?.account?.name ?? ""} ",
                    style: AppTextStyle.bodyText.copyWith(color: AppColor.primaryColor, fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            if (trans.type == "toTransfer")
              Row(
                children: [
                  SelectableText(
                    " به ولت ",
                    style: AppTextStyle.bodyText.copyWith(color: AppColor.textColor, fontSize: 12),
                  ),
                  SelectableText(
                    " ${trans.wallet?.account?.name ?? ""} ",
                    style: AppTextStyle.bodyText.copyWith(color: AppColor.accentColor, fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            if (trans.toWallet?.account?.name != null && trans.type == 'reciept')
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SelectableText(" از : ", style: AppTextStyle.bodyText.copyWith(color: AppColor.textColor, fontSize: 10)),
                  SelectableText(" ${trans.toWallet?.account?.name ?? ""} ", style: AppTextStyle.bodyText.copyWith(color: AppColor.accentColor, fontSize: 10, fontWeight: FontWeight.bold)),
                  SelectableText(" به : ", style: AppTextStyle.bodyText.copyWith(color: AppColor.textColor, fontSize: 10)),
                  SelectableText(" ${trans.wallet?.account?.name ?? ""} ", style: AppTextStyle.bodyText.copyWith(color: AppColor.primaryColor, fontSize: 10, fontWeight: FontWeight.bold)),
                ],
              ),
            if (trans.toWallet?.account?.name != null && trans.type == 'issue')
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SelectableText(" از : ", style: AppTextStyle.bodyText.copyWith(color: AppColor.textColor, fontSize: 10)),
                  SelectableText(" ${trans.wallet?.account?.name ?? ""} ", style: AppTextStyle.bodyText.copyWith(color: AppColor.accentColor, fontSize: 10, fontWeight: FontWeight.bold)),
                  SelectableText(" به : ", style: AppTextStyle.bodyText.copyWith(color: AppColor.textColor, fontSize: 10)),
                  SelectableText(" ${trans.toWallet?.account?.name ?? ""} ", style: AppTextStyle.bodyText.copyWith(color: AppColor.primaryColor, fontSize: 10, fontWeight: FontWeight.bold)),
                ],
              ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SelectableText(
                  trans.item?.itemUnit?.id == 1
                      ? " ${trans.amount} "
                      : trans.item?.itemUnit?.id == 2
                      ? "${trans.amount} "
                      : trans.amount <0 ? "-${trans.amount.abs().toString().seRagham()}" : trans.amount.toString().seRagham(),
                  style: AppTextStyle.bodyText.copyWith(color: trans.amount < 0 ? AppColor.accentColor : trans.amount > 0 ? AppColor.primaryColor : AppColor.textColor, fontWeight: FontWeight.w700, fontSize: 12),
                  textDirection: TextDirection.ltr,
                ),
                SelectableText(
                  trans.item?.itemUnit?.id == 1
                      ? " عدد "
                      : trans.item?.itemUnit?.id == 2
                      ? " گرم "
                      : trans.item?.itemUnit?.id == 4
                      ? "دلار"
                      : trans.item?.itemUnit?.id == 5
                      ? "یورو"
                      : " ریال ",
                  style: AppTextStyle.bodyText.copyWith(color: AppColor.textColor, fontWeight: FontWeight.w700, fontSize: 10),
                ),
                const SizedBox(width: 5),
                SelectableText(
                  trans.item?.name ?? 'نامشخص',
                  style: AppTextStyle.bodyText.copyWith(color: AppColor.secondary2Color, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 6),
            if (trans.price != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SelectableText('به مظنه :  ', style: AppTextStyle.bodyText.copyWith(color: AppColor.iconViewColor, fontWeight: FontWeight.w700, fontSize: 10)),
                  SelectableText("${trans.mesghalPrice ?? 0}".toString().split('.').first.seRagham() + "  ریال  ", style: AppTextStyle.bodyText.copyWith(color: AppColor.textColor, fontWeight: FontWeight.w700, fontSize: 12)),
                ],
              ),
            const SizedBox(height: 6),
            if (trans.totalPrice != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SelectableText(' قیمت کل :  ', style: AppTextStyle.bodyText.copyWith(color: AppColor.iconViewColor, fontWeight: FontWeight.normal, fontSize: 10)),
                  SelectableText("${trans.totalPrice ?? 0}".toString().split('.').first.seRagham() + "  ریال  ", style: AppTextStyle.bodyText.copyWith(color: AppColor.textColor, fontWeight: FontWeight.normal, fontSize: 12)),
                ],
              ),
            Container(height: 0.6, color: AppColor.textColor, margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20)),
            if (trans.description != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SelectableText('توضیحات : ', style: AppTextStyle.bodyText.copyWith(color: AppColor.iconViewColor, fontWeight: FontWeight.w700, fontSize: 10)),
                  Flexible(child: SelectableText(trans.description ?? 'نامشخص', style: AppTextStyle.bodyText.copyWith(color: AppColor.dividerColor, fontWeight: FontWeight.w600, fontSize: 11))),
                ],
              ),
          ] else ...[
            // If details exist, render detail cards similar to desktop
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: trans.details.map<Widget>((e) => Container(
                margin: const EdgeInsets.symmetric(vertical: 3),
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: AppColor.secondary3Color.withAlpha(120),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Row(children: [
                        SelectableText("وزن ترازو : ", style: AppTextStyle.bodyText.copyWith(color: AppColor.backGroundColor, fontSize: 10, fontWeight: FontWeight.bold)),
                        SelectableText("${e.weight ?? 0} گرم ", style: AppTextStyle.bodyText.copyWith(color: AppColor.textColorSecondary, fontSize: 10, fontWeight: FontWeight.bold)),
                      ]),
                      Row(children: [
                        SelectableText("عیار : ", style: AppTextStyle.bodyText.copyWith(color: AppColor.backGroundColor, fontSize: 10, fontWeight: FontWeight.bold)),
                        SelectableText("${e.carat ?? 0} ", style: AppTextStyle.bodyText.copyWith(color: AppColor.textColorSecondary, fontSize: 10, fontWeight: FontWeight.bold)),
                      ]),
                      Row(children: [
                        SelectableText("وزن : ", style: AppTextStyle.bodyText.copyWith(color: AppColor.backGroundColor, fontSize: 10, fontWeight: FontWeight.bold)),
                        SelectableText("${e.quantity ?? 0} گرم ", style: AppTextStyle.bodyText.copyWith(color: AppColor.textColorSecondary, fontSize: 10, fontWeight: FontWeight.bold)),
                      ]),
                      Row(children: [
                        SelectableText("ناخالصی : ", style: AppTextStyle.bodyText.copyWith(color: AppColor.backGroundColor, fontSize: 10, fontWeight: FontWeight.bold)),
                        SelectableText("${e.impurity ?? 0} گرم ", style: AppTextStyle.bodyText.copyWith(color: AppColor.textColorSecondary, fontSize: 10, fontWeight: FontWeight.bold)),
                      ]),
                    ]),
                    const SizedBox(height: 5),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Row(children: [
                        SelectableText("آزمایشگاه : ", style: AppTextStyle.bodyText.copyWith(color: AppColor.backGroundColor, fontSize: 10, fontWeight: FontWeight.bold)),
                        SelectableText("${e.laboratoryName ?? ""} ", style: AppTextStyle.bodyText.copyWith(color: AppColor.textColorSecondary, fontSize: 10, fontWeight: FontWeight.bold)),
                      ]),
                      Row(children: [
                        SelectableText("شماره آزمایشگاه : ", style: AppTextStyle.bodyText.copyWith(color: AppColor.backGroundColor, fontSize: 10, fontWeight: FontWeight.bold)),
                        SelectableText("${e.receiptNumber ?? ""} ", style: AppTextStyle.bodyText.copyWith(color: AppColor.textColorSecondary, fontSize: 10, fontWeight: FontWeight.bold)),
                      ]),
                    ]),
                  ],
                ),
              ))
                  .toList(),
            ),
          ]
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 10),
      decoration: BoxDecoration(
        color: AppColor.backGroundColor.withAlpha(130),
        borderRadius: BorderRadius.circular(12),
        //border: Border.all(color: const Color(0xFF64748B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTransactionTypeChip(trans.type),
               Row(
                  children: [
                    Text(
                      'تاریخ: ',
                      style: AppTextStyle.bodyText.copyWith(
                        color: const Color(0xFF94A3B8),
                        fontSize: 12,
                      ),
                    ),
                    Text(Jalali.fromDateTime(trans.date).toJalaliDateTime() ?? "",
                      style: AppTextStyle.bodyText.copyWith(
                        color: AppColor.textColor,
                        fontWeight: FontWeight.bold,
                      ),textDirection: TextDirection.ltr,
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 5),
          Divider(color: AppColor.iconViewColor,height: 0.5,),
          const SizedBox(height: 5),
          Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: AppColor.dividerColor.withAlpha(20),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF64748B)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    trans.item?.name ?? 'نامشخص',
                    style: AppTextStyle.bodyText.copyWith(
                      color: AppColor.secondary2Color,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Amount row (mirrors table logic)
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        _formatAmountValue(trans),
                        style: AppTextStyle.bodyText.copyWith(
                          color: (trans.amount ?? 0) > 0 ? AppColor.primaryColor : AppColor.accentColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        textDirection: TextDirection.ltr,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _unitName(trans),
                        style: AppTextStyle.bodyText.copyWith(
                          color: (trans.amount ?? 0) > 0 ? AppColor.primaryColor : AppColor.accentColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        'حساب: ',
                        style: AppTextStyle.bodyText.copyWith(
                          color: const Color(0xFF94A3B8),
                          fontSize: 12,
                        ),
                      ),
                      Text(trans.wallet.account.name ?? "",style: AppTextStyle.bodyText.copyWith(
                        color: AppColor.textColor,
                        fontWeight: FontWeight.bold,
                      ),),
                    ],
                  ),
                )
              ],
            ),
          ),
          _buildMobileDescriptionSection(trans),
        ],
      ),
    );
  }
}


