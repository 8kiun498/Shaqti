import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:shaqti/core/shared/custom_text.dart';
import 'package:shaqti/core/theme/app_colors.dart';
import 'package:shaqti/features/auth/cubit/auth_cubit.dart';
import 'package:shaqti/features/auth/cubit/auth_state.dart';
import 'package:shaqti/features/categories/whdgets/custom_category.dart';
import 'package:shaqti/features/food_category/pages/food_category_page.dart';
import 'package:shaqti/features/garbage_category/page/garbage_category_page.dart';
import 'package:shaqti/features/my_account/page/notification_page.dart';
import 'package:shaqti/features/rules/pages/rules_page.dart';
import 'package:shaqti/features/water_category/page/water_page.dart';

class CategoriesPage extends StatelessWidget {
  final String apretemtnCode;
  final bool isAdmin;
  CategoriesPage({
    super.key,
    required this.apretemtnCode,
    required this.isAdmin,
  });

  @override
  Widget build(BuildContext context) {
    final userName =
        (context.read<AuthCubit>().state as SuccessAuthState).userModel;
    final name = userName.name;
    final firstLetter = name.isNotEmpty
        ? String.fromCharCode(name.runes.first)
        : '؟';
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: AppColors.turquoise,
        automaticallyImplyLeading: false,
        leadingWidth: double.infinity,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: AppColors.white,
                child: CustomText(text: firstLetter, size: 26),
              ),
              SizedBox(width: 10),
              CustomText(
                text: "اهلا , ",
                size: 23,
                weight: FontWeight.bold,
                color: AppColors.white,
              ),
              CustomText(
                text: "$name 👋",
                size: 23,
                color: AppColors.white,
                weight: FontWeight.bold,
              ),
              Spacer(),
              IconButton(
                onPressed: () {
                  context.push("/notification");
                },
                icon: Icon(LucideIcons.bell, color: AppColors.white),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 10, left: 10, top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GridView.count(
              padding: EdgeInsets.only(top: 10),
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 18,
              mainAxisSpacing: 18,
              children: [
                GestureDetector(
                  onTap: () {
                    context.push("/food");
                  },
                  child: CustomCategory(
                    image: "assets/food.svg",
                    category: "جدول الطعام",
                  ),
                ),
                GestureDetector(
                  onTap: () {
                   context.push("/water");
                  },
                  child: CustomCategory(
                    image: "assets/water.svg",
                    category: "جدول الماء",
                  ),
                ),
                GestureDetector(
                  onTap: () {
                   context.push("/garbage");
                  },
                  child: CustomCategory(
                    image: "assets/garbage.svg",
                    category: "جدول القمامة",
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    context.push("/rules/$apretemtnCode");
                  },
                  child: CustomCategory(
                    image: "assets/rules.svg",
                    category: "قوانين الشقة",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
