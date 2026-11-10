import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:shaqti/core/shared/custom_text.dart';
import 'package:shaqti/core/theme/app_colors.dart';

class CustomTxtbuttom extends StatelessWidget {
  final String text;
  final bool isLoading;

  const CustomTxtbuttom({super.key, required this.text, required this.isLoading});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.turquoise,
      ),
      child: Center(

        child: isLoading ?   CircularProgressIndicator(color: AppColors.white,) :  CustomText(text: text, size: 18, color: AppColors.white),

      ),
    );
  }
}
