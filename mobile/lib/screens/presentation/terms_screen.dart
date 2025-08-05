import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:community_marketplace/screens/presentation/onboarding_screen.dart';
import 'package:community_marketplace/providers/terms_provider.dart';

class TermSection {
  final String title;
  final String content;

  TermSection({required this.title, required this.content});
}

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TermsProvider(),
      child: _TermsScreenContent(),
    );
  }
}

class _TermsScreenContent extends StatelessWidget {
  // Terms content data
  final List<TermSection> termsSections = [
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

  @override
  Widget build(BuildContext context) {
    return Consumer<TermsProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () {
                Future.delayed(const Duration(milliseconds: 100), () {
                  SystemNavigator.pop();
                });
              },
            ),
            title: const Text('ข้อตกลงและเงื่อนไข'),
          ),
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
                          ...termsSections.map(
                            (section) => _buildTermSection(
                              section.title,
                              section.content,
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
              _buildNavbarSection(context),
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

  Widget _buildNavbarSection(BuildContext context) {
    final provider = Provider.of<TermsProvider>(context);
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        height: 160,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(0, 255, 255, 255), // โปร่งใส
              Colors.white, // ขาวเต็ม
            ],
            stops: [0.0, 0.1], // 0-10% ใส, 10-100% ขาวเต็ม
          ),
        ),
        child: SafeArea(
          minimum: const EdgeInsets.only(
            bottom: 20,
            left: 20,
            right: 20,
            top: 20,
          ),
          // if (!provider.showAcceptButtons) {
          // child: OutlinedButton(
          //     onPressed: () => provider.showExitDialog(context),
          //     style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
          //     child: const Text('ไม่ยอมรับ'),
          //   )}
          //else {}
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => provider.showExitDialog(context),
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
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
    );
  }
}


    //   return Align(
    //     alignment: Alignment.bottomCenter,
    //     child: Container(
    //       // margin: const EdgeInsets.only(bottom: 40),
    //       padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
    //       color: Colors.white.withValues(alpha: 0.9),
    //       child: const Text(
    //         'เลื่อนลงไปล่างสุดเพื่อยอมรับ',
    //         style: TextStyle(color: Colors.grey, fontSize: 14),
    //       ),
    //     ),
    //   );
    // } else {