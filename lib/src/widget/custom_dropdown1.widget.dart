import 'package:flutter/material.dart';
import 'package:hanigold_admin/src/config/const/app_color.dart';

import '../config/repository/url/base_url.dart';


class CustomDropdown<T> extends StatefulWidget {
  final List<T> items;
  final T? selectedItem;
  final Color? color;
  final ValueChanged<T?> onChanged;
  final String Function(T) itemLabel;
  final String Function(T)? itemIcon;
  final String hint;
  final bool enableSearch;
  final bool? isOpen;
  final bool isIcon;
  final String? errorText; // ✅ پیام خطا از بیرون

  const CustomDropdown({
    super.key,
    required this.items,
    this.selectedItem,
    required this.onChanged,
    required this.itemLabel,
    this.hint = "انتخاب کنید",
    this.enableSearch = false,
    this.isOpen = false,
    this.errorText,
    required this.isIcon,
    this.itemIcon,
    this.color,
  });

  @override
  State<CustomDropdown<T>> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
  T? _currentValue;

  @override
  void initState() {
    super.initState();
      _currentValue = widget.selectedItem;
  }
  @override
  void didUpdateWidget(covariant CustomDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedItem != widget.selectedItem) {
      setState(() {
        _currentValue = widget.selectedItem;
      });
    }
  }

  void _openDropdownDialog() async {
    final result = await showDialog<T>(
      context: context,
      builder: (context) {
        List<T> filteredItems = List.from(widget.items);
        // Visible window with lazy loading
        final ScrollController scrollController = ScrollController();
        const int pageSize = 20;
        int loadedCount = filteredItems.length < pageSize ? filteredItems.length : pageSize;
        List<T> visibleItems = filteredItems.take(loadedCount).toList();
        void tryLoadMore(StateSetter setStateDialog) {
          if (loadedCount >= filteredItems.length) return;
          final int next = (loadedCount + pageSize) > filteredItems.length ? filteredItems.length : (loadedCount + pageSize);
          setStateDialog(() {
            visibleItems.addAll(filteredItems.getRange(loadedCount, next));
            loadedCount = next;
          });
        }
        final searchCtrl = TextEditingController();
        return Dialog(
          backgroundColor: AppColor.backGroundColor1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 80, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400,maxHeight: 700),
            child: StatefulBuilder(
              builder: (context, setStateDialog) {
                // Attach scroll listener once
                if (!scrollController.hasListeners) {
                  scrollController.addListener(() {
                    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 40) {
                      tryLoadMore(setStateDialog);
                    }
                  });
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.hint,
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontSize: 14,
                          color: AppColor.textColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (widget.enableSearch)
                        TextField(
                          autofocus: true,
                          controller: searchCtrl,
                          decoration: InputDecoration(
                            hintText: "جستجو...",
                            prefixIcon: const Icon(Icons.search, size: 18),
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontSize: 13,
                            color: AppColor.textColor,
                          ),
                          onChanged: (value) {
                            setStateDialog(() {
                              filteredItems = widget.items
                                  .where((item) => widget.itemLabel(item)
                                  .toLowerCase()
                                  .contains(value.toLowerCase()))
                                  .toList();
                              // Reset pagination on new search
                              loadedCount = filteredItems.length < pageSize ? filteredItems.length : pageSize;
                              visibleItems = filteredItems.take(loadedCount).toList();
                            });
                          },
                        ),
                      if (widget.enableSearch) const SizedBox(height: 8),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 300),
                        child: ListView.separated(
                          shrinkWrap: true,
                          controller: scrollController,
                          itemCount: visibleItems.length,
                          separatorBuilder: (_, __) => const Divider(height: 1, thickness: 0.5),
                          itemBuilder: (context, index) {
                            final item = visibleItems[index];
                            return widget.isIcon
                                ? ListTile(
                              dense: true,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                              leading: widget.isIcon
                                  ? Image.network(
                                "${BaseUrl.baseUrl}Attachment/downloadResource?fileName=${widget.itemIcon!(item)}",
                                height: 25,
                                width: 25,
                              )
                                  : const SizedBox(),
                              title: Text(
                                widget.itemLabel(item),
                                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  fontSize: 13,
                                  color: AppColor.textColor,
                                ),
                              ),
                              onTap: () => Navigator.pop(context, item),
                            )
                                : ListTile(
                              dense: true,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                              title: Text(
                                widget.itemLabel(item),
                                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  fontSize: 13,
                                  color: AppColor.textColor,
                                ),
                              ),
                              onTap: () => Navigator.pop(context, item),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );

    if (result != null) {
      setState(() => _currentValue = result);
      widget.onChanged(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap:widget.isOpen==false ?  _openDropdownDialog : (){} ,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
            decoration: BoxDecoration(
              color: AppColor.textFieldColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: _currentValue != null
                    ? Color(0xff00d9b0)
                    : widget.errorText != null
                    ? Color(0xfffd3a3a)
                    : widget.color != null
                    ? widget.color!
                    : Colors.transparent,
              ),
            ),
            child: Row(
              children: [
                if (widget.isIcon && _currentValue != null) ...[
                  Image.network(
                    "${BaseUrl.baseUrl}Attachment/downloadResource?fileName=${widget.itemIcon!(_currentValue as T)}",
                    height: 23,
                    width: 23,
                  ),
                  const SizedBox(width: 10),
                ],
                Expanded(
                  child: Text(
                    _currentValue != null ? widget.itemLabel(_currentValue as T) : widget.hint,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontSize: 12,
                      color: AppColor.textColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // ✅ دکمه پاک کردن
                if (_currentValue != null && widget.isOpen==false)
                  GestureDetector(
                    onTap: () {
                      setState(() => _currentValue = null);
                      widget.onChanged(null);
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      child: Icon(Icons.clear, size: 20, color: Colors.grey),
                    ),
                  ),

                Icon(Icons.arrow_drop_down, color: AppColor.textColor),
              ],
            ),
          ),
        ),
        if (widget.errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 8),
            child: Text(
              widget.errorText!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
