

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hanigold_admin/src/domain/inventory/controller/inventory_create_receive.controller.dart';
import 'package:uuid/uuid.dart';
import 'package:responsive_framework/responsive_framework.dart';

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
    selectedImagesDesktop.clear();
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
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;

    return Card(
      color: AppColor.backGroundColor,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: isMobile ? 80 : 60,
          minWidth: isMobile ? double.infinity : 100,
        ),
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 12.0 : 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Item details - responsive layout
              isMobile
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Item name - full width on mobile
                  Text(
                    widget.detail.item?.name ?? '',
                    style: AppTextStyle.bodyText.copyWith(
                      fontSize: isMobile ? 13 : 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  // Quantity and weight in a row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          'مقدار: ${widget.detail.quantity}',
                          style: AppTextStyle.bodyText.copyWith(
                            fontSize: isMobile ? 11 : 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          'وزن750: ${widget.detail.weight750}',
                          style: AppTextStyle.bodyText.copyWith(
                            fontSize: isMobile ? 11 : 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              )
                  : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child: Text(
                      widget.detail.item?.name ?? '',
                      style: AppTextStyle.bodyText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      'مقدار: ${widget.detail.quantity}',
                      style: AppTextStyle.bodyText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      'وزن750: ${widget.detail.weight750}',
                      style: AppTextStyle.bodyText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              // Description
              Padding(
                padding: EdgeInsets.only(
                  right: isMobile ? 0 : 35,
                  top: isMobile ? 8 : 10,
                ),
                child: Text(
                  'توضیحات: ${widget.detail.description}',
                  style: AppTextStyle.bodyText.copyWith(
                    fontSize: isMobile ? 11 : 12,
                  ),
                  maxLines: isMobile ? 2 : 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              SizedBox(height: isMobile ? 8 : 10),

              // Image section - responsive
              Container(
                padding: EdgeInsets.only(
                  bottom: 5,
                  right: isMobile ? 0 : 10,
                ),
                child: isMobile
                    ? Column(
                  children: [
                    // Upload status or image gallery
                    Obx(() {
                      if (inventoryCreateReceiveController.isUploadingDesktop.value) {
                        return Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  'در حال بارگزاری عکس',
                                  style: AppTextStyle.labelText.copyWith(
                                    fontSize: 11,
                                    fontWeight: FontWeight.normal,
                                    color: AppColor.textColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: 8),
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            ],
                          ),
                        );
                      }

                      return widget.image.isNotEmpty
                          ? Container(
                        height: 70,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: widget.image.map((e) {
                              return Stack(
                                children: [
                                  GestureDetector(
                                    onTap: () => _showImageDialog(context, e),
                                    child: Container(
                                      margin: EdgeInsets.only(right: 8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(color: AppColor.textColor),
                                        image: DecorationImage(
                                          image: NetworkImage(e.path),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      height: 50,
                                      width: 50,
                                    ),
                                  ),
                                  Positioned(
                                    top: -5,
                                    right: 0,
                                    child: GestureDetector(
                                      child: CircleAvatar(
                                        backgroundColor: AppColor.accentColor,
                                        radius: 8,
                                        child: Icon(
                                          Icons.clear,
                                          color: AppColor.textColor,
                                          size: 12,
                                        ),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          widget.image.remove(e);
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      )
                          : SizedBox.shrink();
                    }),

                    // Camera button - full width on mobile
                    SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => pickImageDesktop(),
                      child: Container(
                        width: double.infinity,
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColor.iconViewColor),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              'assets/svg/camera.svg',
                              width: 20,
                              height: 20,
                              colorFilter: ColorFilter.mode(
                                AppColor.iconViewColor,
                                BlendMode.srcIn,
                              ),
                            ),
                            SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                'افزودن عکس',
                                style: AppTextStyle.labelText.copyWith(
                                  fontSize: 12,
                                  color: AppColor.iconViewColor,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
                    : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(() {
                      if (inventoryCreateReceiveController.isUploadingDesktop.value) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                'در حال بارگزاری عکس',
                                style: AppTextStyle.labelText.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  color: AppColor.textColor,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 8),
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ],
                        );
                      }

                      return SizedBox(
                        height: 80,
                        width: Get.width * 0.18,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: widget.image.isNotEmpty
                              ? Row(
                            children: widget.image.map((e) {
                              return Stack(
                                children: [
                                  GestureDetector(
                                    onTap: () => _showImageDialog(context, e),
                                    child: Container(
                                      margin: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: AppColor.textColor),
                                        image: DecorationImage(
                                          image: NetworkImage(e.path),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      height: 60,
                                      width: 60,
                                    ),
                                  ),
                                  GestureDetector(
                                    child: CircleAvatar(
                                      backgroundColor: AppColor.accentColor,
                                      radius: 10,
                                      child: Center(
                                        child: Icon(
                                          Icons.clear,
                                          color: AppColor.textColor,
                                          size: 15,
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        widget.image.remove(e);
                                      });
                                    },
                                  ),
                                ],
                              );
                            }).toList(),
                          )
                              : SizedBox(),
                        ),
                      );
                    }),

                    GestureDetector(
                      onTap: () => pickImageDesktop(),
                      child: Container(
                        constraints: BoxConstraints(maxWidth: 80),
                        child: SvgPicture.asset(
                          'assets/svg/camera.svg',
                          width: 30,
                          height: 30,
                          colorFilter: ColorFilter.mode(
                            AppColor.iconViewColor,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showImageDialog(BuildContext context, XFile image) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: EdgeInsets.all(isMobile ? 20 : 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColor.textColor),
                image: DecorationImage(
                  image: NetworkImage(image.path),
                  fit: BoxFit.cover,
                ),
              ),
              height: isMobile ? Get.height * 0.6 : Get.height * 0.8,
              width: isMobile ? Get.width * 0.8 : Get.width * 0.4,
            ),
          ),
        );

      },
    );
  }
}