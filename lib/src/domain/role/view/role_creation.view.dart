import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/const/app_color.dart';
import 'package:hanigold_admin/src/domain/role/controller/role_cteation.controller.dart';
import 'package:hanigold_admin/src/domain/role/model/element.model.dart';
import 'package:hanigold_admin/src/domain/role/model/element_action.model.dart';
import 'package:hanigold_admin/src/widget/app_drawer.widget.dart';
import 'package:hanigold_admin/src/widget/custom_appbar1.widget.dart';

class RoleCreationView extends StatelessWidget {
  const RoleCreationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RoleCreationController controller = Get.find<RoleCreationController>();

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: CustomAppbar1(
        title: 'افزودن نقش جدید', onBackTap: () => Get.offNamed('/home'),),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBasicInformationSection(controller),
            const SizedBox(height: 24),
            _buildPermissionsSection(controller),
          ],
        ),
      ),
      //floatingActionButton: _buildFloatingActionButton(),
      bottomNavigationBar: _buildBottomBar(controller),
    );
  }

  Widget _buildBasicInformationSection(RoleCreationController controller) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColor.secondaryColor.withAlpha(200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'اطلاعات پایه',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          _buildInputField(
            controller: controller.englishNameController,
            label: 'نام (انگلیسی)',
            hint: 'نام نقش به انگلیسی',
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9 ]')),
            ],
          ),
          const SizedBox(height: 15),
          _buildInputField(
            controller: controller.persianNameController,
            label: 'نام (فارسی)',
            hint: 'نام نقش به فارسی',
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[\u0600-\u06FF\0-9 ]')),
            ],
          ),
          const SizedBox(height: 15),
          Obx(() =>
              Row(
                children: [
                  Checkbox(
                    value: controller.isRoleActive.value,
                    onChanged: (value) =>
                    controller.isRoleActive.value = value ?? true,
                    activeColor: Colors.green,
                  ),
                  const Text(
                    'نقش فعال است',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: const Color(0xFF1A1A1A),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColor.secondary3Color),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPermissionsSection(RoleCreationController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main permissions section
        _buildMainPermissionsSection(controller),
        const SizedBox(height: 24),
        // Sub-permissions section
        _buildSubPermissionsSection(controller),
      ],
    );
  }

  Widget _buildMainPermissionsSection(RoleCreationController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColor.secondaryColor.withAlpha(200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
               Text(
                  'لیست مجوزها',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              const SizedBox(width: 20),
              Expanded(
                child: Row(
                  children: [
                    Obx(() {
                      return ElevatedButton(
                        onPressed: controller.deselectAllElements,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: controller.selectedElements.length == 0
                              ? AppColor.accentColor.withAlpha(50)
                              : AppColor.backGroundColor.withAlpha(50),
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('هیچ'),
                      );
                    }),
                    const SizedBox(width: 5),
                    Obx(() {
                      return ElevatedButton(
                        onPressed: controller.selectAllElements,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: controller.selectedElements.length ==
                              controller.elements.length
                              ? AppColor.primaryColor.withAlpha(50)
                              : AppColor.backGroundColor.withAlpha(50),
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('همه'),
                      );
                    }),
                  ],
                ),
              ),
              Obx(() =>
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColor.primaryColor.withAlpha(60),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${controller.selectedElements.length} از ${controller
                          .elements.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )),
            ],
          ),
          //const SizedBox(height: 20),
          /*Row(
            children: [
              Expanded(
                child: Obx(() {
                  return ElevatedButton(
                    onPressed: controller.deselectAllElements,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: controller.selectedElements.length == 0
                          ? AppColor.accentColor.withAlpha(50)
                          : AppColor.backGroundColor.withAlpha(50),
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('هیچ'),
                  );
                }),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Obx(() {
                  return ElevatedButton(
                    onPressed: controller.selectAllElements,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: controller.selectedElements.length ==
                          controller.elements.length
                          ? AppColor.primaryColor.withAlpha(50)
                          : AppColor.backGroundColor.withAlpha(50),
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('همه'),
                  );
                }),
              ),
            ],
          ),*/
          const SizedBox(height: 20),
          Obx(() {
            if (controller.isLoadingElements.value) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.green),
              );
            }
            return Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                decoration: BoxDecoration(
                  color: AppColor.textFieldColor.withAlpha(50),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFF64748B)),
                ),
                child: _buildMainPermissionsList(controller));
          }),
        ],
      ),
    );
  }

  Widget _buildSubPermissionsSection(RoleCreationController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColor.secondaryColor.withAlpha(200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
               Text(
                'زیرمجموعه',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Row(
                  children: [
                    Obx(() {
                      return ElevatedButton(
                        onPressed: controller.deselectAllSubElements,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: controller.selectedSubElements.length == 0
                              ? AppColor.accentColor.withAlpha(50)
                              : AppColor.backGroundColor.withAlpha(50),
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('هیچ'),
                      );
                    }),
                    const SizedBox(width: 5),
                    Obx(() {
                      return ElevatedButton(
                        onPressed: controller.selectAllSubElements,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: controller.selectedSubElements.length ==
                              controller.subElements.values
                                  .expand((x) => x)
                                  .length
                              ? AppColor.primaryColor.withAlpha(50)
                              : AppColor.backGroundColor.withAlpha(50),
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('همه'),
                      );
                    }),
                  ],
                ),
              ),
              Obx(() =>
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColor.primaryColor.withAlpha(60),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${controller.selectedSubElements.length} از ${controller
                          .subElements.values
                          .expand((x) => x)
                          .length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )),
            ],
          ),
          //const SizedBox(height: 20),
          /*Row(
            children: [
              Expanded(
                child: Obx(() {
                  return ElevatedButton(
                    onPressed: controller.deselectAllSubElements,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: controller.selectedSubElements.length == 0
                          ? AppColor.accentColor.withAlpha(50)
                          : AppColor.backGroundColor.withAlpha(50),
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('هیچ'),
                  );
                }),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Obx(() {
                  return ElevatedButton(
                    onPressed: controller.selectAllSubElements,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: controller.selectedSubElements.length ==
                          controller.subElements.values
                              .expand((x) => x)
                              .length
                          ? AppColor.primaryColor.withAlpha(50)
                          : AppColor.backGroundColor.withAlpha(50),
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('همه'),
                  );
                }),
              ),
            ],
          ),*/
          const SizedBox(height: 20),
          Obx(() => Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
              decoration: BoxDecoration(
                color: AppColor.textFieldColor.withAlpha(50),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF64748B)),
              ),
              child: _buildSubPermissionsList(controller))),
        ],
      ),
    );
  }

  Widget _buildMainPermissionsList(RoleCreationController controller) {
    // Organize elements into three columns
    final elementsPerColumn = (controller.elements.length / 3).ceil();
    final column1 = controller.elements.take(elementsPerColumn).toList();
    final column2 = controller.elements.skip(elementsPerColumn).take(
        elementsPerColumn).toList();
    final column3 = controller.elements.skip(elementsPerColumn * 2).toList();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Column 1
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: column1.map((element) =>
                _buildPermissionItem(
                  controller: controller,
                  element: element,
                  isMainPermission: true,
                ),
            ).toList(),
          ),
        ),
        const SizedBox(width: 12),
        // Column 2
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: column2.map((element) =>
                _buildPermissionItem(
                  controller: controller,
                  element: element,
                  isMainPermission: true,
                ),
            ).toList(),
          ),
        ),
        const SizedBox(width: 12),
        // Column 3
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: column3.map((element) =>
                _buildPermissionItem(
                  controller: controller,
                  element: element,
                  isMainPermission: true,
                ),
            ).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildPermissionItem({
    required RoleCreationController controller,
    required ElementModel element,
    required bool isMainPermission,
  }) {
    return Obx(() {
      final isSelected = controller.selectedElements.contains(element.id);
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            Checkbox(
              value: isSelected,
              onChanged: (value) {
                if (isMainPermission) {
                  controller.toggleElementSelection(element.id!);
                }
              },
              activeColor: Colors.green,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    element.title ?? element.name ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (element.description != null)
                    Text(
                      element.description ?? "",
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 11,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSubPermissionsList(RoleCreationController controller) {
    if (controller.selectedElements.isEmpty) {
      return const Text(
        'ابتدا یک مجوز اصلی انتخاب کنید',
        style: TextStyle(color: Colors.grey, fontSize: 14),
      );
    }

    // Collect all sub-elements from selected main elements
    final allSubElements = <ElementActionModel>[];
    for (final elementId in controller.selectedElements) {
      final subElements = controller.subElements[elementId] ?? [];
      allSubElements.addAll(subElements);
    }

    if (allSubElements.isEmpty) {
      return const Text(
        'در حال بارگذاری زیرمجوزها...',
        style: TextStyle(color: Colors.grey, fontSize: 14),
      );
    }

    // Organize sub-elements into three columns
    final elementsPerColumn = (allSubElements.length / 3).ceil();
    final column1 = allSubElements.take(elementsPerColumn).toList();
    final column2 = allSubElements.skip(elementsPerColumn).take(
        elementsPerColumn).toList();
    final column3 = allSubElements.skip(elementsPerColumn * 2).toList();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Column 1
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: column1.map((subElement) =>
                _buildSubPermissionItem(controller, subElement)
            ).toList(),
          ),
        ),
        const SizedBox(width: 12),
        // Column 2
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: column2.map((subElement) =>
                _buildSubPermissionItem(controller, subElement)
            ).toList(),
          ),
        ),
        const SizedBox(width: 12),
        // Column 3
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: column3.map((subElement) =>
                _buildSubPermissionItem(controller, subElement)
            ).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSubPermissionItem(RoleCreationController controller,
      ElementActionModel subElement,) {
    return Obx(() {
      final isSelected = controller.selectedSubElements.contains(subElement.id);
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            Checkbox(
              value: isSelected,
              onChanged: (value) =>
                  controller.toggleSubElementSelection(subElement.id!),
              activeColor: AppColor.secondary2Color,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subElement.title ?? subElement.name ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    subElement.name ?? "",
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  /* Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {},
      backgroundColor: Colors.green,
      child: const Icon(Icons.chat, color: Colors.white),
    );
  }*/

  Widget _buildBottomBar(RoleCreationController controller) {
    return Container(
      height: 80,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColor.secondaryColor,
        border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: controller.cancelRoleCreation,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A1A1A),
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.grey),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('انصراف'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: controller.createRole,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.buttonColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('ایجاد نقش'),
            ),
          ),
        ],
      ),
    );
  }
}
