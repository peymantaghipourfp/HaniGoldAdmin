import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/const/app_color.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:hanigold_admin/src/domain/product/model/item.model.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:responsive_framework/responsive_framework.dart';


/// Model for the output data when item selection changes
class ItemWeightSelectionResult {
  final List<SelectedItemData> selectedItems;
  final double totalWeight;

  ItemWeightSelectionResult({
    required this.selectedItems,
    required this.totalWeight,
  });

  Map<String, dynamic> toJson() => {
    'selectedItems': selectedItems.map((e) => e.toJson()).toList(),
    'totalWeight': totalWeight,
  };
}

/// Model for individual selected item data
class SelectedItemData {
  final int id;
  final String name;
  final int count;
  final double weight;
  final double totalItemWeight;

  SelectedItemData({
    required this.id,
    required this.name,
    required this.count,
    required this.weight,
    required this.totalItemWeight,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'count': count,
    'weight': weight,
    'totalItemWeight': totalItemWeight,
  };
}

/// A reusable dialog component for selecting items and calculating total weight.
///
/// This dialog displays a filtered list of items (IDs: 10, 12, 13, 15, 16, 19, 20)
/// with quantity counters. It calculates and displays the total weight based on
/// predefined weights for each item.
///
/// Usage:
/// ```dart
/// showDialog(
///   context: context,
///   builder: (context) => ItemWeightCalculatorDialog(
///     items: itemList,
///     onChange: (result) {
///     },
///     onConfirm: (result) {
///       // Handle confirmation
///     },
///   ),
/// );
/// ```
class ItemWeightCalculatorDialog extends StatefulWidget {
  /// List of items to display (will be filtered to allowed IDs)
  final List<ItemModel> items;

  /// Callback triggered when quantity changes
  final Function(ItemWeightSelectionResult)? onChange;

  /// Callback triggered when confirm button is pressed
  final Function(ItemWeightSelectionResult)? onConfirm;

  final ValueNotifier<double?> mesghalPriceNotifier;

  const ItemWeightCalculatorDialog({
    super.key,
    required this.items,
    this.onChange,
    this.onConfirm,
    required this.mesghalPriceNotifier,
  });

  @override
  State<ItemWeightCalculatorDialog> createState() => _ItemWeightCalculatorDialogState();
}

class _ItemWeightCalculatorDialogState extends State<ItemWeightCalculatorDialog> {
  // Allowed item IDs
  static const List<int> _allowedIds = [10, 12, 13, 15, 16, 19, 20];

  // Weight mapping for each item ID (in grams)
  static const Map<int, double> _itemWeights = {
    10: 9.76,
    12: 1.0,
    13: 1.0,
    15: 4.87,
    16: 2.44,
    19: 9.76,
    20: 2.44,
  };

  // State: Map of item ID to count
  final Map<int, int> _itemCounts = {};

  // Filtered items list
  late List<ItemModel> _filteredItems;

  // Error message if any
  String? _errorMessage;

  // Dialog offset for dragging
  Offset _dialogOffset = Offset.zero;

  @override
  void initState() {
    super.initState();
    _initializeItems();
  }

  void _initializeItems() {
    // Filter items to only show allowed IDs
    _filteredItems = widget.items
        .where((item) => item.id != null && _allowedIds.contains(item.id))
        .toList();

    // Check for errors
    if (widget.items.isEmpty) {
      _errorMessage = 'لیست آیتم‌ها خالی است';
    } else if (_filteredItems.isEmpty) {
      _errorMessage = 'هیچ آیتم مجازی یافت نشد';
    }

    // Initialize counts to 0
    for (var item in _filteredItems) {
      if (item.id != null) {
        _itemCounts[item.id!] = 0;
      }
    }
  }

  double get _totalWeight {
    double total = 0;
    _itemCounts.forEach((id, count) {
      if (_itemWeights.containsKey(id)) {
        total += count * _itemWeights[id]!;
      }
    });
    return total;
  }

