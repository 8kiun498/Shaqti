import 'dart:io';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import 'package:pro_dialog/pro_dialog.dart';
import 'package:shaqti/core/shared/custom_text.dart';
import 'package:shaqti/core/theme/app_colors.dart';
import 'package:shaqti/features/auth/cubit/auth_cubit.dart';
import 'package:shaqti/features/auth/cubit/auth_state.dart';
import 'package:shaqti/features/auth/data/user_model.dart';
import 'package:shaqti/features/auth/pages/admin_signup_page.dart';
import 'package:shaqti/features/auth/pages/mamber_signup_page.dart';
import 'package:shaqti/features/auth/widgets/custom_continer.dart';
import 'package:shaqti/features/my_account/page/about_app.dart';
import 'package:shaqti/features/my_account/page/apartement_details.dart';
import 'package:shaqti/features/my_account/page/languages_page.dart';
import 'package:shaqti/features/my_account/page/notification_page.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,

      appBar: AppBar(
        backgroundColor: AppColors.turquoise,

        title: CustomText(text: "الحساب", size: 18, color: AppColors.white),

        centerTitle: true,
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),

          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  SizedBox(height: 30),

                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      if (state is SuccessAuthState) {
                        final name = state.userModel.name;
                        final firstLetter = name.isNotEmpty
                            ? String.fromCharCode(name.runes.first)
                            : "؟";
                        return Column(
                          children: [
                            CircleAvatar(
                              backgroundColor: AppColors.turquoise,

                              radius: 50,

                              child: CustomText(
                                text: firstLetter,
                                size: 33,
                                color: AppColors.white,
                              ),
                            ),
                            SizedBox(height: 20),
                            CustomText(
                              text: name,
                              size: 30,
                              color: AppColors.black,
                            ),
                            SizedBox(height: 5),
                            CustomText(
                              text: state.userModel.email,
                              size: 22,
                              color: AppColors.black,
                            ),
                          ],
                        );
                      }

                      if (state is ErrorAuthState) {
                        return CustomText(
                          text: state.message,
                          size: 16,
                          color: AppColors.grey,
                          textAlign: TextAlign.center,
                        );
                      }

                      return CircularProgressIndicator(
                        color: AppColors.turquoise,
                      );
                    },
                  ),

                  SizedBox(height: 40),
                ],
              ),

              CustomText(
                text: "الاعدادات",
                size: 22,
                color: AppColors.black,
                weight: FontWeight.bold,
              ),

              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
context.push("/apartement_details");
                },
                child: CustomContiener(title: "معلومات الشقة"),
              ),

              SizedBox(height: 10),

              GestureDetector(
                onTap: () {
                  context.push("/notification");
                },
                child: CustomContiener(title: "الاشعارات"),
              ),

              SizedBox(height: 10),

              GestureDetector(
                onTap: () {
context.push("/languages");
                },
                child: CustomContiener(title: "اللغات"),
              ),

              SizedBox(height: 10),

              GestureDetector(
                onTap: () async {
                  final uri = Uri.https('wa.me', '/9647731897415', {
                    'text': ' السلام عليكم، عندي استفسار عن التطبيق شقتي',
                  });

                  final opened = await launchUrl(
                    uri,
                    mode: LaunchMode.externalApplication,
                  );

                  if (!opened && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تعذّر فتح واتساب')),
                    );
                  }
                },

                child: CustomContiener(title: "تواصل معنا"),
              ),

              SizedBox(height: 10),

              GestureDetector(
                onTap: () {
                  context.push("/about_app");
                },
                child: CustomContiener(title: "عن التطبيق"),
              ),

              SizedBox(height: 30),

              GestureDetector(
                onTap: () {
                  showProDialog(
                    context,

                    type: DialogType.warning,

                    title: "تسجيل خروج",

                    description: "هل انت متاكد من تسجيل الخروج؟",

                    barrierDismissible: false,

                    buttons: [
                      DialogButton(
                        text: "الغاء",

                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),

                      DialogButton(
                        text: "موافق",
                        onPressed: () {
                          final authCubit = context.read<AuthCubit>();
                          Navigator.pop(context);
                          authCubit.signOut();
                        },
                      ),
                    ],
                  );
                },

                child: Container(
                  height: 60,

                  width: double.infinity,

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),

                    color: AppColors.white.withAlpha(120),

                    border: Border.all(color: AppColors.turquoise, width: 1),
                  ),

                  child: Center(
                    child: Text(
                      "تسجيل خروج",

                      style: TextStyle(
                        color: AppColors.turquoise,

                        fontSize: 19,
                      ),

                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
