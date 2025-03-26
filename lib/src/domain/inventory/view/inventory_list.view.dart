import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/inventory/controller/inventory.controller.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../config/repository/url/base_url.dart';
import '../../../widget/custom_appbar.widget.dart';
import '../../../widget/empty.dart';
import '../../../widget/err_page.dart';

class InventoryListView extends StatelessWidget {
   InventoryListView({super.key});

   final InventoryController inventoryController = Get.find<InventoryController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'لیست دریافت/پرداخت',
        onBackTap: ()=>Get.back(),
      ),
      body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: Get.width,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        //فیلد جستجو
                        Expanded(
                          child: SizedBox(
                            height: 41,
                            child: TextFormField(
                              /*controller: orderController.searchController,
                              onChanged: orderController.filterOrders,*/
                              style: AppTextStyle.labelText,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                filled: true,
                                fillColor: AppColor.textFieldColor,
                                hintText: "جستجو ... ",
                                hintStyle: AppTextStyle.labelText,
                                prefixIcon: SvgPicture.asset(
                                  'assets/svg/search.svg',
                                  height: 15,
                                  width: 15,
                                  colorFilter: ColorFilter.mode(
                                      AppColor.textColor, BlendMode.srcIn),
                                  fit: BoxFit.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        //دکمه ایجاد دریافت/پرداخت
                        ElevatedButton(
                          style: ButtonStyle(
                              padding: WidgetStatePropertyAll(
                                  EdgeInsets.symmetric(horizontal: 7)),
                              elevation: WidgetStatePropertyAll(5),
                              backgroundColor:
                              WidgetStatePropertyAll(AppColor.buttonColor),
                              shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)))),
                          onPressed: () {
                            Get.toNamed('/inventoryCreate');
                          },
                          child: Text(
                            'ایجاد دریافت/پرداخت جدید',
                            style: AppTextStyle.labelText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Obx(() {
                  if (inventoryController.state.value == PageState.loading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (inventoryController.state.value == PageState.empty) {
                    return EmptyPage(
                      title: 'دریافت/پرداختی وجود ندارد',
                      callback: () {
                        inventoryController.fetchInventoryList();
                      },
                    );
                  } else if (inventoryController.state.value == PageState.list) {
                    return Expanded(
                        child: SizedBox(
                          height: Get.height * 0.6,
                          child: ListView.builder(
                            controller: inventoryController.scrollController,
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              itemCount: inventoryController.inventoryList.length+
                                  (inventoryController.hasMore.value ? 1 : 0),
                              itemBuilder: (context, index) {
                                print(inventoryController.inventoryList.length);
                                if (index >= inventoryController.inventoryList.length) {
                                  return inventoryController.hasMore.value
                                      ? Center(child: CircularProgressIndicator())
                                      : SizedBox.shrink();
                                }
                                var inventories=inventoryController.inventoryList[index];
                                return Obx((){
                                  bool isExpanded = inventoryController
                                      .isItemExpanded(index);
                                  return GestureDetector(
                                      onTap: () {
                                    inventoryController.toggleItemExpansion(
                                        index);
                                  },
                                    child: Card(
                                        margin: EdgeInsets.fromLTRB(8, 5, 8, 10),
                                        color: AppColor.secondaryColor,
                                        elevation: 10,
                                        child:Padding(
                                            padding: const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 10),
                                          child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [

                                              ListTile(
                                                title: Column(
                                                  children: [
                                                    //  تاریخ
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        Text(
                                                        inventories.date!.toPersianDate(twoDigits: true, showTime: true, timeSeprator: '-'),
                                                          style:
                                                          AppTextStyle.bodyText,
                                                        ),
                                                        Card(
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(5),
                                                          ),
                                                          color: inventories.type == 1
                                                              ? AppColor.primaryColor
                                                              : AppColor.accentColor,
                                                          margin: EdgeInsets.symmetric(
                                                              vertical: 0, horizontal: 5),
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(2),
                                                            child: Text(
                                                                inventories.type == 1
                                                                    ? 'دریافت'
                                                                    : 'پرداخت',
                                                                style: AppTextStyle.labelText,
                                                                textAlign: TextAlign.center),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 5,),
                                                    SizedBox(child: Divider(height: 1,color: AppColor.dividerColor,),),
                                                    SizedBox(height: 8,),
                                                    // نام ثبت کننده
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [

                                                            Text('نام ثبت کننده:  ',
                                                              style: AppTextStyle
                                                                  .labelText,),
                                                            SizedBox(height: 2,),
                                                            Text(inventories.account!.name ?? "",
                                                              style: AppTextStyle
                                                                  .bodyText,),

                                                      ],

                                                    ),

                                                    // فلش نمایش ایتم های دریافت/پرداخت
                                                    Row(mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        IconButton(
                                                          onPressed: () async{
                                                           await inventoryController.fetchGetOneInventory(inventories.id!);
                                                            inventoryController.toggleItemExpansion(index);
                                                          },
                                                          icon: Icon(
                                                            isExpanded ? Icons.expand_less : Icons.expand_more,
                                                            color: isExpanded ?
                                                            AppColor.accentColor :
                                                            AppColor.primaryColor,
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),

                                              // زیر مجموعه دریافت و پرداخت
                                              AnimatedSize(
                                                  duration: Duration(
                                                      milliseconds: 300),
                                                  curve: Curves.easeInOut,
                                                  child: isExpanded ?
                                                      Padding(
                                                          padding: EdgeInsets.symmetric(vertical: 1),
                                                          child:Column(
                                                            crossAxisAlignment: CrossAxisAlignment
                                                                .start,
                                                            mainAxisAlignment: MainAxisAlignment
                                                                .spaceEvenly,
                                                            children: [
                                                              SizedBox(height: 8,),
                                                                ConstrainedBox(
                                                                  constraints: BoxConstraints(
                                                                    maxHeight: 700,
                                                                  ),
                                                                  child:inventoryController.getOneInventory[inventories.id] == null ?
                                                                  Center(child: CircularProgressIndicator()) :
                                                                  ListView.builder(
                                                                      shrinkWrap: true,
                                                                      physics: NeverScrollableScrollPhysics(),
                                                                      itemCount: inventoryController.getOneInventory[inventories.id]?.inventoryDetails?.length,
                                                                      itemBuilder: (context, index) {
                                                                        var getOneInventories=inventoryController.getOneInventory[inventories.id]?.inventoryDetails?[index];
                                                                        return ListTile(
                                                                          title: Card(
                                                                            color: AppColor.backGroundColor,
                                                                            child: Padding(
                                                                                padding: const EdgeInsets.only(
                                                                                    top: 8,
                                                                                    left: 12,
                                                                                    right: 12,
                                                                                    bottom: 8),
                                                                              child: Column(
                                                                                children: [
                                                                                  Row(mainAxisAlignment: MainAxisAlignment.end,
                                                                                    children: [
                                                                                      Text('الصاق تصویر  ',style: AppTextStyle.labelText,),
                                                                                      GestureDetector(
                                                                                        onTap: () =>
                                                                                         inventoryController.pickImage(getOneInventories!.recId.toString(), "image", "Deposit"),
                                                                                          child: SvgPicture.asset('assets/svg/camera.svg',
                                                                                            width: 25,
                                                                                            height: 25,
                                                                                            colorFilter: ColorFilter.mode(AppColor.iconViewColor, BlendMode.srcIn),),

                                                                                      ),
                                                                                      Obx(() {
                                                                                        if (inventoryController.isUploading.value) {
                                                                                          return CircularProgressIndicator();
                                                                                        }
                                                                                        return Wrap(
                                                                                          children: inventoryController.selectedImages.asMap().entries.map((entry) => Chip(
                                                                                            label: Text('تصویر ${entry.key + 1}'),
                                                                                            deleteIcon: inventoryController.uploadStatuses[entry.key]
                                                                                                ? Icon(Icons.check)
                                                                                                : Icon(Icons.close),
                                                                                            onDeleted: () {},
                                                                                          ))
                                                                                              .toList(),
                                                                                        );
                                                                                      }),
                                                                                    ],
                                                                                  ),
                                                                                  SizedBox(height: 10,),
                                                                                  // آیتم- مقدار
                                                                                  Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      Row(
                                                                                        children: [
                                                                                          Text(
                                                                                              ' آیتم: ',
                                                                                              style: AppTextStyle
                                                                                                  .labelText),
                                                                                          Text(
                                                                                              getOneInventories?.item?.name ?? "",
                                                                                              style: AppTextStyle
                                                                                                  .bodyText),
                                                                                        ],
                                                                                      ),
                                                                                      SizedBox(
                                                                                        width: 4,),
                                                                                      Row(
                                                                                        children: [
                                                                                          Text(
                                                                                              ' مقدار: ',
                                                                                              style: AppTextStyle
                                                                                                  .bodyText
                                                                                          ),
                                                                                          Text(
                                                                                              '${getOneInventories?.amount ?? 0} ${getOneInventories?.itemUnit?.name ?? ""}',
                                                                                              style: AppTextStyle
                                                                                                  .bodyText
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  SizedBox(height: 8,),
                                                                                  // عیار - وزن750- ناخالصی
                                                                                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      Row(
                                                                                        children: [
                                                                                          Text(
                                                                                              ' عیار: ',
                                                                                              style: AppTextStyle
                                                                                                  .labelText),
                                                                                          Text(
                                                                                              '${getOneInventories?.carat ?? 0}',
                                                                                              style: AppTextStyle
                                                                                                  .bodyText),
                                                                                        ],
                                                                                      ),
                                                                                      Row(
                                                                                        children: [
                                                                                          Text(
                                                                                              ' وزن 750: ',
                                                                                              style: AppTextStyle
                                                                                                  .labelText),
                                                                                          Text(
                                                                                              '${getOneInventories?.weight750 ?? 0} گرم ',
                                                                                              style: AppTextStyle
                                                                                                  .bodyText),
                                                                                        ],
                                                                                      ),
                                                                                      Row(
                                                                                        children: [
                                                                                          Text(
                                                                                              '  ناخالصی: ',
                                                                                              style: AppTextStyle
                                                                                                  .labelText),
                                                                                          Text(
                                                                                              '${getOneInventories?.impurity ?? 0} گرم ',
                                                                                              style: AppTextStyle
                                                                                                  .bodyText),
                                                                                        ],
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 4,),
                                                                                  Divider(
                                                                                    height: 1,
                                                                                    color: AppColor
                                                                                        .secondaryColor,),
                                                                                  SizedBox(
                                                                                    height: 5,),
                                                                                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      // نمایش عکس
                                                                                      GestureDetector(
                                                                                        onTap: () {
                                                                                          if (getOneInventories?.attachments == null ||
                                                                                              getOneInventories!.attachments!.isEmpty) {
                                                                                            Get.snackbar('پیغام', 'تصویری ثبت نشده است');
                                                                                            return;
                                                                                          }

                                                                                          showDialog(
                                                                                            context: context,
                                                                                            builder: (BuildContext context) {
                                                                                              return Dialog(backgroundColor: AppColor.backGroundColor,
                                                                                                shape: RoundedRectangleBorder(
                                                                                                  borderRadius: BorderRadius.circular(10),
                                                                                                ),
                                                                                                child: Container(
                                                                                                  padding: EdgeInsets.all(8),
                                                                                                  child: Column(
                                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                                    children: [
                                                                                                      // نمایش اسلایدی عکس‌ها
                                                                                                      SizedBox(
                                                                                                        height: 300,
                                                                                                        child: PageView.builder(
                                                                                                          controller: inventoryController.pageController,
                                                                                                          itemCount: getOneInventories.attachments!.length,
                                                                                                          onPageChanged: (index) => inventoryController.currentImagePage.value = index,
                                                                                                          itemBuilder: (context, index) {
                                                                                                            final attachment = getOneInventories.attachments![index];
                                                                                                            return Image.network(
                                                                                                              "${BaseUrl.baseUrl}Attachment/downloadAttachment?fileName=${attachment.guidId}",
                                                                                                              loadingBuilder: (context, child, loadingProgress) {
                                                                                                                if (loadingProgress == null) return child;
                                                                                                                return Center(
                                                                                                                  child: CircularProgressIndicator(),
                                                                                                                );
                                                                                                              },
                                                                                                              errorBuilder: (context, error, stackTrace) =>
                                                                                                                  Icon(Icons.error, color: Colors.red),
                                                                                                              fit: BoxFit.cover,
                                                                                                            );
                                                                                                          },
                                                                                                        ),
                                                                                                      ),
                                                                                                      SizedBox(height: 2,),
                                                                                                      // نمایش نقاط راهنما
                                                                                                      Obx(() => Row(
                                                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                                                        children: List.generate(
                                                                                                          getOneInventories.attachments!.length,
                                                                                                              (index) => Container(
                                                                                                            width: 8,
                                                                                                            height: 8,
                                                                                                            margin: EdgeInsets.symmetric(horizontal: 4),
                                                                                                            decoration: BoxDecoration(
                                                                                                              shape: BoxShape.circle,
                                                                                                              color: inventoryController.currentImagePage.value == index
                                                                                                                  ? Colors.blue
                                                                                                                  : Colors.grey,
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                      )),

                                                                                                      SizedBox(height: 10),
                                                                                                      TextButton(
                                                                                                        onPressed: () => Get.back(),
                                                                                                        child: Text("بستن",style: AppTextStyle.bodyText,),
                                                                                                      ),
                                                                                                    ],
                                                                                                  ),
                                                                                                ),
                                                                                              );
                                                                                            },
                                                                                          );
                                                                                        },
                                                                                        child: Row(
                                                                                          children: [
                                                                                            Text(
                                                                                              'عکس‌ها (${getOneInventories?.attachments?.length ?? 0}) ',
                                                                                              style: AppTextStyle.bodyText.copyWith(
                                                                                                  color: AppColor.iconViewColor
                                                                                              ),
                                                                                            ),
                                                                                            SizedBox(
                                                                                              width: 25,
                                                                                              height: 25,
                                                                                              child: SvgPicture.asset(
                                                                                                'assets/svg/picture.svg',
                                                                                                colorFilter: ColorFilter.mode(
                                                                                                  AppColor.iconViewColor,
                                                                                                  BlendMode.srcIn,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      //  آیکون ویرایش
                                                                                      GestureDetector(
                                                                                        onTap: () {

                                                                                        },
                                                                                        child: Row(
                                                                                          children: [
                                                                                            Text('ویرایش  ',style: AppTextStyle.bodyText.copyWith(color: AppColor.iconViewColor),),
                                                                                            Container(
                                                                                              width: 25,
                                                                                              height: 25,
                                                                                                child: SvgPicture
                                                                                                    .asset(
                                                                                                    'assets/svg/edit.svg',
                                                                                                    colorFilter: ColorFilter
                                                                                                        .mode(
                                                                                                      AppColor
                                                                                                          .iconViewColor,
                                                                                                      BlendMode
                                                                                                          .srcIn,)
                                                                                                ),
                                                                                              ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      // آیکون حذف
                                                                                      GestureDetector(
                                                                                        onTap: () {

                                                                                        },
                                                                                        child: Row(
                                                                                          children: [
                                                                                            Text('حذف  ',style: AppTextStyle.bodyText.copyWith(color: AppColor.accentColor),),
                                                                                            Container(
                                                                                              width: 25,
                                                                                              height: 25,
                                                                                              child: SvgPicture
                                                                                                  .asset(
                                                                                                  'assets/svg/trash-bin.svg',
                                                                                                  colorFilter: ColorFilter
                                                                                                      .mode(
                                                                                                    AppColor
                                                                                                        .accentColor,
                                                                                                    BlendMode
                                                                                                        .srcIn,)
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      },
                                                                  ),
                                                              ),
                                                            ],
                                                          )
                                                      ): SizedBox(),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ),
                                  );
                                });
                              },
                          ),
                        )
                    );
                  }
                  return ErrPage(
                    callback: () {
                      inventoryController.fetchInventoryList();
                    },
                    title: "خطا در دریافت",
                    des: 'مجددا تلاش کنید',
                  );
                })
              ],
              ),
            ),
          ),
      ),
    );
  }
}
