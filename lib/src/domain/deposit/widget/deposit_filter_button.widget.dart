import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../controller/deposit.controller.dart';
import 'deposit_filter_dialog.widget.dart';

class DepositFilterButton extends StatelessWidget {
  final DepositController depositController;
  final bool isDesktop;

  const DepositFilterButton({
    super.key,
    required this.depositController,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    return isDesktop ?
    OutlinedButton.icon(
        onPressed: () => _showFilterDialog(context),
        label: Text(
          'فیلتر',
          style: AppTextStyle.labelText.copyWith(
            fontSize: isDesktop ? 12 : 10,
            color: _getFilterTextColor(),
          ),
        ),
      icon: SvgPicture.asset(
        'assets/svg/filter3.svg',
        height: 17,
        colorFilter: ColorFilter.mode(
          _getFilterIconColor(),
          BlendMode.srcIn,
        ),
      ),
    ):
    /*ElevatedButton(
      style: ButtonStyle(
        padding: WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 23, vertical: 19),
        ),
        backgroundColor: WidgetStatePropertyAll(
          AppColor.appBarColor.withOpacity(0.5),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            side: BorderSide(color: AppColor.textColor),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
      onPressed: () => _showFilterDialog(context),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/svg/filter3.svg',
            height: 17,
            colorFilter: ColorFilter.mode(
              _getFilterIconColor(),
              BlendMode.srcIn,
            ),
          ),
          SizedBox(width: 10),
          Text(
            'فیلتر',
            style: AppTextStyle.labelText.copyWith(
              fontSize: isDesktop ? 12 : 10,
              color: _getFilterTextColor(),
            ),
          ),
        ],
      ),
    ) :*/
    GetBuilder<DepositController>(
        builder: (controller) {
      return GestureDetector(
        onTap: () => _showFilterDialog(context),
        child: SvgPicture.asset(
          'assets/svg/filter3.svg',
          height: 26,
          colorFilter:
          ColorFilter.mode(
            _getFilterIconColorMobile(),
            BlendMode.srcIn,
          ),
        ),
      );
    });
  }

  Color _getFilterIconColor() {
    return _hasActiveFilters() ? AppColor.accentColor : AppColor.textColor;
  }

  Color _getFilterIconColorMobile() {
    return _hasActiveFilters() ? AppColor.filterColor : AppColor.textColor;
  }

  Color _getFilterTextColor() {
    return _hasActiveFilters() ? AppColor.accentColor : AppColor.textColor;
  }

  bool _hasActiveFilters() {
    return depositController.nameDepositFilterController.text.isNotEmpty ||
        depositController.nameRequestFilterController.text.isNotEmpty ||
        depositController.amountFilterController.text.isNotEmpty ||
        depositController.trackingNumberFilterController.text.isNotEmpty ||
        depositController.dateStartController.text.isNotEmpty ||
        depositController.dateEndController.text.isNotEmpty ||
        depositController.showOnlyExtraDeposits.value;
  }

  void _showFilterDialog(BuildContext context) {
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
        return DepositFilterDialog(
          depositController: depositController,
          isDesktop: isDesktop,
        );
      },
    );
  }
}
