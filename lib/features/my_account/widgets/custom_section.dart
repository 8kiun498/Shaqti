import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:shaqti/core/shared/custom_text.dart';
import 'package:shaqti/core/theme/app_colors.dart';

class CustomSection extends StatelessWidget {
  final IconData icon;
  final String label;

  const CustomSection({super.key, required this.icon, required this.label});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(left: 10),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.turquoise.withAlpha(30),
          ),
          child: Icon(icon, color: AppColors.turquoise, size: 25),
        ),
        SizedBox(width: 10),
        CustomText(text: label, size: 16, color: AppColors.turquoise),
      ],
    );
  }
}
