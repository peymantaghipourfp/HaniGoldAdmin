

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hanigold_admin/src/domain/inventory/controller/inventory_create_receive.controller.dart';
import 'package:uuid/uuid.dart';

import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../controller/inventory_create_payment.controller.dart';
import '../model/inventory_detail.model.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ItemTempDetailWidgetReceive extends StatefulWidget {
  final InventoryDetailModel detail;
  final Function(String,List<XFile>)? recId;
  final List<XFile> image;
  const ItemTempDetailWidgetReceive({
    super.key,
    required this.detail,
    this.recId, required this.image,
  });

  @override
  State<ItemTempDetailWidgetReceive> createState() => _ItemTempDetailWidgetReceive();
}

class _ItemTempDetailWidgetReceive extends State<ItemTempDetailWidgetReceive> {
  InventoryCreateReceiveController inventoryCreateReceiveController=Get.find<InventoryCreateReceiveController>();
  final ImagePicker _picker = ImagePicker();
  RxList<XFile> selectedImagesDesktop = RxList<XFile>();
  var recordId="".obs;
  var uuid = Uuid();

  Future<void> pickImageDesktop() async {
    recordId.value=uuid.v4();
    try{
      final List<XFile> images = await _picker.pickMultiImage();
      if (images.isNotEmpty) {
        setState(() {
          selectedImagesDesktop.addAll(images);
        });
      }
    }catch(e){
      throw Exception('خطا در انتخاب فایل‌ها');
    }
    if (selectedImagesDesktop.isNotEmpty) {
      setState(() {
        widget.recId?.call(recordId.value,selectedImagesDesktop);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return
      Card(
        color: AppColor.backGroundColor,
        child: ConstrainedBox(
            constraints: BoxConstraints(
                minHeight: 60,minWidth: 100
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(widget.detail.item?.name ?? '',
                        style: AppTextStyle.bodyText,),
                      SizedBox(width: 4,),
                      Text('مقدار: ${widget.detail.quantity}',
                        style: AppTextStyle.bodyText,),
                      SizedBox(width: 4,),
                      Text('وزن750: ${widget.detail.weight750}',
                        style: AppTextStyle.bodyText,),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Container(
                    padding: EdgeInsets.only(bottom: 5,right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(() {
                          if (inventoryCreateReceiveController
                              .isUploadingDesktop
                              .value) {
                            return Row(
                              children: [
                                Text(
                                  'در حال بارگزاری عکس',
                                  style: AppTextStyle.labelText.copyWith(fontSize: 12,
                                      fontWeight: FontWeight.normal,color: AppColor.textColor ),
                                ),
                                SizedBox(width: 10,),
                                CircularProgressIndicator(),
                              ],
                            );
                          }
                          return SizedBox(
                            height: 80,
                            width: Get.width * 0.18,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: widget.image.isNotEmpty? Row(
                                children: widget.image.map((e){
                                  return  Stack(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: AppColor.textColor),
                                            image: DecorationImage(image: NetworkImage(e.path,),fit: BoxFit.cover,)
                                        ),
                                        height: 60,width: 60,
                                        // child: Image.network(e!.path,fit: BoxFit.cover,),
                                      ),
                                      GestureDetector(
                                        child: CircleAvatar(
                                          backgroundColor: AppColor.accentColor,radius: 10,
                                          child: Center(child: Icon(Icons.clear,color: AppColor.textColor,size: 15,)),
                                        ),
                                        onTap: (){
                                          selectedImagesDesktop.remove(e);
                                        },
                                      )
                                    ],
                                  );
                                }).toList(),
                              ):SizedBox(),
                            ),
                          );
                        }),
                        GestureDetector(
                          onTap: () => pickImageDesktop(),
                          child: Container(
                            constraints: BoxConstraints(maxWidth: 80),
                            child: SvgPicture
                                .asset(
                              'assets/svg/camera.svg',
                              width: 30,
                              height: 30,
                              colorFilter: ColorFilter
                                  .mode(
                                  AppColor
                                      .iconViewColor,
                                  BlendMode
                                      .srcIn),),
                          ),

                        ),

                      ],
                    ),
                  ),
                ],
              ),
            )
        ),
      );
  }
}