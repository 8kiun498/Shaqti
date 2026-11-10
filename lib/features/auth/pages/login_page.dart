import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shaqti/core/shared/custom_text.dart';
import 'package:shaqti/core/shared/custom_txtbuttom.dart';
import 'package:shaqti/core/theme/app_colors.dart';
import 'package:shaqti/features/auth/widgets/custom_txtfaild.dart';
import 'package:shaqti/root.dart';
import '../../../core/shared/custom_snack.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  final _key = GlobalKey<FormState>();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

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
          backgroundColor: AppColors.white,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(iconTheme: IconThemeData(color: AppColors.turquoise),backgroundColor: Colors.transparent,),
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
                          width: 120,
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
                        SizedBox(height: 10),
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

                        Row(
                          children: [
                            Expanded(
                              child: Divider(color: Colors.grey, thickness: 1),
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: CustomText(
                                text: "او تسجيل الدخول مع",
                                size: 10,
                                color: Colors.grey,
                              ),
                            ),
                            Expanded(
                              child: Divider(thickness: 1, color: Colors.grey),
                            ),
                          ],
                        ),

                        SizedBox(height: 20),

                        BlocBuilder<AuthCubit, AuthState>(
                          builder: (context, state) {
                            return GestureDetector(
                              onTap: state is LoadingAuthState
                                  ? null
                                  : () => context
                                        .read<AuthCubit>()
                                        .loginWithGoogle(),
                              child: SizedBox(
                                height: 70,
                                width: 80,
                                child: CircleAvatar(
                                  backgroundColor: AppColors.quiteblue,
                                  child: Image.asset(
                                    "assets/google_logo.png",
                                    width: 40,
                                    height: 60,
                                  ),
                                ),
                              ),
                            );
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
                                      context
                                          .read<AuthCubit>()
                                          .loginWithEmailAndPassword(
                                            email: email.text.trim(),
                                            password: password.text.trim(),
                                          );
                                    },
                              child: CustomTxtbuttom(
                                text: "تسجيل دخول",
                                isLoading: isLoading,
                              ),
                            );
                          },
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
