import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:shaqti/core/enums/week_day.dart";
import "package:shaqti/core/shared/custom_text.dart";
import "package:shaqti/core/shared/custom_snack.dart";
import "package:shaqti/core/shared/custom_success_snack.dart";
import "package:shaqti/core/theme/app_colors.dart";
import "package:shaqti/features/auth/cubit/auth_cubit.dart";
import "package:shaqti/features/auth/cubit/auth_state.dart";
import "package:shaqti/features/garbage_category/cubit/garbage_cubit.dart";
import "package:shaqti/features/garbage_category/cubit/garbage_stete.dart";
import "package:shaqti/features/water_category/cubit/water_category_cubit.dart";
import "package:shaqti/features/water_category/cubit/water_category_state.dart";

class GarbageCategoryPage extends StatefulWidget {
  const GarbageCategoryPage({super.key});

  @override
  State<GarbageCategoryPage> createState() => _GarbageCategoryPageState();
}

class _GarbageCategoryPageState extends State<GarbageCategoryPage> {
  @override
  void initState() {
    super.initState();

    final authState = context.read<AuthCubit>().state;

    if (authState is SuccessAuthState) {
      final code = authState.userModel.apartmentCode;

      context.read<GarbageCubit>().getGarbageByDay(
        apartementcode: code,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.white),
        centerTitle: true,
        title: CustomText(
          text: "جدول القمامة",
          size: 18,
          color: AppColors.white,
        ),
        backgroundColor: AppColors.turquoise,
      ),
      body: BlocListener<GarbageCubit,GarbageStete>(
        listener: (context, state) {
            if (state is! LoadedGrbageState) return;

                  if (state.saveSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      customSuccessSnack("تم الحفظ بنجاح"),
                    );
                  } else if (state.saveError != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      customSnack(state.saveError!),
                    );
                  }
        },
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.turquoise.withAlpha(30),
                    border: Border.all(
                      color: AppColors.turquoise,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppColors.turquoise.withAlpha(30),
                          ),
                          child: const Icon(
                            Icons.error_outline,
                            color: AppColors.turquoise,
                            size: 25,
                          ),
                        ),
                        Expanded(
                          child: CustomText(
                            text:
                                "الخميس والجمعة والسبت يكون الجدول بالاتفاق مع الموجودين بالشقة فقط.",
                            size: 15,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
        
                  BlocBuilder<GarbageCubit,GarbageStete>(
                  builder: (context, state) {
                    if (state is LoadingGrbageState) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.turquoise,
                        ),
                      );
                    }
        
                    if (state is ErrorGrbageState) {
                      return Center(
                        child: CustomText(
                          text: state.message,
                          size: 19,
                          color: AppColors.turquoise,
                        ),
                      );
                    }
        
                    if (state is! LoadedGrbageState) {
                      return const SizedBox.shrink();
                    }
        
                    if (authState is! SuccessAuthState) {
                      return const SizedBox.shrink();
                    }
        
                    final cubit = context.read<GarbageCubit>();
                    final isSaving = state.isSaving;
                    final code = authState.userModel.apartmentCode;
                    final isAdmin = authState.userModel.isAdmin;
        
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 20);
                      },
                      itemCount: WeekDay.values.length,
                      itemBuilder: (context, index) {
                        final day = WeekDay.values[index].day;
                        final memberId = state.garbageByDay[day];
                        final isEditing = state.editingDay == day;
        
                        return Container(
                          padding: const EdgeInsets.all(10),
                          height: 90,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppColors.grey.withAlpha(30),
                            border: Border.all(
                              color: AppColors.grey,
                            ),
                          ),
                          child: Row(
                            children: [
                              CustomText(
                                text: day,
                                size: 18,
                                color: AppColors.black,
                              ),
                               SizedBox(width: 80),
                              Expanded(
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    borderRadius: BorderRadius.circular(12),
                                    dropdownColor: AppColors.white,
                                    value: isEditing
                                        ? state.selectedMemberId
                                        : memberId,
                                    hint:CustomText(text: "اختر العضو", size: 14),
                                    items: state.members.map((member) {
                                      return DropdownMenuItem<String>(
                                        value: member.userId,
                                        child: CustomText(
                                        text:   member.name,
                                          color: AppColors.black,
                                          size: 16,
                                        ),
                                      );
                                    }).toList(),
                                    onChanged:
                                        isAdmin && isEditing && !isSaving
                                        ? (value) {
                                            cubit.selectGarbageMember(value);
                                          }
                                        : null,
                                  ),
                                ),
                              ),
                              if (isAdmin)
                                TextButton(
                                  onPressed: isSaving
                                      ? null
                                      : () {
                                          if (isEditing) {
                                            cubit.saveGarbage(
                                              apartmentCode: code,
                                            );
                                          } else {
                                            cubit.startEditing(day);
                                          }
                                        },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CustomText(
                                        text: isEditing
                                            ? (isSaving
                                                  ? "جاري الحفظ..."
                                                  : "حفظ")
                                            : "تعديل",
                                        size: 16,
                                        color: AppColors.grey,
                                      ),
                                   
                                      if (!isEditing)
                                        const Icon(
                                          Icons.edit_outlined,
                                          color: AppColors.grey,
                                          size: 16,
                                        ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    );
                  
                  },
                  
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}