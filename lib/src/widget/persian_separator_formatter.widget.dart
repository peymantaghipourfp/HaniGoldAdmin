import 'package:flutter/services.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class PersianSeparatorFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // حذف کاراکترهای غیر عددی
    String numericOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // اگر مقدار خالی شد، مقدار اولیه را برگردانیم
    if (numericOnly.isEmpty) {
      return TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    // فرمت عدد با جداکننده هزارگان و تبدیل به فارسی
    String formatted = numericOnly.seRagham(separator: ',').toPersianDigit();

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
