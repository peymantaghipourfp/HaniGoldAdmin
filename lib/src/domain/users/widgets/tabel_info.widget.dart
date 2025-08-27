import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../model/transaction_item.model.dart';

class TabelInfoWidget extends StatefulWidget {
 final List<TransactionItemModel> list;
 final String title;
 final String title1;
 final String title2;
 final String typeSel1;
 final String typeSel2;
  const TabelInfoWidget({super.key, required this.list, required this.title, required this.title1, required this.title2, required this.typeSel1, required this.typeSel2});

  @override
  State<TabelInfoWidget> createState() => _TabelInfoWidgetState();
}

class _TabelInfoWidgetState extends State<TabelInfoWidget> {
  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    return Row(
      children: [
        Container(
          height: 150,
          padding: EdgeInsets.symmetric(horizontal: 3,vertical: 3),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1),
              border: Border.all(color: AppColor.textColor,width: 0.3),
              color: AppColor.backGroundColor1
          ),
          child: Center(
            child: RotatedBox(
              quarterTurns: 1,
              child:  Text(
                widget.title,
                style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 11 : 9),
              ),
            ),
          ),
        ),
        Column(
          children: [
            Container(
              alignment: Alignment.center,
              height: 25,width:isDesktop? Get.width * 0.07:Get.width * 0.09,
              // padding: EdgeInsets.symmetric(horizontal: 40,vertical: 3),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1),
                  border: Border.all(color: AppColor.textColor,width: 0.3),
                  color: AppColor.textColor
              ),
              child: Text(
                'نوع',
                style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 13 : 11,color: AppColor.backGroundColor),
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: 25,width:isDesktop? Get.width * 0.07:Get.width * 0.09,
              // padding: EdgeInsets.symmetric(horizontal: 40,vertical: 3),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1),
                  border: Border.all(color: AppColor.textColor,width: 0.3),
                  color: AppColor.backGroundColor
              ),
              child: Text(
                'طلا',
                style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 11 : 10),
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: 25,width:isDesktop? Get.width * 0.07:Get.width * 0.09,
              //   padding: EdgeInsets.symmetric(horizontal: 40,vertical: 3),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1),
                  border: Border.all(color: AppColor.textColor,width: 0.3),
                  color: AppColor.backGroundColor1
              ),
              child: Text(
                'سکه',
                style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 11 : 10),
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: 25,width:isDesktop? Get.width * 0.07:Get.width * 0.09,
              //  padding: EdgeInsets.symmetric(horizontal: 40,vertical: 3),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1),
                  border: Border.all(color: AppColor.textColor,width: 0.3),
                  color: AppColor.backGroundColor
              ),
              child: Text(
                'ریال',
                style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 11 : 10),
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: 25,width:isDesktop? Get.width * 0.07:Get.width * 0.09,
              // padding: EdgeInsets.symmetric(horizontal: 40,vertical: 3),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1),
                  border: Border.all(color: AppColor.textColor,width: 0.3),
                  color: AppColor.backGroundColor1
              ),
              child: Text(
                'ارز',
                style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 11 : 10),
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: 25,width:isDesktop? Get.width * 0.07:Get.width * 0.09,
              // padding: EdgeInsets.symmetric(horizontal: 40,vertical: 3),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1),
                  border: Border.all(color: AppColor.textColor,width: 0.3),
                  color: AppColor.backGroundColor
              ),
              child: Text(
                'کل',
                style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 11 : 10),
              ),
            ),

          ],

        ),
        Column(
          children: [
            Container(
              alignment: Alignment.center,
              height: 25,width:isDesktop? Get.width * 0.07:Get.width * 0.1,
              // padding: EdgeInsets.symmetric(horizontal: 40,vertical: 3),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1),
                  border: Border.all(color: AppColor.textColor,width: 0.3),
                  color: AppColor.textColor
              ),
              child: Text(
                widget.title1,
                style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 11 : 10,color: AppColor.backGroundColor),
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: 25,width:isDesktop? Get.width * 0.07:Get.width * 0.1,
              // padding: EdgeInsets.symmetric(horizontal: 40,vertical: 3),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1),
                  border: Border.all(color: AppColor.textColor,width: 0.3),
                  color: AppColor.backGroundColor
              ),
              child: Text(
                "${widget.list.fold(0, (sum, item) => item.groupName=="طلا" &&item.type==widget.typeSel1? sum + item.transactionCount!:sum + 0)}",
                style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 11 : 10),
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: 25,width:isDesktop? Get.width * 0.07:Get.width * 0.1,
              // padding: EdgeInsets.symmetric(horizontal: 40,vertical: 3),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1),
                  border: Border.all(color: AppColor.textColor,width: 0.3),
                  color: AppColor.backGroundColor1
              ),
              child: Text(
                "${widget.list.fold(0, (sum, item) => item.groupName=="سکه" &&item.type==widget.typeSel1? sum + item.transactionCount!:sum + 0)}",
                style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 11 : 10),
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: 25,width:isDesktop? Get.width * 0.07:Get.width * 0.1,
              // padding: EdgeInsets.symmetric(horizontal: 40,vertical: 3),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1),
                  border: Border.all(color: AppColor.textColor,width: 0.3),
                  color: AppColor.backGroundColor
              ),
              child: Text(
                "${widget.list.fold(0, (sum, item) => item.groupName=="ریال" &&item.type==widget.typeSel1? sum + item.transactionCount!:sum + 0)}",
                style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 11 : 10),
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: 25,width:isDesktop? Get.width * 0.07:Get.width * 0.1,
              // padding: EdgeInsets.symmetric(horizontal: 40,vertical: 3),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1),
                  border: Border.all(color: AppColor.textColor,width: 0.3),
                  color: AppColor.backGroundColor1
              ),
              child: Text(
                "${widget.list.fold(0, (sum, item) => item.groupName=="ارز" &&item.type==widget.typeSel1? sum + item.transactionCount!:sum + 0)}",
                style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 11 : 10),
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: 25,width:isDesktop? Get.width * 0.07:Get.width * 0.1,
              // padding: EdgeInsets.symmetric(horizontal: 40,vertical: 3),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1),
                  border: Border.all(color: AppColor.textColor,width: 0.3),
                  color: AppColor.backGroundColor
              ),
              child: Text(
                "${widget.list.fold(0, (sum, item) => item.type==widget.typeSel1? sum + item.transactionCount!:sum + 0)}",
                style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 11 : 10),
              ),
            ),

          ],
        ),

        Column(
          children: [
            Container(
              alignment: Alignment.center,
              height: 25,width:isDesktop? Get.width * 0.07:Get.width * 0.1,
              // padding: EdgeInsets.symmetric(horizontal: 40,vertical: 3),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1),
                  border: Border.all(color: AppColor.textColor,width: 0.3),
                  color: AppColor.textColor
              ),
              child: Text(
                widget.title2,
                style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 11 : 10,color: AppColor.backGroundColor),
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: 25,width:isDesktop? Get.width * 0.07:Get.width * 0.1,
              // padding: EdgeInsets.symmetric(horizontal: 40,vertical: 3),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1),
                  border: Border.all(color: AppColor.textColor,width: 0.3),
                  color: AppColor.backGroundColor
              ),
              child: Text(
                "${widget.list.fold(0, (sum, item) => item.groupName=="طلا" &&item.type==widget.typeSel2? sum + item.transactionCount!:sum + 0)}",
                style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 11 : 10),
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: 25,width:isDesktop? Get.width * 0.07:Get.width * 0.1,
              // padding: EdgeInsets.symmetric(horizontal: 40,vertical: 3),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1),
                  border: Border.all(color: AppColor.textColor,width: 0.3),
                  color: AppColor.backGroundColor1
              ),
              child: Text(
                "${widget.list.fold(0, (sum, item) => item.groupName=="سکه" &&item.type==widget.typeSel2? sum + item.transactionCount!:sum + 0)}",
                style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 11 : 10),
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: 25,width:isDesktop? Get.width * 0.07:Get.width * 0.1,
              // padding: EdgeInsets.symmetric(horizontal: 40,vertical: 3),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1),
                  border: Border.all(color: AppColor.textColor,width: 0.3),
                  color: AppColor.backGroundColor
              ),
              child: Text(
                "${widget.list.fold(0, (sum, item) => item.groupName=="ریال" &&item.type==widget.typeSel2? sum + item.transactionCount!:sum + 0)}",
                style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 11 : 10),
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: 25,width:isDesktop? Get.width * 0.07:Get.width * 0.1,
              // padding: EdgeInsets.symmetric(horizontal: 40,vertical: 3),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1),
                  border: Border.all(color: AppColor.textColor,width: 0.3),
                  color: AppColor.backGroundColor1
              ),
              child: Text(
                "${widget.list.fold(0, (sum, item) => item.groupName=="ارز" &&item.type==widget.typeSel2? sum + item.transactionCount!:sum + 0)}",
                style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 11 : 10),
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: 25,width:isDesktop? Get.width * 0.07:Get.width * 0.1,
              // padding: EdgeInsets.symmetric(horizontal: 40,vertical: 3),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1),
                  border: Border.all(color: AppColor.textColor,width: 0.3),
                  color: AppColor.backGroundColor
              ),
              child: Text(
                "${widget.list.fold(0, (sum, item) => item.type==widget.typeSel2? sum + item.transactionCount!:sum + 0)}",
                style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 11 : 10),
              ),
            ),

          ],
        ),
        Column(
          children: [
            Container(
              alignment: Alignment.center,
              height: 25,width:isDesktop? Get.width * 0.05:Get.width * 0.09,
              // padding: EdgeInsets.symmetric(horizontal: 40,vertical: 3),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1),
                  border: Border.all(color: AppColor.textColor,width: 0.3),
                  color: AppColor.textColor
              ),
              child: Text(
                'جزییات',
                style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 11 : 10,color: AppColor.backGroundColor),
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: 25,width:isDesktop? Get.width * 0.05:Get.width * 0.09,
              // padding: EdgeInsets.symmetric(horizontal: 40,vertical: 3),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1),
                  border: Border.all(color: AppColor.textColor,width: 0.3),
                  color: AppColor.backGroundColor
              ),
              child:  GestureDetector(
                onTap: (){
                  Get.defaultDialog(
                    confirm: Column(
                      children: widget.list.map((e)=>e.groupName=="طلا"? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            e.itemName??"",
                            style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 11 : 10,color: AppColor.backGroundColor),
                          ), Text(
                            "${e.transactionCount??0} گرم",
                            style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 11 : 10,color: AppColor.backGroundColor),
                          ),
                        ],
                      ):SizedBox()).toList(),
                    ),
                    middleText: " ${widget.title} نوع طلا ",
                    middleTextStyle: context
                        .textTheme.bodyMedium!
                        .copyWith(
                        color: AppColor.backGroundColor,
                        fontSize: 13),
                    title: "جزییات",
                    titleStyle: context
                        .textTheme.titleSmall!
                        .copyWith(
                        color: AppColor.backGroundColor,
                        fontSize: 14),
                    backgroundColor: AppColor.textColor,
                    radius: 7,
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),


                  );
                },
                child: SvgPicture.asset('assets/svg/list.svg',height: 16,
                    colorFilter: ColorFilter.mode(
                      AppColor.textColor,
                      BlendMode.srcIn,
                    )),
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: 25,width:isDesktop? Get.width * 0.05:Get.width * 0.09,
              // padding: EdgeInsets.symmetric(horizontal: 40,vertical: 3),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1),
                  border: Border.all(color: AppColor.textColor,width: 0.3),

                  color: AppColor.backGroundColor1
              ),
              child: GestureDetector(
                onTap: (){
                  Get.defaultDialog(
                    confirm: Column(
                      children: widget.list.map((e)=>e.groupName=="سکه"? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            e.itemName??"",
                            style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 11 : 10,color: AppColor.backGroundColor),
                          ), Text(
                            "${e.transactionCount??0} عدد",
                            style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 11 : 10,color: AppColor.backGroundColor),
                          ),
                        ],
                      ):SizedBox()).toList(),
                    ),
                    middleText: " ${widget.title} نوع سکه ",
                    middleTextStyle: context
                        .textTheme.bodyMedium!
                        .copyWith(
                        color: AppColor.backGroundColor,
                        fontSize: 13),
                    title: "جزییات",
                    titleStyle: context
                        .textTheme.titleSmall!
                        .copyWith(
                        color: AppColor.backGroundColor,
                        fontSize: 14),
                    backgroundColor: AppColor.textColor,
                    radius: 7,
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),


                  );
                },
                child: SvgPicture.asset('assets/svg/list.svg',height: 16,
                    colorFilter: ColorFilter.mode(
                      AppColor.textColor,
                      BlendMode.srcIn,
                    )),
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: 25,width:isDesktop? Get.width * 0.05:Get.width * 0.09,
              // padding: EdgeInsets.symmetric(horizontal: 40,vertical: 3),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1),
                  border: Border.all(color: AppColor.textColor,width: 0.3),
                  color: AppColor.backGroundColor
              ),
              child:GestureDetector(
                onTap: (){
                  Get.defaultDialog(
                    confirm: Column(
                      children: widget.list.map((e)=>e.groupName=="ریال"? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            e.itemName??"",
                            style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 11 : 10,color: AppColor.backGroundColor),
                          ), Text(
                            "${e.transactionCount??0} عدد",
                            style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 11 : 10,color: AppColor.backGroundColor),
                          ),
                        ],
                      ):SizedBox()).toList(),
                    ),
                    middleText: " ${widget.title} نوع ریال ",
                    middleTextStyle: context
                        .textTheme.bodyMedium!
                        .copyWith(
                        color: AppColor.backGroundColor,
                        fontSize: 13),
                    title: "جزییات",
                    titleStyle: context
                        .textTheme.titleSmall!
                        .copyWith(
                        color: AppColor.backGroundColor,
                        fontSize: 14),
                    backgroundColor: AppColor.textColor,
                    radius: 7,
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),


                  );
                },
                child: SvgPicture.asset('assets/svg/list.svg',height: 16,
                    colorFilter: ColorFilter.mode(
                      AppColor.textColor,
                      BlendMode.srcIn,
                    )),
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: 25,width:isDesktop? Get.width * 0.05:Get.width * 0.09,
              // padding: EdgeInsets.symmetric(horizontal: 40,vertical: 3),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1),
                  border: Border.all(color: AppColor.textColor,width: 0.3),
                  color: AppColor.backGroundColor1
              ),
              child: GestureDetector(
                onTap: (){
                  Get.defaultDialog(
                    confirm: Column(
                      children: widget.list.map((e)=>e.groupName=="ارز"? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            e.itemName??"",
                            style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 11 : 10,color: AppColor.backGroundColor),
                          ), Text(
                            "${e.transactionCount??0} عدد",
                            style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 11 : 10,color: AppColor.backGroundColor),
                          ),
                        ],
                      ):SizedBox()).toList(),
                    ),
                    middleText: " ${widget.title} نوع ارز ",
                    middleTextStyle: context
                        .textTheme.bodyMedium!
                        .copyWith(
                        color: AppColor.backGroundColor,
                        fontSize: 13),
                    title: "جزییات",
                    titleStyle: context
                        .textTheme.titleSmall!
                        .copyWith(
                        color: AppColor.backGroundColor,
                        fontSize: 14),
                    backgroundColor: AppColor.textColor,
                    radius: 7,
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),


                  );
                },
                child: SvgPicture.asset('assets/svg/list.svg',height: 16,
                    colorFilter: ColorFilter.mode(
                      AppColor.textColor,
                      BlendMode.srcIn,
                    )),
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: 25,width:isDesktop? Get.width * 0.05:Get.width * 0.09,
              // padding: EdgeInsets.symmetric(horizontal: 40,vertical: 3),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1),
                  border: Border.all(color: AppColor.textColor,width: 0.3),
                  color: AppColor.backGroundColor
              ),
              child: GestureDetector(
                onTap: (){
                  Get.defaultDialog(
                    confirm: Column(
                      children: widget.list.map((e)=> Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            e.itemName??"",
                            style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 11 : 10,color: AppColor.backGroundColor),
                          ),
                          e.itemName=='طلای آبشده' ?
                          Text(
                            "${e.transactionCount??0} گرم ",
                            style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 11 : 10,color: AppColor.backGroundColor),
                          ):
                          Text(
                            "${e.transactionCount??0} عدد ",
                            style: AppTextStyle.labelText.copyWith(fontSize: isDesktop ? 11 : 10,color: AppColor.backGroundColor),
                          )
                        ],
                      )).toList(),
                    ),
                    middleText: " کل ${widget.title} ",
                    middleTextStyle: context
                        .textTheme.bodyMedium!
                        .copyWith(
                        color: AppColor.backGroundColor,
                        fontSize: 13),
                    title: "جزییات",
                    titleStyle: context
                        .textTheme.titleSmall!
                        .copyWith(
                        color: AppColor.backGroundColor,
                        fontSize: 14),
                    backgroundColor: AppColor.textColor,
                    radius: 7,
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),


                  );
                },
                child: SvgPicture.asset('assets/svg/list.svg',height: 16,
                    colorFilter: ColorFilter.mode(
                      AppColor.textColor,
                      BlendMode.srcIn,
                    )),
              ),
            ),

          ],
        ),
      ],
    );
  }
}
