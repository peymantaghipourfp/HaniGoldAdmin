import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Example usage of the RoleCreationView
///
/// To use this view in your app, simply navigate to it:
/// ```dart
/// Get.to(() => const RoleCreationView());
/// ```
///
/// Or use it in a route:
/// ```dart
/// Navigator.push(
///   context,
///   MaterialPageRoute(builder: (context) => const RoleCreationView()),
/// );
/// ```

class RoleCreationExample extends StatelessWidget {
  const RoleCreationExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Role Management Example'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Role Creation System',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'This example demonstrates the role creation functionality with:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('• Basic information form (English & Persian names)'),
                  Text('• Dynamic permissions loading from API'),
                  Text('• Sub-permissions display when main permission is selected'),
                  Text('• Permission count tracking'),
                  Text('• Form validation'),
                  Text('• Dark theme UI matching the design'),
                ],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Get.toNamed('/roleCreation'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: const Text('Open Role Creation View'),
            ),
          ],
        ),
      ),
    );
  }
}
