import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../../core/shared/custom_text.dart";
import "../../../core/shared/custom_snack.dart";
import "../../../core/shared/custom_success_snack.dart";
import "../../../core/theme/app_colors.dart";
import "../../auth/cubit/auth_cubit.dart";
import "../../auth/cubit/auth_state.dart";
import "../cubit/food_cubit.dart";
import "../cubit/food_state.dart";
import "food_loading.dart";
import "meal_column.dart";

class FoodCard extends StatelessWidget {
  final String weekDay;
  final String lunch;
  final String dinner;

  const FoodCard({
    super.key,
    required this.weekDay,
    required this.lunch,
    required this.dinner,
  });

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    final isAdmin =
        authState is SuccessAuthState && authState.userModel.isAdmin;

    return BlocBuilder<FoodCubit, FoodState>(

      builder: (context, state) {
        if (state is FoodMembersLoading) {
          return FoodLoading(weekDay: weekDay);
        }

        if (state is FoodMembersError) {
          return Text(state.message);
        }

        if (state is! FoodMembersLoaded) {
          return const SizedBox.shrink();
        }

        final cubit = context.read<FoodCubit>();
        final isEditing = state.editingDay == weekDay;
        final isSaving = state.isSaving;

        final meals = state.schedules[weekDay];
        final lunchId = meals!["lunch"] as String?;
        final dinnerId = meals["dinner"] as String?;

        final lunchName = state.members
                .where((member) => member.userId == lunchId)
                .map((member) => member.name)
                .firstOrNull ??
            "غير محدد";

        final dinnerName = state.members
                .where((member) => member.userId == dinnerId)
                .map((member) => member.name)
                .firstOrNull ??
            "غير محدد";

        final items = state.members.map((member) {
          return DropdownMenuItem<String>(
            value: member.userId,
            child: Text(
              member.name,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList();

        return Padding(
          padding: const EdgeInsets.all(15),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.grey),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    CustomText(
                      text: weekDay,
                      color: Colors.black,
                      size: 20,
                    ),
                    const Spacer(),
                    if (isAdmin)
                      TextButton(
                        onPressed: isSaving
                            ? null
                            : () {
                                if (isEditing) {
                                  cubit.saveDayMeals();
                                } else {
                                  cubit.startEditing(weekDay);
                                }
                              },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomText(
                              text: isEditing
                                  ? (isSaving ? " جاري الحفظ..." : "حفظ")
                                  : "تعديل",
                              size: 18,
                              color: AppColors.grey,
                            ),
                            if (!isEditing) ...[
                               SizedBox(width: 4),
                               Icon(
                                Icons.edit_outlined,
                                color: AppColors.grey,
                                size: 16,
                              ),
                            ],
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(color: Colors.grey),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: MealColumn(
                        title: lunch,
                        name: lunchName,
                        isEditing: isEditing && isAdmin,
                        isSaving: isSaving,
                        selectedId: state.selectedLunch,
                        items: items,
                        onChanged: (value) {
                          cubit.selectMeals(
                            lunchId: value,
                            dinnerId: state.selectedDinner,
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: MealColumn(
                        title: dinner,
                        name: dinnerName,
                        isEditing: isEditing && isAdmin,
                        isSaving: isSaving,
                        selectedId: state.selectedDinner,
                        items: items,
                        onChanged: (value) {
                          cubit.selectMeals(
                            lunchId: state.selectedLunch,
                            dinnerId: value,
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        );
      },
    );
  }
}