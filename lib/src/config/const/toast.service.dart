import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:hanigold_admin/src/config/const/app_color.dart';

class ToastService {
  static final ToastService _instance = ToastService._internal();
  factory ToastService() => _instance;
  ToastService._internal();

  void show(String message) {
    SmartDialog.showToast(
      "",
      alignment: Alignment.topCenter,
      maskColor: Color(0xff387ae7),
      animationType: SmartAnimationType.fade,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Color(0xff387ae7),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(65),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Text(
            message,
            style: const TextStyle(
              color: AppColor.textColor,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }

  void success(String message) {
    SmartDialog.showToast(
      message,
      alignment: Alignment.topCenter,
      maskColor: Colors.green.withAlpha(50),
    );
  }

  void error(String message) {
    SmartDialog.showToast(
      message,
      alignment: Alignment.topCenter,
      maskColor: Colors.red.withAlpha(50),
    );
  }

  void info(String message) {
    SmartDialog.showToast(
      message,
      alignment: Alignment.topCenter,
      maskColor: Colors.blue.withAlpha(50),
    );
  }
}
