import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/repository/role.repository.dart';
import 'package:hanigold_admin/src/domain/role/model/element.model.dart';
import 'package:hanigold_admin/src/domain/role/model/element_getOne.model.dart';
import 'package:hanigold_admin/src/domain/role/model/element_action.model.dart';

class RoleCreationController extends GetxController {
  final RoleRepository _roleRepository = RoleRepository();

  // Form controllers
  final TextEditingController englishNameController = TextEditingController();
  final TextEditingController persianNameController = TextEditingController();
  final RxBool isRoleActive = true.obs;

  // Loading states
  final RxBool isLoadingElements = false.obs;
  final RxBool isLoadingSubElements = false.obs;

  // Data
  final RxList<ElementModel> elements = <ElementModel>[].obs;
  final RxMap<int, List<ElementActionModel>> subElements = <int, List<ElementActionModel>>{}.obs;
  final RxSet<int> selectedElements = <int>{}.obs;
  final RxSet<int> selectedSubElements = <int>{}.obs;

  // Permission count
  final RxInt selectedPermissionCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadElements();
  }

  @override
  void onClose() {
    englishNameController.dispose();
    persianNameController.dispose();
    super.onClose();
  }

  /// Load all available elements (permissions) from API
  Future<void> loadElements() async {
    try {
      isLoadingElements.value = true;
      final elementsList = await _roleRepository.getElementList();
      elements.value = elementsList;
      updateSelectedPermissionCount();
    } catch (e) {
      Get.snackbar('خطا', 'خطا در بارگذاری مجوزها: $e');
    } finally {
      isLoadingElements.value = false;
    }
  }

  /// Load sub-elements (actions) for a specific element
  Future<void> loadSubElements(int elementId) async {
    try {
      isLoadingSubElements.value = true;
      final elementDetails = await _roleRepository.getOneElement(elementId);
      if (elementDetails.elementActions != null) {
        subElements[elementId] = elementDetails.elementActions!;
      }
    } catch (e) {
      Get.snackbar('خطا', 'خطا در بارگذاری زیرمجوزها: $e');
    } finally {
      isLoadingSubElements.value = false;
    }
  }

  /// Toggle selection of a main element
  void toggleElementSelection(int elementId) {
    if (selectedElements.contains(elementId)) {
      selectedElements.remove(elementId);
      // Remove all sub-elements when main element is deselected
      final subElementIds = subElements[elementId]?.map((e) => e.id).whereType<int>().toSet() ?? {};
      selectedSubElements.removeAll(subElementIds);
    } else {
      selectedElements.add(elementId);
      // Load sub-elements if not already loaded
      if (!subElements.containsKey(elementId)) {
        loadSubElements(elementId);
      }
    }
    updateSelectedPermissionCount();
  }

  /// Toggle selection of a sub-element
  void toggleSubElementSelection(int subElementId) {
    if (selectedSubElements.contains(subElementId)) {
      selectedSubElements.remove(subElementId);
    } else {
      selectedSubElements.add(subElementId);
    }
    updateSelectedPermissionCount();
  }

  /// Select all elements
  void selectAllElements() {
    selectedElements.clear();
    selectedSubElements.clear();
    for (final element in elements) {
      if (element.id != null) {
        selectedElements.add(element.id!);
        if (!subElements.containsKey(element.id!)) {
          loadSubElements(element.id!);
        }
      }
    }
    updateSelectedPermissionCount();
  }

  /// Deselect all elements
  void deselectAllElements() {
    selectedElements.clear();
    selectedSubElements.clear();
    updateSelectedPermissionCount();
  }

  /// Select all sub-elements
  void selectAllSubElements() {
    selectedSubElements.clear();
    for (final elementId in selectedElements) {
      final subElementsList = subElements[elementId] ?? [];
      for (final subElement in subElementsList) {
        if (subElement.id != null) {
          selectedSubElements.add(subElement.id!);
        }
      }
    }
    updateSelectedPermissionCount();
  }

  /// Deselect all sub-elements
  void deselectAllSubElements() {
    selectedSubElements.clear();
    updateSelectedPermissionCount();
  }

  /// Update the selected permission count
  void updateSelectedPermissionCount() {
    selectedPermissionCount.value = selectedElements.length + selectedSubElements.length;
  }

  /// Validate form
  bool validateForm() {
    if (englishNameController.text.trim().isEmpty) {
      Get.snackbar('خطا', 'نام انگلیسی نقش الزامی است');
      return false;
    }
    if (persianNameController.text.trim().isEmpty) {
      Get.snackbar('خطا', 'نام فارسی نقش الزامی است');
      return false;
    }
    if (selectedElements.isEmpty && selectedSubElements.isEmpty) {
      Get.snackbar('خطا', 'حداقل یک مجوز باید انتخاب شود');
      return false;
    }
    return true;
  }

  /// Create role
  Future<void> createRole() async {
    if (!validateForm()) return;

    try {
      // TODO: Implement role creation API call
      // For now, just show success message
      Get.snackbar('موفق', 'نقش با موفقیت ایجاد شد');

      // Reset form
      englishNameController.clear();
      persianNameController.clear();
      selectedElements.clear();
      selectedSubElements.clear();
      subElements.clear();
      isRoleActive.value = true;
      updateSelectedPermissionCount();

    } catch (e) {
      Get.snackbar('خطا', 'خطا در ایجاد نقش: $e');
    }
  }

  /// Cancel role creation
  void cancelRoleCreation() {
    Get.back();
  }
}
