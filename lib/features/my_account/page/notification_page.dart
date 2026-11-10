import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shaqti/core/shared/custom_text.dart';
import 'package:shaqti/core/theme/app_colors.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(text: "الاشعارات", size: 22, color: AppColors.white),backgroundColor: AppColors.turquoise,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.white),
      ),
      backgroundColor: AppColors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset("assets/empty.svg", height: 100),
            const SizedBox(height: 10),
            CustomText(
              text: " لا توجد اشعارات بعد ",
              size: 18,
              color: AppColors.black,
            ),
          ],
        ),
      ),
    );
  }
}
