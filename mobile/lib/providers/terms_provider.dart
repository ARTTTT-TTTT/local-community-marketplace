import 'package:flutter/material.dart';

class TermsProvider extends ChangeNotifier {
  bool _showAcceptButtons = false;

  bool get showAcceptButtons => _showAcceptButtons;

  // Handle scroll notification to show accept buttons
  bool handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      final metrics = notification.metrics;
      if (metrics.pixels >= metrics.maxScrollExtent - 1.0 &&
          !_showAcceptButtons) {
        _showAcceptButtons = true;
        notifyListeners();
      }
    }
    return false;
  }

  void showExitDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'การไม่ยอมรับหมายถึงต้องออกจากแอปพลิเคชั่น',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.of(context).popUntil((route) => route.isFirst),
              child: const Text(
                'ออกจากระบบ',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void acceptTerms(BuildContext context) {
    // This will be handled in the UI file with proper navigation
  }
}
