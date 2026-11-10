import "package:flutter/material.dart";

import "../../../core/shared/custom_text.dart";
import "../../../core/theme/app_colors.dart";

class MealColumn extends StatelessWidget {
  final String title;
  final String name;
  final bool isEditing;
  final bool isSaving;
  final String? selectedId;
  final List<DropdownMenuItem<String>> items;
  final ValueChanged<String?> onChanged;

  const MealColumn({
    super.key,
    required this.title,
    required this.name,
    required this.isEditing,
    required this.isSaving,
    required this.selectedId,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomText(
          text: title,
          size: 16,
          color: Colors.grey,
        ),
        const SizedBox(height: 10),
        if (isEditing)
          InputDecorator(
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 4,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: AppColors.turquoise,
                ),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedId,
                items: items,
                onChanged: isSaving ? null : onChanged,
                hint: const Text("اختار عضو"),
                isExpanded: true,
                isDense: true,
                dropdownColor: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                elevation: 2,
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                ),
              ),
            ),
          )
        else
          CustomText(
            text: name,
            size: 18,
            color: Colors.black,
            weight: FontWeight.bold,
          ),
      ],
    );
  }
}