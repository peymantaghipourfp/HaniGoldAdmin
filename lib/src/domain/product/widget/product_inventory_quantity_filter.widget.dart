import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/product/controller/product_inventory_quantity.controller.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';


class ProductInventoryQuantityFilterWidget extends StatefulWidget {
  final ProductInventoryQuantityController controller;
  final VoidCallback onFilterApplied;
  final VoidCallback onFilterCleared;

  const ProductInventoryQuantityFilterWidget({
    super.key,
    required this.controller,
    required this.onFilterApplied,
    required this.onFilterCleared,
  });

  @override
  State<ProductInventoryQuantityFilterWidget> createState() =>
      _ProductInventoryQuantityFilterWidgetState();
}

class _ProductInventoryQuantityFilterWidgetState
    extends State<ProductInventoryQuantityFilterWidget> {
  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return isDesktop ?
    OutlinedButton.icon(
        onPressed: () => _showFilterDialog(context, isDesktop),
        label: Text(
          'فیلتر',
          style: AppTextStyle.labelText.copyWith(
            fontSize: isDesktop ? 12 : 10,
            color: _hasActiveFilters() ? AppColor.accentColor : AppColor
                .textColor,
          ),
        ),
      icon: SvgPicture.asset(
        'assets/svg/filter3.svg',
        height: 17,
        colorFilter: ColorFilter.mode(
          _hasActiveFilters() ? AppColor.accentColor : AppColor.textColor,
          BlendMode.srcIn,
        ),
      ),
    ):
      /*ElevatedButton(
      style: ButtonStyle(
          padding: WidgetStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 23, vertical: 12)
          ),
          backgroundColor: WidgetStatePropertyAll(
              AppColor.appBarColor.withOpacity(0.5)
          ),
          shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                  side: BorderSide(color: AppColor.textColor),
                  borderRadius: BorderRadius.circular(5)
              )
          )
      ),
      onPressed: () => _showFilterDialog(context, isDesktop),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/svg/filter3.svg',
            height: 17,
            colorFilter: ColorFilter.mode(
              _hasActiveFilters() ? AppColor.accentColor : AppColor.textColor,
              BlendMode.srcIn,
            ),
          ),
          SizedBox(width: 10),
          Text(
            'فیلتر',
            style: AppTextStyle.labelText.copyWith(
              fontSize: isDesktop ? 12 : 10,
              color: _hasActiveFilters() ? AppColor.accentColor : AppColor
                  .textColor,
            ),
          ),
        ],
      ),
    ):*/
    Container(
      margin: const EdgeInsets.symmetric(horizontal: 5,),
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 4),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _showFilterDialog(context, isDesktop),
            child: SvgPicture.asset(
              'assets/svg/filter3.svg',
              height: 30,
              colorFilter:
              ColorFilter.mode(
                _hasActiveFilters() ? AppColor.filterColor : AppColor.textColor,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
    );

  }

  bool _hasActiveFilters() {
    return widget.controller.dateStartController.text.isNotEmpty ||
        widget.controller.dateEndController.text.isNotEmpty ||
        widget.controller.userFilterController.text.isNotEmpty ||
        widget.controller.amountFilterController.text.isNotEmpty;
  }

  void _showFilterDialog(BuildContext context, bool isDesktop) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations
          .of(context)
          .modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext buildContext, Animation animation,
          Animation secondaryAnimation) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColor.backGroundColor
              ),
              width: isDesktop ? Get.width * 0.2 : Get.height * 0.5,
              height: isDesktop ? Get.height * 0.65 : Get.height * 0.7,
              padding: EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildHeader(isDesktop),
                    Container(
                      color: AppColor.textColor,
                      height: 0.2,
                    ),
                    _buildFilterContent(context),
                    _buildFilterButton(isDesktop),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(bool isDesktop) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Center(
              child: Text(
                'فیلتر',
                style: AppTextStyle.labelText.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 50,
            height: 27,
            child: ElevatedButton(
              style: ButtonStyle(
                  padding: WidgetStatePropertyAll(
                      EdgeInsets.symmetric(horizontal: 2, vertical: 1)
                  ),
                  backgroundColor: WidgetStatePropertyAll(
                      AppColor.accentColor.withOpacity(0.5)
                  ),
                  shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                          side: BorderSide(color: AppColor.textColor),
                          borderRadius: BorderRadius.circular(5)
                      )
                  )
              ),
              onPressed: () {
                widget.controller.clearFilter();
                widget.onFilterCleared();
                Get.back();
              },
              child: Text(
                'حذف فیلتر',
                style: AppTextStyle.labelText.copyWith(
                    fontSize: isDesktop ? 9 : 8
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          SizedBox(height: 8),
          _buildDateField(
            label: 'از تاریخ',
            controller: widget.controller.dateStartController,
            onDateSelected: (Jalali pickedDate) {
              Gregorian gregorian = pickedDate.toGregorian();
              widget.controller.startDateFilter.value =
              "${gregorian.year}-${gregorian.month.toString().padLeft(
                  2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";
              widget.controller.dateStartController.text =
              "${pickedDate.year}/${pickedDate.month.toString().padLeft(
                  2, '0')}/${pickedDate.day.toString().padLeft(2, '0')}";
            },
          ),
          SizedBox(height: 8),
          _buildDateField(
            label: 'تا تاریخ',
            controller: widget.controller.dateEndController,
            onDateSelected: (Jalali pickedDate) {
              Gregorian gregorian = pickedDate.toGregorian();
              widget.controller.endDateFilter.value =
              "${gregorian.year}-${gregorian.month.toString().padLeft(
                  2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";
              widget.controller.dateEndController.text =
              "${pickedDate.year}/${pickedDate.month.toString().padLeft(
                  2, '0')}/${pickedDate.day.toString().padLeft(2, '0')}";
            },
          ),
          SizedBox(height: 8),
          _buildUserField(),
          SizedBox(height: 8),
          _buildAmountField(),
        ],
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required TextEditingController controller,
    required Function(Jalali) onDateSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyle.labelText.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.normal,
            color: AppColor.textColor,
          ),
        ),
        Container(
          padding: EdgeInsets.only(bottom: 5),
          child: IntrinsicHeight(
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'لطفا تاریخ را انتخاب کنید';
                }
                return null;
              },
              controller: controller,
              readOnly: true,
              style: AppTextStyle.labelText,
              decoration: InputDecoration(
                suffixIcon: Icon(
                  Icons.calendar_month,
                  color: AppColor.textColor,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: AppColor.textFieldColor,
                errorMaxLines: 1,
              ),
              onTap: () async {
                Jalali? pickedDate = await showPersianDatePicker(
                  context: Get.context!,
                  initialDate: Jalali.now(),
                  firstDate: Jalali(1400, 1, 1),
                  lastDate: Jalali(1450, 12, 29),
                  initialEntryMode: PersianDatePickerEntryMode.calendar,
                  initialDatePickerMode: PersianDatePickerMode.day,
                  locale: Locale("fa", "IR"),
                );
                if (pickedDate != null) {
                  onDateSelected(pickedDate);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'دریافت از',
          style: AppTextStyle.labelText.copyWith(
            fontSize: 11,
            fontWeight: FontWeight.normal,
            color: AppColor.textColor,
          ),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.only(bottom: 5),
          child: TextField(
            controller: widget.controller.userFilterController,
            onChanged: (value) {
              widget.controller.userFilter.value = value;
            },
            style: AppTextStyle.bodyText.copyWith(
              fontSize: 11,
              color: AppColor.textColor,
            ),
            decoration: InputDecoration(
              hintText: 'جستجو در نام ...',
              hintStyle: AppTextStyle.bodyText.copyWith(
                fontSize: 11,
                color: AppColor.textColor.withOpacity(0.5),
              ),
              filled: true,
              fillColor: AppColor.textFieldColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7),
                borderSide: BorderSide(color: AppColor.secondaryColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7),
                borderSide: BorderSide(color: AppColor.secondaryColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7),
                borderSide: BorderSide(color: AppColor.primaryColor),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAmountField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'مقدار',
          style: AppTextStyle.labelText.copyWith(
            fontSize: 11,
            fontWeight: FontWeight.normal,
            color: AppColor.textColor,
          ),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.only(bottom: 5),
          child: TextField(
            controller: widget.controller.amountFilterController,
            onChanged: (value) {
              widget.controller.amountFilter.value = value;
            },
            keyboardType: TextInputType.number,
            style: AppTextStyle.bodyText.copyWith(
              fontSize: 11,
              color: AppColor.textColor,
            ),
            decoration: InputDecoration(
              hintText: 'جستجو در مقادیر ...',
              hintStyle: AppTextStyle.bodyText.copyWith(
                fontSize: 11,
                color: AppColor.textColor.withOpacity(0.5),
              ),
              filled: true,
              fillColor: AppColor.textFieldColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7),
                borderSide: BorderSide(color: AppColor.secondaryColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7),
                borderSide: BorderSide(color: AppColor.secondaryColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7),
                borderSide: BorderSide(color: AppColor.primaryColor),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterButton(bool isDesktop) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      width: double.infinity,
      height: 40,
      child: ElevatedButton(
        style: ButtonStyle(
            padding: WidgetStatePropertyAll(
                EdgeInsets.symmetric(horizontal: 23)
            ),
            backgroundColor: WidgetStatePropertyAll(AppColor.appBarColor),
            shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                    side: BorderSide(color: AppColor.textColor),
                    borderRadius: BorderRadius.circular(5)
                )
            )
        ),
        onPressed: () {
          widget.controller.currentPage.value=1;
          widget.controller.itemsPerPage.value=25;
          widget.onFilterApplied();
          Get.back();
        },
        child: Obx(() =>
        widget.controller.isLoadingDetails.value
            ? CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor),
        )
            : Text(
          'فیلتر',
          style: AppTextStyle.labelText.copyWith(
              fontSize: isDesktop ? 12 : 10
          ),
        )
        ),
      ),
    );
  }
}
