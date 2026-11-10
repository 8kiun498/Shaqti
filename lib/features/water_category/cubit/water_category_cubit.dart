import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shaqti/core/enums/week_day.dart';
import 'package:shaqti/features/food_category/data/aparetment_mambers_data.dart';
import 'package:shaqti/features/water_category/cubit/water_category_state.dart';
import 'package:shaqti/features/water_category/data/water_category_data.dart';

class WaterCategoryCubit extends Cubit<WaterCategoryState> {
  WaterCategoryCubit() : super(InitialWaterCategory());

  final WaterCategoryData _waterCategoryData = WaterCategoryData();
  final ApartmentMembersData _membersData = ApartmentMembersData();

  Future<void> getWaterByDay({required String apartementcode}) async {
    emit(LoadingWaterCategory());

    try {
      final members = await _membersData.getMembers(apartementcode);

      final Map<String, String?> waterByDay = {};

      for (final day in WeekDay.values) {
        waterByDay[day.day] = await _waterCategoryData.getWaterByDay(
          day: day.day,
          apartementcode: apartementcode,
        );
      }
      emit(LoadedWaterCategory(members: members, waterByDay: waterByDay));
    } catch (e) {
      emit(ErrorWaterCategory(message: "حدث خطا غير متوقع"));
    }
  }

  Future<void> saveWater({
  required String apartmentCode,
}) async {
  final current = state;

  if (current is! LoadedWaterCategory) return;
  if (current.isSaving || current.editingDay == null) return;

  final day = current.editingDay!;
  final memberId = current.selectedMemberId;

  if (memberId == null) return;

  emit(
    LoadedWaterCategory(
      members: current.members,
      waterByDay: current.waterByDay,
      editingDay: day,
      selectedMemberId: memberId,
      isSaving: true,
    ),
  );

  try {
    await _waterCategoryData.saveWater(
      apartementCode: apartmentCode,
      day: day,
      mamberId: memberId,
    );

    final updatedWaterByDay = <String, String?>{};
    updatedWaterByDay.addAll(current.waterByDay);
    updatedWaterByDay[day] = memberId;

    emit(
      LoadedWaterCategory(
        members: current.members,
        waterByDay: updatedWaterByDay,
        saveSuccess: true,
      ),
    );
  } catch (e) {
    emit(
      LoadedWaterCategory(
        members: current.members,
        waterByDay: current.waterByDay,
        editingDay: day,
        selectedMemberId: memberId,
        saveError: "تعذّر حفظ مسؤول هذا اليوم",
      ),
    );
  }
}
void startEditing(String day) {
  final current = state;

  if (current is! LoadedWaterCategory) return;
  if (current.isSaving) return;

  emit(
    LoadedWaterCategory(
      members: current.members,
      waterByDay: current.waterByDay,
      editingDay: day,
      selectedMemberId: current.waterByDay[day],
    ),
  );
}

void selectWaterMember(String? memberId) {
  final current = state;

  if (current is! LoadedWaterCategory) return;
  if (current.isSaving || current.editingDay == null) return;

  emit(
    LoadedWaterCategory(
      members: current.members,
      waterByDay: current.waterByDay,
      editingDay: current.editingDay,
      selectedMemberId: memberId,
    ),
  );
}
}
