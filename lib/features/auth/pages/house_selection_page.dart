import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shaqti/core/shared/custom_text.dart';
import 'package:shaqti/core/theme/app_colors.dart';
import 'package:shaqti/features/auth/pages/admin_signup_page.dart';
import 'package:shaqti/features/auth/pages/mamber_signup_page.dart';

class HouseSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 90),
                CustomText(
                  text: "مرحبا بك في تطبيق شقتي",
                  size: 22,
                  weight: FontWeight.bold,
                  color: AppColors.turquoise,
                ),
                SizedBox(height: 20),
                CustomText(
                  text: "اختر نوع حسابك",
                  size: 14,
                  color: Colors.grey,
                ),
                SizedBox(height: 30),
                InkWell(
                  onTap: () {
                    context.push("/admin_signup");
                  },
                  child: Container(
                    width: double.infinity,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white70,
                      border: Border.all(color: AppColors.turquoise),
                      boxShadow: [BoxShadow(color: Color(0x2600897B))],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: "انشاء شقة",
                                size: 26,
                                color: AppColors.turquoise,
                                weight: FontWeight.bold,
                              ),
                              CustomText(
                                text:
                                    "قم بأنشاء شقة واحصل على رمز \n الانضمام الخاص بها",
                                size: 13,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                          Spacer(),
                          Icon(
                            Icons.arrow_forward_ios_sharp,
                            color: AppColors.turquoise,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                InkWell(
                  onTap: () {
context.push("/mamber_signup");
                  },
                  child: Container(
                    width: double.infinity,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white70,
                      border: Border.all(color: AppColors.turquoise),
                      boxShadow: [BoxShadow(color: Color(0x2600897B))],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: "الانضمام الى شقة",
                                size: 26,
                                color: AppColors.turquoise,
                                weight: FontWeight.bold,
                                textAlign: TextAlign.center,
                              ),
                              CustomText(
                                text:
                                    "يمكنك الانضمام الى شقة من خلال رمز الشقة",
                                size: 12,
                                color: Colors.grey,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          Spacer(),
                          Icon(
                            Icons.arrow_forward_ios_sharp,
                            color: AppColors.turquoise,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
