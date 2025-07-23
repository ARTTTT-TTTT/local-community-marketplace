import 'package:flutter/material.dart';

class TermsProvider extends ChangeNotifier {
  bool _showAcceptButtons = false;

  bool get showAcceptButtons => _showAcceptButtons;

  // Terms content data
  final List<TermSection> _termsSections = [
    TermSection(
      title: 'การลงทะเบียน',
      content:
          'ผู้ใช้ต้องกรอกข้อมูลจริงและถูกต้อง เพื่อความปลอดภัยในการใช้งาน ข้อมูลส่วนบุคคลจะถูกเก็บรักษาอย่างปลอดภัยตามมาตรฐานสากล และจะไม่ถูกนำไปใช้ในทางที่ผิด',
    ),
    TermSection(
      title: 'ความเป็นส่วนตัว',
      content:
          'ข้อมูลส่วนบุคคลของผู้ใช้จะไม่ถูกเปิดเผยให้กับบุคคลที่สาม โดยไม่ได้รับความยินยอมจากผู้ใช้ เว้นแต่กรณีที่กฎหมายกำหนด หาก Android app เก็บรวบรวมข้อมูลการใช้งานเพื่อปรับปรุงบริการ',
    ),
    TermSection(
      title: 'การซื้อขาย',
      content:
          'ผู้ใช้รับผิดชอบต่อการทำรายการซื้อขายของตนเอง แอปพลิเคชันทำหน้าที่เป็นตัวกลางเท่านั้น การชำระเงินและการส่งสินค้าเป็นความรับผิดชอบของผู้ซื้อและผู้ขายโดยตรง',
    ),
    TermSection(
      title: 'ข้อจำกัดความรับผิดชอบ',
      content:
          'แอปพลิเคชันไม่รับผิดชอบต่อความเสียหายที่เกิดขึ้นจากการใช้งาน หรือปัญหาที่เกิดขึ้นจากการทำรายการระหว่างผู้ใช้ ผู้ใช้ควรตรวจสอบความน่าเชื่อถือของคู่ค้าก่อนทำรายการ',
    ),
    TermSection(
      title: 'การปรับปรุงเงื่อนไข',
      content:
          'บริษัทขอสงวนสิทธิ์ในการปรับปรุงแก้ไขข้อตกลงและเงื่อนไขการใช้งานได้ตลอดเวลา โดยจะแจ้งให้ผู้ใช้ทราบล่วงหน้าผ่านทางแอปพลิเคชัน การใช้งานต่อไปถือว่ายอมรับเงื่อนไขใหม่',
    ),
  ];

  List<TermSection> get termsSections => _termsSections;

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

class TermSection {
  final String title;
  final String content;

  TermSection({required this.title, required this.content});
}
