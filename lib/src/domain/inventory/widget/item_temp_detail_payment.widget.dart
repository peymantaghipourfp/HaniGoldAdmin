import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uuid/uuid.dart';

import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../config/repository/url/base_url.dart';
import '../controller/inventory_create_payment.controller.dart';
import '../model/inventory_detail.model.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ItemTempDetailWidgetPayment extends StatefulWidget {
  final InventoryDetailModel detail;
  final double quantity;
  final List<XFile> image;
  final Function(double)? onQuantityChanged;
  final Function(String, List<XFile>)? recId;

  const ItemTempDetailWidgetPayment({
    super.key,
    required this.detail,
    required this.quantity,
    this.onQuantityChanged,
    this.recId,
    required this.image,
  });

  @override
  State<ItemTempDetailWidgetPayment> createState() =>
      _ItemTempDetailWidgetPayment();
}

class _ItemTempDetailWidgetPayment extends State<ItemTempDetailWidgetPayment> {
  TextEditingController quantityController = TextEditingController();
  InventoryCreatePaymentController inventoryCreatePaymentController = Get.find<
      InventoryCreatePaymentController>();
  final ImagePicker _picker = ImagePicker();
  RxList<XFile> selectedImagesDesktop = RxList<XFile>();
  var recordId = "".obs;
  var uuid = Uuid();

  Future<void> pickImageDesktop() async {
    recordId.value = uuid.v4();
    selectedImagesDesktop.clear();
    try {
      final List<XFile> images = await _picker.pickMultiImage();
      if (images.isNotEmpty) {
        setState(() {
          selectedImagesDesktop.addAll(images);
        });
      }
    } catch (e) {
      throw Exception('خطا در انتخاب فایل‌ها');
    }
    if (selectedImagesDesktop.isNotEmpty) {
      setState(() {
        widget.recId?.call(recordId.value, selectedImagesDesktop);
      });
    }
  }

