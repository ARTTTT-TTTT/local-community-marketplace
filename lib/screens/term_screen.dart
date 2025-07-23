import 'package:flutter/material.dart';

import 'package:community_marketplace/screens/onboarding_screen.dart';

class TermsScreen extends StatefulWidget {
  const TermsScreen({super.key});

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  bool _showAcceptButtons = false;

  // ใช้ NotificationListener เพื่อตรวจจับการเลื่อนถึงล่าง
  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      final metrics = notification.metrics;
      if (metrics.pixels >= metrics.maxScrollExtent - 1.0 &&
          !_showAcceptButtons) {
        setState(() {
          _showAcceptButtons = true;
        });
      }
    }
    return false;
  }

  void _showExitDialog() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ข้อตกลงและเงื่อนไข')),
      body: Stack(
        children: [
          // ใช้ NotificationListener ตรวจจับการเลื่อน
          NotificationListener<ScrollNotification>(
            onNotification: _handleScrollNotification,
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(20),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _buildTermSection(
                        'การลงทะเบียน',
                        'ผู้ใช้ต้องกรอกข้อมูลจริง...',
                      ),
                      _buildTermSection(
                        'ความเป็นส่วนตัว',
                        'ข้อมูลจะไม่ถูกเปิดเผยให้บุคคลที่สาม...',
                      ),
                      _buildTermSection(
                        'การซื้อขาย',
                        'ผู้ใช้รับผิดชอบต่อการทำรายการเอง...',
                      ),
                      _buildTermSection(
                        'ข้อจำกัดความรับผิดชอบ',
                        'แอปไม่รับผิดชอบหากเกิดปัญหาการซื้อขาย...',
                      ),
                      const SizedBox(
                        height: 80,
                      ), // พื้นที่ท้ายเพื่อให้เลื่อนถึงได้
                    ]),
                  ),
                ),
              ],
            ),
          ),

          // ข้อความ "เลื่อนลง" (ถ้ายังไม่ถึงล่าง)
          if (!_showAcceptButtons)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.only(bottom: 40),
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 20,
                ),
                color: Colors.white.withValues(alpha: 0.9),
                child: const Text(
                  'เลื่อนลงไปล่างสุดเพื่อยอมรับ',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
            ),

          // ปุ่ม ยอมรับ / ไม่ยอมรับ (เมื่อเลื่อนถึงล่างแล้ว)
          if (_showAcceptButtons)
            Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                minimum: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _showExitDialog,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                        child: const Text('ไม่ยอมรับ'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const OnboardingScreen(),
                            ),
                          );
                        },
                        child: const Text('ยอมรับ'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTermSection(String title, String content) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(
              content,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
