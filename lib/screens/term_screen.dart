import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:community_marketplace/screens/onboarding_screen.dart';
import 'package:community_marketplace/providers/terms_provider.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TermsProvider(),
      child: const _TermsScreenContent(),
    );
  }
}

class _TermsScreenContent extends StatelessWidget {
  const _TermsScreenContent();

  @override
  Widget build(BuildContext context) {
    return Consumer<TermsProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(title: const Text('ข้อตกลงและเงื่อนไข')),
          body: Stack(
            children: [
              // ใช้ NotificationListener ตรวจจับการเลื่อน
              NotificationListener<ScrollNotification>(
                onNotification: provider.handleScrollNotification,
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.all(20),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          ...provider.termsSections.map(
                            (section) => _buildTermSection(
                              section.title,
                              section.content,
                            ),
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
              if (!provider.showAcceptButtons)
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
              if (provider.showAcceptButtons)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SafeArea(
                    minimum: const EdgeInsets.only(
                      bottom: 20,
                      left: 20,
                      right: 20,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => provider.showExitDialog(context),
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
      },
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
