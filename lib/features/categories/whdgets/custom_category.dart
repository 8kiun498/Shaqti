import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shaqti/core/theme/app_colors.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CustomCategory extends StatelessWidget  {
  final String image;
  final String category;

  const CustomCategory({super.key, required this.image, required this.category});
  @override
  Widget build(BuildContext context) {
   return Container(
     decoration: BoxDecoration(
       color: Colors.grey.shade100,
       borderRadius: BorderRadius.circular(16),
       border: Border.all(color: AppColors.turquoise),
     ),
     child: Column(
       mainAxisAlignment: MainAxisAlignment.center,
       children: [
         Skeleton.replace(
          replacement: Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              height: 60,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: AppColors.grey.withAlpha(30)),
            ),
          ),
           child: SvgPicture.asset(
             image,
             fit: BoxFit.contain,
             height: 60,
           ),
         ),
         SizedBox(height: 12),
         Text(
           category,
           style: TextStyle(
             fontSize: 14,
             fontWeight: FontWeight.bold,
             color: Colors.black,
           ),
         ),
       ],
     ),
   );
  }
}