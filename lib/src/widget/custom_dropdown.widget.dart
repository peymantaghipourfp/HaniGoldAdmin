import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:hanigold_admin/src/config/const/app_color.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:responsive_framework/responsive_framework.dart';

class CustomDropdownWidget extends StatefulWidget {
  final dynamic value;
  final bool showSearchBox;
  final DropdownSearchData<String>? dropdownSearchData;
  final List<String>? items;
  final String? selectedValue;
  final ValueChanged<String?>? onChanged;
  final bool hideUnderline;
  final Color backgroundColor;
  final Color borderColor;
  final double borderRadius;
  final bool showHintText;
  final String? Function(String?)? validator;
  final Function(bool)? onMenuStateChange;
  final bool enabledChange;

  const CustomDropdownWidget({
    super.key,
    this.value,
    this.showSearchBox=false,
    this.dropdownSearchData,
    this.items,
    this.selectedValue,
    this.onChanged,
    this.hideUnderline = true,
    this.backgroundColor = Colors.white,
    this.borderColor = Colors.grey,
    this.borderRadius = 7.0,
    this.showHintText=true,
    this.validator,
    this.onMenuStateChange,
    this.enabledChange = true,
  });

  @override
  State<CustomDropdownWidget> createState() => _CustomDropdownWidgetState();
}

class _CustomDropdownWidgetState extends State<CustomDropdownWidget> {
  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _handleMenuStateChange(bool isOpen) {
    if (isOpen && widget.showSearchBox) {
      // Add a small delay to ensure the dropdown is fully opened
      Future.delayed(const Duration(milliseconds: 150), () {
        if (mounted) {
          // Try to focus on any TextFormField in the dropdown overlay
          _focusSearchField();
        }
      });
    }

    // Call the original onMenuStateChange if provided
    widget.onMenuStateChange?.call(isOpen);
  }

  void _focusSearchField() {
    // Try to focus on our managed focus node first
    if (_searchFocusNode.canRequestFocus) {
      _searchFocusNode.requestFocus();
      return;
    }

    // If that doesn't work, try to find and focus any search field in the dropdown
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentContext = context;
      if (currentContext.mounted) {
        // Find the first focusable TextFormField in the widget tree
        final focusScope = FocusScope.of(currentContext);
        final nodes = focusScope.children.where((node) =>
        node.canRequestFocus &&
            node.context?.widget is TextFormField
        );

        if (nodes.isNotEmpty) {
          nodes.first.requestFocus();
        }
      }
    });
  }

  DropdownSearchData<String>? _getSearchData() {
    if (!widget.showSearchBox) return null;

    // If custom dropdownSearchData is provided, use it as is
    if (widget.dropdownSearchData != null) {
      return widget.dropdownSearchData;
    }

    // Return default search data with our focus node
    return DropdownSearchData<String>(
      searchController: _searchController,
      searchInnerWidgetHeight: 50,
      searchInnerWidget: Container(
        height: 50,
        padding: const EdgeInsets.only(
          top: 8,
          bottom: 4,
          right: 8,
          left: 8,
        ),
        child: TextFormField(
          focusNode: _searchFocusNode,
          expands: false,
          maxLines: null,
          onChanged: (value) {
            setState(() {});
          },
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 8,
            ),
            hintText: 'جستجو...',
            hintStyle: const TextStyle(fontSize: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      searchMatchFn: (item, searchValue) {
        if (item.value == null) return false;

        String displayText;
        if (item.value!.contains(':')) {
          int firstColonIndex = item.value!.indexOf(':');
          displayText = item.value!.substring(firstColonIndex + 1);
        } else {
          displayText = item.value!;
        }
        return displayText.toLowerCase().contains(searchValue.toLowerCase());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget dropdown = DropdownButton2<String>(
      onMenuStateChange: _handleMenuStateChange,
      dropdownSearchData: _getSearchData(),
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
      items: widget.items?.map((String item) {
        // Extract display text (everything after the first colon, or the full item if no colon)
        String displayText;
        if (item.contains(':')) {
          int firstColonIndex = item.indexOf(':');
          displayText = item.substring(firstColonIndex + 1);
        } else {
          displayText = item;
        }
        return DropdownMenuItem(
          value: item,
          child: Text(
            displayText,
            style: AppTextStyle.bodyText,
          ),
        );
      }).toList(),
      value: (widget.selectedValue != null && widget.items!.contains(widget.selectedValue)) ? widget.selectedValue : null,
      onChanged: widget.enabledChange ? widget.onChanged : null,

      buttonStyleData: ButtonStyleData(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          color: widget.backgroundColor,
          border: Border.all(color: widget.borderColor, width: 1),
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
          borderRadius: BorderRadius.circular(widget.borderRadius),
          color: widget.backgroundColor,
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
    final String? errorText =
    widget.validator != null ? widget.validator!(widget.selectedValue) : null;
    return
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.hideUnderline ? DropdownButtonHideUnderline(child: dropdown) : dropdown,
          if (errorText != null && errorText.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                errorText,
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            )
        ],
      );
  }
}
