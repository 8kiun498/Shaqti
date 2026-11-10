
import 'package:flutter/material.dart';
import 'package:shaqti/core/shared/custom_text.dart';
import 'package:shaqti/core/theme/app_colors.dart';

class CustomContiener extends StatelessWidget {
  final String title;

  const CustomContiener({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColors.turquoise.withAlpha(30),
        border: Border.all(color: AppColors.turquoise)
      ),
      child: Row(
        children: [
          CustomText(text: title, size: 18, color: AppColors.turquoise),
          Spacer(),
          Icon(Icons.arrow_forward_ios, color: AppColors.turquoise),
        ],
      ),
    );
  }
}
