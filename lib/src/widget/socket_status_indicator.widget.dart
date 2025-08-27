import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../config/const/app_color.dart';
import '../config/const/socket.service.dart';

class SocketStatusIndicator extends StatelessWidget {
  const SocketStatusIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final socketService = Get.find<SocketService>();

    return Obx(() {
      final isConnected = socketService.isConnected;
      final status = socketService.connectionStatus;

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isConnected ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isConnected ? Colors.green : Colors.red,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: isConnected ? Colors.green : Colors.red,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              isConnected ? 'متصل' : 'قطع',
              style: TextStyle(
                color: isConnected ? Colors.green : Colors.red,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    });
  }
}
