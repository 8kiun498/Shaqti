import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:shaqti/core/shared/custom_text.dart';
import 'package:shaqti/core/theme/app_colors.dart';
import 'package:shaqti/features/auth/cubit/auth_cubit.dart';
import 'package:shaqti/features/auth/cubit/auth_state.dart';
import 'package:shaqti/features/food_category/data/aparetment_mambers_data.dart';
import 'package:shaqti/features/my_account/widgets/custom_section.dart';
import 'package:flutter/services.dart';

class ApartementDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,

      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.white),
        centerTitle: true,
        backgroundColor: AppColors.turquoise,
        title: CustomText(
          text: "معلومات الشقة",
          size: 22,
          color: AppColors.white,
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is SuccessAuthState) {
              final apartementName = state.userModel.apartmentName;
              final apartementCode = state.userModel.apartmentCode;

              return Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(24, 26, 24, 20),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: const Color(0xFFDCE4F0)),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.quiteblue,
                          blurRadius: 28,
                          offset: Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: AppColors.turquoise.withAlpha(30),
                              ),
                              child: Icon(
                                LucideIcons.house,
                                color: AppColors.turquoise,
                                size: 25,
                              ),
                            ),
                            SizedBox(width: 10),
                            CustomText(
                              text: "معلومات الشقة",
                              size: 20,
                              color: AppColors.turquoise,
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Divider(
                          color: AppColors.grey.withAlpha(100),
                          thickness: 1,
                          indent: 16,
                          endIndent: 16,
                        ),

                        SizedBox(height: 10),
                        CustomSection(
                          icon: LucideIcons.building2,
                          label: "اسم الشقة : $apartementName",
                        ),
                        SizedBox(height: 10),
                        Divider(
                          color: AppColors.grey.withAlpha(100),
                          thickness: 1,
                          indent: 16,
                          endIndent: 16,
                        ),
                        SizedBox(height: 10),
                        FutureBuilder(
                          future: ApartmentMembersData().getMembers(
                            apartementCode,
                          ),
                          builder: (context, snapshot) {
                            final count = snapshot.data?.length;

                            return CustomSection(
                              icon: LucideIcons.usersRound,
                              label: "عدد الاعضاء : $count",
                            );
                          },
                        ),

                        Divider(
                          color: AppColors.grey.withAlpha(100),
                          thickness: 1,
                          indent: 16,
                          endIndent: 16,
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            CustomSection(
                              icon: LucideIcons.keyRound,
                              label: "رمز الشقة : $apartementCode ",
                            ),
                            Spacer(),
                            InkWell(
                              onTap: () async {
                                await Clipboard.setData(
                                  ClipboardData(text: apartementCode),
                                  
                                );
                              },
                              child: Icon(
                                LucideIcons.copy,
                                color: AppColors.turquoise,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
            return SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
