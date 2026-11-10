import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shaqti/core/shared/custom_snack.dart';
import 'package:shaqti/core/shared/custom_text.dart';
import 'package:shaqti/core/shared/custom_txtbuttom.dart';
import 'package:shaqti/core/theme/app_colors.dart';
import 'package:shaqti/features/auth/cubit/auth_cubit.dart';
import 'package:shaqti/features/auth/cubit/auth_state.dart';
import 'package:shaqti/features/auth/pages/login_page.dart';
import 'package:shaqti/features/auth/widgets/custom_txtfaild.dart';
import 'package:shaqti/features/categories/pages/categories_page.dart';
import 'package:shaqti/root.dart';

class AdminSignupPage extends StatelessWidget {
  final TextEditingController apartmentName = TextEditingController();
  final TextEditingController adminName = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  final _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is SuccessAuthState) {
          context.pushReplacement("/root");
        }
        if (state is ErrorAuthState) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(customSnack(state.message));
        }
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
                    appBar: AppBar(iconTheme: IconThemeData(color: AppColors.turquoise),backgroundColor: Colors.transparent,),

          backgroundColor: AppColors.white,
          resizeToAvoidBottomInset: true,
          body: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Form(
              key: _key,
              child: SafeArea(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 30),
                        SvgPicture.asset(
                          "assets/login/login_logo.svg",
                          width: 100,
                        ),
                        SizedBox(height: 30),
                        CustomText(
                          text: "مرحبا بك في تطبيق شقتي",
                          size: 26,
                          color: AppColors.turquoise,
                          weight: FontWeight.bold,
                        ),
                        SizedBox(height: 10),
                        SizedBox(height: 20),
                        CustomTxtfaild(
                          controller: apartmentName,
                          hint: "اسم الشقة",
                          icon: Icon(Icons.home),
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return "يرجى ادخال اسم الشقة";
                            }
                          },
                        ),
                        SizedBox(height: 20),
                        CustomTxtfaild(
                          controller: adminName,
                          hint: "اسم المستخدم",
                          icon: Icon(Icons.person),
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return "يرجى ادخال اسم المستخدم";
                            }

                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        CustomTxtfaild(
                          controller: email,
                          hint: "البريد الالكتروني",
                          icon: Icon(Icons.email),
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return "يرجى ادخال البريد الالكتروني";
                            }
                            if (!val.contains("@")) {
                              return "يرجى ادخال بريد الكتروني صحيح";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        CustomTxtfaild(
                          controller: password,
                          hint: "كلمة المرور",
                          icon: Icon(Icons.lock_rounded),
                          isPassword: true,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return "يرجى ادخال  كلمة المرور";
                            }

                            return null;
                          },
                        ),
                        SizedBox(height: 40),

                        BlocBuilder<AuthCubit, AuthState>(
                          builder: (context, state) {
                            final isLoading = state is LoadingAuthState;

                            return GestureDetector(
                              onTap: isLoading
                                  ? null
                                  : () {
                                      if (!_key.currentState!.validate()) {
                                        return;
                                      }

                                      context.read<AuthCubit>().craetApartement(
                                        apartmentName: apartmentName.text
                                            .trim(),
                                        name: adminName.text.trim(),
                                        email: email.text.trim(),
                                        password: password.text.trim(),
                                      );
                                    },
                              child:  
                                    CustomTxtbuttom(text : "تسجيل دخول" , isLoading: isLoading,),
                            );
                          },
                        ),
                        SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CustomText(
                              text: "لديك حساب ؟ ",
                              size: 18,
                              color: AppColors.black,
                            ),
                            GestureDetector(
                              onTap: () {
context.push("/login");
                              },
                              child: CustomText(
                                text: "تسجيل دخول",
                                size: 18,
                                color: AppColors.turquoise,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
