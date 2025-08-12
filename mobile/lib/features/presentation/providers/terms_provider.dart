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
      builder: (context) => SafeArea(
        minimum: const EdgeInsets.only(bottom: 40, left: 20, right: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              'การไม่ยอมรับหมายถึงต้องออกจากแอปพลิเคชั่น',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'กรุณาพิจารณาการยอมรับเงื่อนไขอีกครั้ง',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: FilledButton(
                onPressed: () => Navigator.pop(context),
                child: Text('ยกเลิก'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
