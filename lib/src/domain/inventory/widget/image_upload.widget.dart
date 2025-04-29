

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../config/const/app_color.dart';
import '../controller/inventory.controller.dart';

class ImageUploadWidget extends StatelessWidget {
  final String recId;
  final int inventoryId;
  final InventoryController controller;

   const ImageUploadWidget({
    super.key,
    required this.recId,
    required this.inventoryId,
     required this.controller,
  });

  //InventoryController inventoryController = Get.find<InventoryController>();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () => controller.pickImageDesktop(
              recId,
              "image",
              "Deposit",
              inventoryId: inventoryId,
            ),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 100),
              child: SvgPicture.asset(
                'assets/svg/camera.svg',
                width: 25,
                height: 25,
                colorFilter: ColorFilter.mode(
                  AppColor.iconViewColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),

          Obx(() {
            if (controller.isUploadingDesktop.value) {
              return const CircularProgressIndicator();
            }
            return Wrap(
              children: controller.selectedImagesDesktop
                  .asMap()
                  .entries
                  .map((entry) => Chip(
                label: Text('تصویر ${entry.key + 1}'),
                deleteIcon: controller.uploadStatusesDesktop[entry.key]
                    ? const Icon(Icons.check)
                    : const Icon(Icons.close),
                onDeleted: () {},
              ))
                  .toList(),
            );
          }),
        ],
      ),
    );
  }
}