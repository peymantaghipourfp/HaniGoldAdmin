import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:hanigold_admin/src/config/const/app_color.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';

class CustomDropdownWidget extends StatelessWidget {
  final List<String> items;
  final String? selectedValue;
  final ValueChanged<String?> onChanged;
  final bool hideUnderline;
  final Color backgroundColor;
  final Color borderColor;
  final double borderRadius;

  const CustomDropdownWidget({
    super.key,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
    this.hideUnderline = true,
    this.backgroundColor = Colors.white,
    this.borderColor = Colors.grey,
    this.borderRadius = 7.0,
  });

  @override
  Widget build(BuildContext context) {
    Widget dropdown = DropdownButton2<String>(
      isExpanded: true,
      hint: Row(
        children: [
          Expanded(
            child: Text(
              "انتخاب کنید",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: 14,
                color: AppColor.textColor,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      items: items.map((String item) {
        return DropdownMenuItem(
          value: item,
          child: Text(
            item,
            style: AppTextStyle.bodyText,
          ),
        );
      }).toList(),
      value: (selectedValue != null && items.contains(selectedValue)) ? selectedValue : null,
      onChanged: onChanged,

      buttonStyleData: ButtonStyleData(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: backgroundColor,
          border: Border.all(color: borderColor, width: 1),
        ),
        elevation: 0,
      ),
      iconStyleData: IconStyleData(
        icon: const Icon(Icons.keyboard_arrow_down),
        iconSize: 23,
        iconEnabledColor: AppColor.textColor,
        iconDisabledColor: Colors.grey,
      ),
      dropdownStyleData: DropdownStyleData(
        maxHeight: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: backgroundColor,
        ),
        offset: const Offset(0, 0),
        scrollbarTheme: ScrollbarThemeData(
          radius: const Radius.circular(7),
          thickness: WidgetStateProperty.all(6),
          thumbVisibility: WidgetStateProperty.all(true),
        ),
      ),
      menuItemStyleData: const MenuItemStyleData(
        height: 40,
        padding: EdgeInsets.symmetric(horizontal: 10),
      ),
    );

    return hideUnderline
        ? DropdownButtonHideUnderline(child: dropdown)
        : dropdown;
  }
}
