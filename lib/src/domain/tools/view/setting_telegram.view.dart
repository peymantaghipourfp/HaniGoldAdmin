import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/const/app_color.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:hanigold_admin/src/domain/tools/controller/setting_telegram.controller.dart';
import '../../../widget/app_drawer.widget.dart';
import '../../../widget/custom_appbar1.widget.dart';
import '../../chat/widget/chat_dialog.widget.dart';

class SettingTelegramView extends StatelessWidget {
  const SettingTelegramView({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingTelegramController controller =
    Get.find<SettingTelegramController>();
    final isMobile = Get.width < 600;

    return Scaffold(
      appBar: CustomAppbar1(
        title: 'تنظیمات تلگرام',
        onBackTap: () => Get.toNamed('/home'),
      ),
      drawer: const AppDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bgHaniGold.png'),
            fit: BoxFit.contain,
            opacity: 0.06,
          ),
        ),
        child: Center(
          child: Container(
            width: isMobile ? Get.width * 0.95 : Get.width * 0.55,
            padding: EdgeInsets.all(isMobile ? 12.0 : 24.0),
            decoration: BoxDecoration(
              color: AppColor.secondaryColor.withAlpha(200),
              borderRadius: BorderRadius.circular(16),
            ),
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(isMobile ? 16.0 : 40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Section 1: Connection Status
                    _buildConnectionStatusSection(controller),
                    const SizedBox(height: 32),
                    const Divider(color: AppColor.dividerColor, thickness: 1),
                    const SizedBox(height: 32),

                    // Section 2: Send Code
                    _buildSendCodeSection(controller),
                    const SizedBox(height: 32),
                    const Divider(color: AppColor.dividerColor, thickness: 1),
                    const SizedBox(height: 32),

                    // Section 3: Submit Code
                    _buildSubmitCodeSection(controller),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.dialog(const ChatDialog());
        },
        backgroundColor: AppColor.primaryColor,
        child: const Icon(
          Icons.chat,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  /// Section 1: Connection Status Display
  Widget _buildConnectionStatusSection(SettingTelegramController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.telegram, color: Colors.lightBlueAccent, size: 28),
            const SizedBox(width: 12),
            Text(
              'وضعیت اتصال تلگرام',
              style: AppTextStyle.largeTitleText,
            ),
          ],
        ),
        const SizedBox(height: 20),
        Obx(() {
          if (controller.isStatusLoading.value) {
            return Center(
              child: Column(
                children: [
                  const SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: AppColor.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'در حال بررسی وضعیت اتصال...',
                    style: AppTextStyle.bodyText,
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Container(
                padding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                decoration: BoxDecoration(
                  color: controller.isConnected.value
                      ? AppColor.successColor.withAlpha(40)
                      : AppColor.errorColor.withAlpha(40),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: controller.isConnected.value
                        ? AppColor.successColor
                        : AppColor.errorColor,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      controller.isConnected.value
                          ? Icons.check_circle
                          : Icons.cancel,
                      color: controller.isConnected.value
                          ? AppColor.successColor
                          : AppColor.errorColor,
                      size: 32,
                    ),
                    const SizedBox(width: 16),
                    Text(
                      controller.isConnected.value
                          ? 'تلگرام متصل است'
                          : 'تلگرام متصل نیست',
                      style: AppTextStyle.mediumBodyTextBold.copyWith(
                        color: controller.isConnected.value
                            ? AppColor.successColor
                            : AppColor.errorColor,
                      ),
                    ),
                  ],
                ),
              ),
              // Status message (error message)
              if (controller.isStatusError.value &&
                  controller.statusMessage.value.isNotEmpty) ...[
                const SizedBox(height: 12),
                _buildMessageWidget(
                  message: controller.statusMessage.value,
                  isError: true,
                ),
              ],
              const SizedBox(height: 16),
              // Refresh button
              TextButton.icon(
                onPressed: controller.isStatusLoading.value
                    ? null
                    : () => controller.fetchTelegramStatus(),
                icon: const Icon(Icons.refresh, color: AppColor.buttonColor),
                label: Text(
                  'بروزرسانی وضعیت',
                  style:
                  AppTextStyle.bodyText.copyWith(color: AppColor.buttonColor),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }

  /// Section 2: Send Code Button
  Widget _buildSendCodeSection(SettingTelegramController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.send, color: AppColor.primaryColor, size: 24),
            const SizedBox(width: 12),
            Text(
              'ارسال کد تأیید',
              style: AppTextStyle.largeTitleText,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'برای اتصال به تلگرام، ابتدا روی دکمه زیر کلیک کنید تا کد تأیید به تلگرام شما ارسال شود.',
          style: AppTextStyle.bodyText.copyWith(
            color: AppColor.textColorSecondary,
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: Obx(() {
            return ElevatedButton.icon(
              onPressed:
              controller.isSendingCode.value ? null : () => controller.sendCode(),
              style: ButtonStyle(
                padding: WidgetStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                elevation: WidgetStateProperty.all(5),
                backgroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.disabled)) {
                    return AppColor.buttonColor.withAlpha(128);
                  }
                  return AppColor.buttonColor;
                }),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              icon: controller.isSendingCode.value
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
                  : const Icon(Icons.send, color: Colors.white),
              label: Text(
                controller.isSendingCode.value ? 'در حال ارسال...' : 'ارسال کد تأیید',
                style: AppTextStyle.bodyText.copyWith(color: Colors.white),
              ),
            );
          }),
        ),
        // Send code message
        Obx(() {
          if (controller.sendCodeMessage.value.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.only(top: 16),
              child: _buildMessageWidget(
                message: controller.sendCodeMessage.value,
                isError: controller.isSendCodeError.value,
                isSuccess: controller.isSendCodeSuccess.value,
              ),
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }

  /// Section 3: Submit Code
  Widget _buildSubmitCodeSection(SettingTelegramController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.verified_user, color: AppColor.primaryColor, size: 24),
            const SizedBox(width: 12),
            Text(
              'تأیید کد',
              style: AppTextStyle.largeTitleText,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'کد دریافتی از تلگرام را در کادر زیر وارد کرده و روی دکمه تأیید کلیک کنید.',
          style: AppTextStyle.bodyText.copyWith(
            color: AppColor.textColorSecondary,
          ),
        ),
        const SizedBox(height: 20),
        // Code input field
        TextFormField(
          controller: controller.codeController,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: AppTextStyle.largeBodyTextBold,
          decoration: InputDecoration(
            labelText: 'کد تأیید',
            labelStyle: AppTextStyle.labelText,
            hintText: 'کد را وارد کنید',
            hintStyle: AppTextStyle.bodyText.copyWith(
              color: AppColor.textColorSecondary.withAlpha(128),
            ),
            filled: true,
            fillColor: AppColor.backGroundColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColor.primaryColor,
                width: 2,
              ),
            ),
            prefixIcon: const Icon(
              Icons.lock_outline,
              color: AppColor.iconViewColor,
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Submit button
        Center(
          child: Obx(() {
            return ElevatedButton.icon(
              onPressed: controller.isSubmittingCode.value
                  ? null
                  : () => controller.submitCode(),
              style: ButtonStyle(
                padding: WidgetStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                elevation: WidgetStateProperty.all(5),
                backgroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.disabled)) {
                    return AppColor.primaryColor.withAlpha(128);
                  }
                  return AppColor.primaryColor;
                }),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              icon: controller.isSubmittingCode.value
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
                  : const Icon(Icons.check, color: Colors.white),
              label: Text(
                controller.isSubmittingCode.value ? 'در حال تأیید...' : 'تأیید کد',
                style: AppTextStyle.bodyText.copyWith(color: Colors.white),
              ),
            );
          }),
        ),
        // Submit code message
        Obx(() {
          if (controller.submitCodeMessage.value.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.only(top: 16),
              child: _buildMessageWidget(
                message: controller.submitCodeMessage.value,
                isError: controller.isSubmitCodeError.value,
                isSuccess: controller.isSubmitCodeSuccess.value,
              ),
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }

  /// Helper widget to display success/error messages
  Widget _buildMessageWidget({
    required String message,
    bool isError = false,
    bool isSuccess = false,
  }) {
    Color backgroundColor;
    Color borderColor;
    Color textColor;
    IconData icon;

    if (isError) {
      backgroundColor = AppColor.errorColor.withAlpha(30);
      borderColor = AppColor.errorColor;
      textColor = AppColor.textAccentColor;
      icon = Icons.error_outline;
    } else if (isSuccess) {
      backgroundColor = AppColor.successColor.withAlpha(30);
      borderColor = AppColor.successColor;
      textColor = AppColor.textPrimaryColor;
      icon = Icons.check_circle_outline;
    } else {
      backgroundColor = AppColor.buttonColor.withAlpha(30);
      borderColor = AppColor.buttonColor;
      textColor = AppColor.textColor;
      icon = Icons.info_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, color: borderColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: AppTextStyle.bodyText.copyWith(color: textColor),
            ),
          ),
        ],
      ),
    );
  }
}

