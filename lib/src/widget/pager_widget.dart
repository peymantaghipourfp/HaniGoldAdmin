import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../config/const/app_color.dart';
import '../config/const/app_text_style.dart';
import 'package:syncfusion_flutter_core/theme.dart';

typedef SelectPagerCountCallBack = Function(int index);


class PagerWidget extends StatelessWidget {
  final int countPage;
  final SelectPagerCountCallBack callBack;
  const PagerWidget({super.key, required this.countPage, required this.callBack});

  @override
  Widget build(BuildContext context) {
    List<String> listStr = (countPage/10).toString().split('.');
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child:   SizedBox(
          height: 60,width: Get.width * 0.9,
          child:countPage!=0? SfDataPagerTheme(
            data: SfDataPagerThemeData(
                itemColor: Colors.transparent,
                selectedItemColor: AppColor.secondary3Color,
                backgroundColor: AppColor.backGroundColor,
                itemTextStyle:  AppTextStyle.bodyText.copyWith(fontSize: 12,color: AppColor.textColor),
                disabledItemTextStyle: AppTextStyle.bodyText.copyWith(fontSize: 12,color: AppColor.textColor.withOpacity(0.5)),
                selectedItemTextStyle: AppTextStyle.bodyText.copyWith(fontSize: 12,color: AppColor.textColor),
                itemBorderColor: AppColor.textColor
            ),
            child: SfDataPager(
              itemPadding: EdgeInsets.all(10),
              onPageNavigationEnd:(value){
                print(value+1);
                callBack(value+1);
              },
              delegate: DataPagerDelegate(),
              direction: Axis.horizontal, pageCount:listStr.length>1? ((countPage.toDouble()/10)+1):(countPage.toDouble()/10),
            ),
          ):SizedBox(),
        )
    );
  }
}