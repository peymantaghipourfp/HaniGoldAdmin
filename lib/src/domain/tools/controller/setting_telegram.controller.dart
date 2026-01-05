import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/repository/setting_telegram.repository.dart';

class SettingTelegramController extends GetxController {
  final SettingTelegramRepository _repository = SettingTelegramRepository();

  // Connection status
  final RxBool isConnected = false.obs;
  final RxBool isStatusLoading = true.obs;
  final RxString statusMessage = ''.obs;
  final RxBool isStatusError = false.obs;

  // Send code states
  final RxBool isSendingCode = false.obs;
  final RxString sendCodeMessage = ''.obs;
  final RxBool isSendCodeError = false.obs;
  final RxBool isSendCodeSuccess = false.obs;

  // Submit code states
  final TextEditingController codeController = TextEditingController();
  final RxBool isSubmittingCode = false.obs;
  final RxString submitCodeMessage = ''.obs;
  final RxBool isSubmitCodeError = false.obs;
  final RxBool isSubmitCodeSuccess = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTelegramStatus();
  }

  @override
  void onClose() {
    codeController.dispose();
    super.onClose();
  }

  /// Fetches the current Telegram connection status.
  /// Repository returns a single boolean: true = connected, false = not connected or error.
  Future<void> fetchTelegramStatus() async {
    isStatusLoading.value = true;
    isStatusError.value = false;
    statusMessage.value = '';

    // Get status directly as boolean from repository
    final bool status = await _repository.getStatusTelegram();
    print('Telegram status (bool): $status');

    isConnected.value = status;
    statusMessage.value = status ? 'تلگرام متصل است' : 'تلگرام متصل نیست';
    isStatusLoading.value = false;
  }

  /// Sends verification code to user's Telegram.
  /// Repository returns a string: success message or error message.
  Future<void> sendCode() async {
    isSendingCode.value = true;
    isSendCodeError.value = false;
    isSendCodeSuccess.value = false;
    sendCodeMessage.value = '';

    // Get result directly as string from repository
    final String result = await _repository.startSendCodeTelegram();
    print('Send code result (string): $result');

    // Determine if it's an error based on common error indicators
    final bool isError = _isErrorMessage(result);

    if (isError) {
      isSendCodeError.value = true;
      isSendCodeSuccess.value = false;
    } else {
      isSendCodeSuccess.value = true;
      isSendCodeError.value = false;
      // Clear the code input for new entry
      codeController.clear();
    }

    sendCodeMessage.value = result;
    isSendingCode.value = false;
  }

  /// Submits the verification code.
  /// Repository returns a string: success message or error message.
  Future<void> submitCode() async {
    final codeText = codeController.text.trim();

    // Validate: code must not be empty
    if (codeText.isEmpty) {
      isSubmitCodeError.value = true;
      submitCodeMessage.value = 'لطفاً کد را وارد کنید';
      return;
    }

    // Validate: code must be numeric
    final code = int.tryParse(codeText);
    if (code == null) {
      isSubmitCodeError.value = true;
      submitCodeMessage.value = 'کد باید عددی باشد';
      return;
    }

    // Validate: code must be positive
    if (code <= 0) {
      isSubmitCodeError.value = true;
      submitCodeMessage.value = 'کد نامعتبر است';
      return;
    }

    isSubmittingCode.value = true;
    isSubmitCodeError.value = false;
    isSubmitCodeSuccess.value = false;
    submitCodeMessage.value = '';

    // Get result directly as string from repository
    final String result = await _repository.getSubmitTelegram(code);
    print('Submit code result (string): $result');

    // Determine if it's an error based on common error indicators
    final bool isError = _isErrorMessage(result);

    if (isError) {
      isSubmitCodeError.value = true;
      isSubmitCodeSuccess.value = false;
    } else {
      isSubmitCodeSuccess.value = true;
      isSubmitCodeError.value = false;
      // Refresh connection status after successful verification
      await fetchTelegramStatus();
      // Clear the code input
      codeController.clear();
    }

    submitCodeMessage.value = result;
    isSubmittingCode.value = false;
  }

  /// Helper method to detect if a message indicates an error.
  /// Checks for common Persian and English error keywords.
  bool _isErrorMessage(String message) {
    final lowerMessage = message.toLowerCase();
    return lowerMessage.contains('خطا') ||
        lowerMessage.contains('error') ||
        lowerMessage.contains('fail') ||
        lowerMessage.contains('نامعتبر') ||
        lowerMessage.contains('invalid') ||
        lowerMessage.contains('مشکل');
  }

  /// Clears all messages
  void clearMessages() {
    statusMessage.value = '';
    sendCodeMessage.value = '';
    submitCodeMessage.value = '';
    isSendCodeError.value = false;
    isSendCodeSuccess.value = false;
    isSubmitCodeError.value = false;
    isSubmitCodeSuccess.value = false;
  }
}
