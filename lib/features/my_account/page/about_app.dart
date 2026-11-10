import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shaqti/core/theme/app_colors.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.turquoise,
        foregroundColor: AppColors.white,
        centerTitle: true,
        title: const Text('عن التطبيق'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 32),
          CircleAvatar(
            radius: 48,
            backgroundColor: AppColors.turquoise.withAlpha(30),
            child: const Icon(
              Icons.apartment_rounded,
              size: 48,
              color: AppColors.turquoise,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'شقتي',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'تطبيق يساعد سكان الشقة على تنظيم المهام والجداول ومشاركة المسؤوليات.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 28),
           ListTile(
            leading: SvgPicture.asset( "assets/login/login_logo.svg"),
            title: Text('الإصدار'),
            subtitle: Text('1.0.0'),
          ),
        ],
      ),
    );
  }
}