  ItemWeightSelectionResult _buildResult() {
    final selectedItems = <SelectedItemData>[];

    for (var item in _filteredItems) {
      if (item.id != null) {
        final count = _itemCounts[item.id!] ?? 0;
        if (count > 0) {
          final weight = _itemWeights[item.id!] ?? 0;
          selectedItems.add(SelectedItemData(
            id: item.id!,
            name: item.name ?? '',
            count: count,
            weight: weight,
            totalItemWeight: count * weight,
          ));
        }
      }
    }

    return ItemWeightSelectionResult(
      selectedItems: selectedItems,
      totalWeight: _totalWeight,
    );
  }

  void _updateCount(int itemId, int delta) {
    setState(() {
      final currentCount = _itemCounts[itemId] ?? 0;
      final newCount = (currentCount + delta).clamp(0, 999);
      _itemCounts[itemId] = newCount;
    });

    // Trigger onChange callback
    widget.onChange?.call(_buildResult());
  }

  void _setCount(int itemId, int count) {
    setState(() {
      _itemCounts[itemId] = count.clamp(0, 999);
    });

    // Trigger onChange callback
    widget.onChange?.call(_buildResult());
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Transform.translate(
      offset: _dialogOffset,
      child: Dialog(
        backgroundColor: AppColor.backGroundColor2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColor.secondaryColor, width: 1.5),
        ),
        insetPadding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 40 : 16,
          vertical: 24,
        ),
        child: Container(
          width: isDesktop ? 500 : Get.width * 0.95,
          constraints: BoxConstraints(
            maxHeight: Get.height * 0.85,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(),
              if (_errorMessage != null)
                _buildErrorState()
              else
                Flexible(child: _buildContent()),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          _dialogOffset += details.delta;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: const BoxDecoration(
          color: AppColor.secondary50Color,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Row(
          children: [
            Icon(
              Icons.drag_indicator_rounded,
              color: AppColor.textColor.withAlpha(130),
              size: 20,
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColor.primaryColor.withAlpha(40),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.scale_rounded,
                color: AppColor.primaryColor,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'محاسبه وزن آیتم‌ها',
                    style: AppTextStyle.smallTitleText.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'تعداد هر آیتم را مشخص کنید',
                    style: AppTextStyle.labelText.copyWith(
                      color: AppColor.textColor.withAlpha(150),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => Get.back(),
              icon: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColor.accentColor.withAlpha(40),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.close_rounded,
                  color: AppColor.accentColor,
                  size: 18,
                ),
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColor.accentColor.withAlpha(25),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.error_outline_rounded,
              color: AppColor.accentColor,
              size: 48,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _errorMessage!,
            style: AppTextStyle.bodyText.copyWith(
              color: AppColor.textErrorColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Items list
          ..._filteredItems.map((item) => _buildItemRow(item)),

          const SizedBox(height: 20),

          // Summary section
          _buildSummarySection(),
        ],
      ),
    );
  }

  Widget _buildItemRow(ItemModel item) {
    final itemId = item.id!;
    final count = _itemCounts[itemId] ?? 0;
    final weight = _itemWeights[itemId] ?? 0;
    final itemTotalWeight = count * weight;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColor.secondaryColor.withAlpha(130),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: count > 0
              ? AppColor.primaryColor.withAlpha(130)
              : AppColor.secondaryColor,
          width: count > 0 ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          // Item info
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                    Text(
                      item.name ?? 'نامشخص',
                      style: AppTextStyle.bodyText.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColor.buttonColor.withAlpha(50),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${weight.toStringAsFixed(2)} گرم',
                        style: AppTextStyle.labelText.copyWith(
                          color: AppColor.textColorSecondary,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    if (count > 0) ...[
                      const SizedBox(width: 8),
                      Text(
                        '= ${itemTotalWeight.toStringAsFixed(2)}g',
                        style: AppTextStyle.labelText.copyWith(
                          color: AppColor.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // Counter
          _buildCounter(itemId, count),
        ],
      ),
    );
  }

  Widget _buildCounter(int itemId, int count) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.backGroundColor2,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColor.secondaryColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Decrement button
          _buildCounterButton(
            icon: Icons.remove_rounded,
            onPressed: count > 0 ? () => _updateCount(itemId, -1) : null,
            isLeft: true,
          ),

          // Count display / input
          GestureDetector(
            onTap: () => _showCountInputDialog(itemId, count),
            child: Container(
              width: 50,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                border: Border.symmetric(
                  vertical: BorderSide(
                    color: AppColor.secondaryColor.withAlpha(130),
                  ),
                ),
              ),
              child: Text(
                count.toString(),
                textAlign: TextAlign.center,
                style: AppTextStyle.bodyTextBold.copyWith(
                  fontSize: 15,
                  color: count > 0 ? AppColor.primaryColor : AppColor.textColor,
                ),
              ),
            ),
          ),

          // Increment button
          _buildCounterButton(
            icon: Icons.add_rounded,
            onPressed: () => _updateCount(itemId, 1),
            isLeft: false,
          ),
        ],
      ),
    );
  }

