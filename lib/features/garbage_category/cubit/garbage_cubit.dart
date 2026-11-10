import "package:flutter_bloc/flutter_bloc.dart";
import "package:shaqti/core/enums/week_day.dart";
import "package:shaqti/features/food_category/data/aparetment_mambers_data.dart";
import "package:shaqti/features/garbage_category/cubit/garbage_stete.dart";
import "package:shaqti/features/garbage_category/data/grabage_data.dart";

class GarbageCubit extends Cubit<GarbageStete> {
  GarbageCubit() : super(InitialGarbageState());

  final GrabageData _grabageData = GrabageData();
  final ApartmentMembersData _membersData = ApartmentMembersData();

  Future<void> getGarbageByDay({
    required String apartementcode,
  }) async {
    emit(LoadingGrbageState());

    try {
      final members = await _membersData.getMembers(apartementcode);

      final garbageByDay = <String, String?>{};

      for (final day in WeekDay.values) {
        garbageByDay[day.day] = await _grabageData.getCarbage(
          day: day.day,
          apartementCode: apartementcode,
        );
      }

      emit(
        LoadedGrbageState(
          members: members,
          garbageByDay: garbageByDay,
        ),
      );
    } catch (e) {
      emit(ErrorGrbageState(message: "تعذّر تحميل جدول القمامة"));
    }
  }

  void startEditing(String day) {
    final current = state;

    if (current is! LoadedGrbageState) return;
    if (current.isSaving) return;

    emit(
      LoadedGrbageState(
        members: current.members,
        garbageByDay: current.garbageByDay,
        editingDay: day,
        selectedMemberId: current.garbageByDay[day],
      ),
    );
  }

  void selectGarbageMember(String? memberId) {
    final current = state;

    if (current is! LoadedGrbageState) return;
    if (current.isSaving || current.editingDay == null) return;

    emit(
      LoadedGrbageState(
        members: current.members,
        garbageByDay: current.garbageByDay,
        editingDay: current.editingDay,
        selectedMemberId: memberId,
      ),
    );
  }

  Future<void> saveGarbage({
    required String apartmentCode,
  }) async {
    final current = state;

    if (current is! LoadedGrbageState) return;
    if (current.isSaving || current.editingDay == null) return;

    final day = current.editingDay!;
    final memberId = current.selectedMemberId;

    if (memberId == null) return;

    emit(
      LoadedGrbageState(
        members: current.members,
        garbageByDay: current.garbageByDay,
        editingDay: day,
        selectedMemberId: memberId,
        isSaving: true,
      ),
    );

    try {
      await _grabageData.saveGarbage(
        apartementCode: apartmentCode,
        day: day,
        mamberId: memberId,
      );

      final updatedGarbageByDay = <String, String?>{};
      updatedGarbageByDay.addAll(current.garbageByDay);
      updatedGarbageByDay[day] = memberId;

      emit(
        LoadedGrbageState(
          members: current.members,
          garbageByDay: updatedGarbageByDay,
          saveSuccess: true,
        ),
      );
    } catch (e) {
      emit(
        LoadedGrbageState(
          members: current.members,
          garbageByDay: current.garbageByDay,
          editingDay: day,
          selectedMemberId: memberId,
          isSaving: false,
          saveError: "تعذّر حفظ مسؤول هذا اليوم",
        ),
      );
    }
  }
}