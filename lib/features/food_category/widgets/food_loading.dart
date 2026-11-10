import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/theme/app_colors.dart';

class FoodLoading extends StatelessWidget {

  final weekDay;

  const FoodLoading({super.key, this.weekDay});
  @override
  Widget build(BuildContext context) {return Skeletonizer(
    effect: ShimmerEffect(
        baseColor: AppColors.white,
        highlightColor: AppColors.grey
    ),
    enabled: true,
    child: Container(
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grey),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(weekDay, style: const TextStyle(fontSize: 20, color: Colors.white)),
              const Text('تعديل'),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 15),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text('الغداء'),
                  SizedBox(height: 10),
                  Text('اسم المسؤول', style: TextStyle(fontSize: 18)),
                ],
              ),
              Column(
                children: [
                  Text('العشاء'),
                  SizedBox(height: 10),
                  Text('اسم المسؤول', style: TextStyle(fontSize: 18)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),
        ],
      ),
    ),
  );
  }
}