  Widget _buildCounterButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required bool isLeft,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.horizontal(
          left: isLeft ? const Radius.circular(10) : Radius.zero,
          right: !isLeft ? const Radius.circular(10) : Radius.zero,
        ),
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Icon(
            icon,
            size: 20,
            color: onPressed != null
                ? AppColor.textColor
                : AppColor.textColor.withAlpha(75),
          ),
        ),
      ),
    );
  }

  void _showCountInputDialog(int itemId, int currentCount) {
    final controller = TextEditingController(text: currentCount.toString());

    Get.dialog(
      AlertDialog(
        backgroundColor: AppColor.backGroundColor2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColor.secondaryColor),
        ),
        title: Text(
          'وارد کردن تعداد',
          style: AppTextStyle.smallTitleText,
          textAlign: TextAlign.center,
        ),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          autofocus: true,
          style: AppTextStyle.bodyTextBold,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColor.secondaryColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'انصراف',
              style: AppTextStyle.bodyText.copyWith(color: AppColor.accentColor),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final value = int.tryParse(controller.text) ?? 0;
              _setCount(itemId, value);
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'تایید',
              style: AppTextStyle.bodyText.copyWith(color: AppColor.backGroundColor2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection() {
    final totalItems = _itemCounts.values.fold(0, (sum, count) => sum + count);
    final hasSelection = totalItems > 0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: hasSelection
              ? [
            AppColor.primaryColor.withAlpha(40),
            AppColor.buttonColor.withAlpha(25),
          ]
              : [
            AppColor.secondaryColor.withAlpha(130),
            AppColor.secondaryColor.withAlpha(75),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: hasSelection
              ? AppColor.primaryColor.withAlpha(100)
              : AppColor.secondaryColor,
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.summarize_rounded,
                    color: hasSelection ? AppColor.primaryColor : AppColor.textColor.withAlpha(130),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'خلاصه انتخاب',
                    style: AppTextStyle.bodyText.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColor.backGroundColor2,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Text(
                      'مظنه: ',
                      style: AppTextStyle.bodyText.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    widget.mesghalPriceNotifier.value!=null ?
                    ValueListenableBuilder<double?>(
                      valueListenable: widget.mesghalPriceNotifier,
                      builder: (context, price, _) {
                        return Text(
                          price?.toStringAsFixed(0).seRagham() ?? '',
                          style: AppTextStyle.bodyText.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColor.primaryColor,
                          ),
                        );
                      },
                    ):
                    Text(
                      widget.items.first.baseMesghalPrice?.toStringAsFixed(0).seRagham() ?? "",
                      style: AppTextStyle.bodyText.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColor.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColor.backGroundColor2,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$totalItems آیتم',
                  style: AppTextStyle.labelText.copyWith(
                    color: AppColor.textColorSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(color: AppColor.secondaryColor, height: 1),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.scale_rounded,
                    color: hasSelection ? AppColor.primaryColor : AppColor.textColor.withAlpha(130),
                    size: 28,
                  ),
                  const SizedBox(width: 3),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'وزن کل',
                        style: AppTextStyle.labelText.copyWith(
                          color: AppColor.textColor.withAlpha(175),
                        ),
                      ),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: SelectableText(
                          '${_totalWeight.toStringAsFixed(2)} گرم',
                          key: ValueKey(_totalWeight),
                          style: AppTextStyle.largeTitleText.copyWith(
                            color: hasSelection ? AppColor.primaryColor : AppColor.textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.monetization_on,
                    color: hasSelection ? AppColor.dividerColor : AppColor.textColor.withAlpha(130),
                    size: 28,
                  ),
                  const SizedBox(width: 3),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'قیمت کل',
                        style: AppTextStyle.labelText.copyWith(
                          color: AppColor.textColor.withAlpha(175),
                        ),
                      ),
                      widget.mesghalPriceNotifier.value!=null ?
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: SelectableText(
                          '${((widget.mesghalPriceNotifier.value! / 4.3318) * _totalWeight).toStringAsFixed(0).seRagham()} ریال',
                          key: ValueKey(_totalWeight),
                          style: AppTextStyle.largeTitleText.copyWith(
                            color: hasSelection ? AppColor.dividerColor : AppColor.textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ) :
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: SelectableText(
                          '${((widget.items.first.baseMesghalPrice! / 4.3318) * _totalWeight).toStringAsFixed(0).seRagham()} ریال',
                          key: ValueKey(_totalWeight),
                          style: AppTextStyle.largeTitleText.copyWith(
                            color: hasSelection ? AppColor.dividerColor : AppColor.textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    final hasSelection = _itemCounts.values.any((count) => count > 0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.secondary50Color,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
        border: Border(
          top: BorderSide(color: AppColor.secondaryColor.withAlpha(130)),
        ),
      ),
      child: Row(
        children: [
          // Close button
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.close_rounded, size: 18),
              label: const Text('بستن'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColor.textColor,
                side: const BorderSide(color: AppColor.secondaryColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Confirm button
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: hasSelection || _errorMessage == null
                  ? () async {
                final result = _buildResult();

                // Copy total weight to clipboard
                final weightText = result.totalWeight.toStringAsFixed(2);
                await Clipboard.setData(ClipboardData(text: weightText));

                // Call the onConfirm callback
                widget.onConfirm?.call(result);
                Get.back();
                // Show snackbar confirmation
                Get.snackbar(
                  'کپی شد',
                  'وزن کل ($weightText گرم) در کلیپ‌بورد کپی شد',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: AppColor.primaryColor.withAlpha(200),
                  colorText: AppColor.backGroundColor2,
                  duration: const Duration(seconds: 2),
                  margin: const EdgeInsets.all(12),
                  borderRadius: 10,
                  icon: const Icon(
                    Icons.copy_rounded,
                    color: AppColor.backGroundColor2,
                  ),
                );
              }
                  : null,
              icon: const Icon(Icons.check_rounded, size: 20),
              label: const Text('تایید و کپی'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primaryColor,
                foregroundColor: AppColor.backGroundColor2,
                disabledBackgroundColor: AppColor.primaryColor.withAlpha(75),
                disabledForegroundColor: AppColor.textColor.withAlpha(130),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
                elevation: hasSelection ? 2 : 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Helper function to show the ItemWeightCalculatorDialog
///
/// Usage:
/// ```dart
/// showItemWeightCalculatorDialog(
///   context: context,
///   items: itemList,
///   onChange: (result) => print('Changed: ${result.toJson()}'),
///   onConfirm: (result) => print('Confirmed: ${result.toJson()}'),
/// );
/// ```
Future<void> showItemWeightCalculatorDialog({
  required BuildContext context,
  required List<ItemModel> items,
  Function(ItemWeightSelectionResult)? onChange,
  Function(ItemWeightSelectionResult)? onConfirm,
  required ValueNotifier<double?> mesghalPriceNotifier,
}) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => ItemWeightCalculatorDialog(
      items: items,
      onChange: onChange,
      onConfirm: onConfirm,
      mesghalPriceNotifier: mesghalPriceNotifier,
    ),
  );
}
