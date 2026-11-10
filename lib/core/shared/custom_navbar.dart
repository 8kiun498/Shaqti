
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shaqti/core/shared/custom_text.dart';
import 'package:shaqti/core/theme/app_colors.dart';

class CustomNavBar extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;

  const CustomNavBar({super.key, required this.label, required this.icon, required this.isSelected, });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 5,top: 10, left: 5),
      child: Container(
        
        height: 50,
        width: 120,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.turquoise : Colors.transparent,
          borderRadius: BorderRadius.circular(22),
        ),
        child: isSelected ? Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 5)),
            Icon(icon, color: AppColors.white,),
           SizedBox(width: 8,)
            ,CustomText(text: label, size: 12, color: AppColors.white),
          ],
        )
        : Icon(icon,color: AppColors.turquoise,),
      ),
    );
  }
}