  @override
  void initState() {
    quantityController.text = widget.quantity.toString();
    print("image::::::::${widget.image}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
      Card(
        color: AppColor.backGroundColor,
        child: ConstrainedBox(
            constraints: BoxConstraints(
                minHeight: 60, minWidth: 100
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(widget.detail.item?.name ?? '',
                        style: AppTextStyle.bodyText,),
                      SizedBox(height: 4,),
                      Text('مقدار: ${widget.detail.quantity}',
                        style: AppTextStyle.bodyText,),
                      SizedBox(height: 4,),
                      Text('وزن750: ${widget.detail.weight750}',
                        style: AppTextStyle.bodyText,),
                    ],
                  ),
                  // Show calculated weight for طلای آبشده items
                  if (widget.detail.item?.id == 1) ...[
                    SizedBox(height: 8,),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColor.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: AppColor.primaryColor.withOpacity(0.3)),
                      ),
                      child: Text(
                        'وزن محاسبه شده: ${((widget.detail.quantity ?? 0) * (widget.detail.carat ?? 0) / 750).toStringAsFixed(3)}',
                        style: AppTextStyle.bodyText.copyWith(
                          color: AppColor.primaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                  Padding(
                    padding: const EdgeInsets.only(right: 35, top: 10),
                    child: Text('توضیحات: ${widget.detail.description}',
                      style: AppTextStyle.bodyText,),
                  ),
                  SizedBox(height: 10,),
                  // مقدار
                  widget.detail.item?.id == 1 ?
                  Container(
                    //height: 50,
                    padding: EdgeInsets.only(bottom: 5),
                    child:
                    IntrinsicHeight(
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: quantityController,
                        style: AppTextStyle.labelText,
                        keyboardType: TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: [FilteringTextInputFormatter.allow(
                            RegExp(r'^[\d٠-٩۰-۹]*\.?[\d٠-٩۰-۹]*$')),
                          TextInputFormatter.withFunction((oldValue, newValue) {
                            // تبدیل اعداد فارسی به انگلیسی برای پردازش راحت‌تر
                            String newText = newValue.text
                                .replaceAll('٠', '0')
                                .replaceAll('١', '1')
                                .replaceAll('٢', '2')
                                .replaceAll('٣', '3')
                                .replaceAll('٤', '4')
                                .replaceAll('٥', '5')
                                .replaceAll('٦', '6')
                                .replaceAll('٧', '7')
                                .replaceAll('٨', '8')
                                .replaceAll('٩', '9');

                            return newValue.copyWith(text: newText,
                                selection: TextSelection.collapsed(
                                    offset: newText.length));
                          }),
                        ],
                        decoration: InputDecoration(
                          isDense: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: AppColor.textFieldColor,
                          errorMaxLines: 1,
                        ),
                        onChanged: (value) {
                          final newQuantity = double.tryParse(value) ?? 0.0;
                          widget.onQuantityChanged?.call(newQuantity);
                          // Debug print for weight calculation
                          if (widget.detail.item?.id == 1) {
                            final carat = widget.detail.carat ?? 0;
                            final calculatedWeight = (newQuantity * carat) / 750;
                            print('طلای آبشده33333 - Weight calculation: ($newQuantity * $carat) / 750 = $calculatedWeight');
                          }
                        },
                      ),
                    ),
                  ) : SizedBox.shrink(),

                  //(widget.detail.fetchedImageUrls != null && widget.detail.fetchedImageUrls!.isNotEmpty) ?
                  /*SizedBox(
                      width: Get.width * 0.7,
                      height: 100,
                      child: Row(
                        children: widget.detail.fetchedImageUrls!
                            .map((e) =>
                            Stack(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    showGeneralDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        barrierLabel: MaterialLocalizations
                                            .of(context)
                                            .modalBarrierDismissLabel,
                                        barrierColor: Colors.black45,
                                        transitionDuration: const Duration(
                                            milliseconds: 200),
                                        pageBuilder: (BuildContext buildContext,
                                            Animation animation,
                                            Animation secondaryAnimation) {
                                          return Center(
                                            child: Material(
                                              color: Colors.transparent,
                                              child: Container(
                                                margin: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius
                                                        .circular(8),
                                                    border: Border.all(
                                                        color: AppColor
                                                            .textColor),
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                          "${BaseUrl.baseUrl}Attachment/downloadAttachment?fileName=$e"),
                                                      fit: BoxFit.fill,
                                                    )
                                                ),
                                                height: Get.height * 0.8,
                                                width: Get.width * 0.4,
                                                // child: Image.network(e!.path,fit: BoxFit.cover,),
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            color: AppColor.textColor),
                                        image: DecorationImage(
                                          image: NetworkImage("${BaseUrl.baseUrl}Attachment/downloadAttachment?fileName=$e"),
                                          fit: BoxFit.cover,
                                        )
                                    ),
                                    height: 60, width: 60,
                                    // child: Image.network(e!.path,fit: BoxFit.cover,),
                                  ),
                                ),
                                GestureDetector(
                              child: CircleAvatar(
                                backgroundColor: AppColor.accentColor,radius: 10,
                                child: Center(child: Icon(Icons.clear,color: AppColor.textColor,size: 15,)),
                              ),
                              *//*onTap: (){
                                inventoryCreatePaymentController.deleteImage(e);
                              },*//*
                            )
                              ],
                            ),).toList(),
                      ),
                    )*/
                  //:
                  Container(
                    padding: EdgeInsets.only(bottom: 5, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(() {
                          if (inventoryCreatePaymentController
                              .isUploadingDesktop
                              .value) {
                            return Row(
                              children: [
                                Text(
                                  'در حال بارگزاری عکس',
                                  style: AppTextStyle.labelText.copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      color: AppColor.textColor),
                                ),
                                SizedBox(width: 10,),
                                CircularProgressIndicator(),
                              ],
                            );
                          }
                          return SizedBox(
                            height: 80,
                            width: Get.width * 0.17,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: widget.image.isNotEmpty ? Row(
                                children: widget.image.map((e) {
                                  return Stack(
                                    children: [
                                      GestureDetector(
                                        onTap:(){
                                          showGeneralDialog(
                                              context: context,
                                              barrierDismissible: true,
                                              barrierLabel: MaterialLocalizations.of(context)
                                                  .modalBarrierDismissLabel,
                                              barrierColor: Colors.black45,
                                              transitionDuration: const Duration(milliseconds: 200),
                                              pageBuilder: (BuildContext buildContext,
                                                  Animation animation,
                                                  Animation secondaryAnimation) {
                                                return Center(
                                                  child: Material(
                                                    color: Colors.transparent,
                                                    child: Container(
                                                      margin: EdgeInsets.all(10),
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(8),
                                                          border: Border.all(color: AppColor.textColor),
                                                          image: DecorationImage(
                                                            image: NetworkImage(e.path,),
                                                            /*image: e.path.startsWith('http')
                                                    ? NetworkImage(e.path)
                                                    : FileImage(File(e.path)) as ImageProvider,*/
                                                            fit: BoxFit.cover,)
                                                      ),
                                                      height: Get.height * 0.8,width: Get.width * 0.4,
                                                      // child: Image.network(e!.path,fit: BoxFit.cover,),
                                                    ),
                                                  ),
                                                );
                                              });
                                        },
                                        child: Container(
                                          margin: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(
                                                  8),
                                              border: Border.all(
                                                  color: AppColor.textColor),
                                              image: DecorationImage(
                                                image: NetworkImage(e.path,),
                                                /*image: e.path.startsWith('http')
                                                    ? NetworkImage(e.path)
                                                    : FileImage(File(e.path)) as ImageProvider,*/
                                                fit: BoxFit.cover,)
                                          ),

                                          height: 60, width: 60,
                                          // child: Image.network(e!.path,fit: BoxFit.cover,),
                                        ),
                                      ),
                                      GestureDetector(
                                        child: CircleAvatar(
                                          backgroundColor: AppColor.accentColor,
                                          radius: 10,
                                          child: Center(child: Icon(Icons.clear,
                                            color: AppColor.textColor,
                                            size: 15,)),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            widget.image.remove(e);
                                          });
                                        },
                                      )
                                    ],
                                  );
                                }).toList(),
                              ) : SizedBox(),
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