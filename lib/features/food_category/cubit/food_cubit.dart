import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/enums/week_day.dart';
import '../data/aparetment_mambers_data.dart';
import 'food_state.dart';

class FoodCubit extends Cubit<FoodState> {
  FoodCubit() : super(FoodInitial());

  final ApartmentMembersData _data = ApartmentMembersData();
  String? _apartmentCode;
  
     void startEditing(String day) {
  final current = state;

  if (current is! FoodMembersLoaded) return;
  if (current.isSaving) return;

  final meals = current.schedules[day];

  emit(FoodMembersLoaded(
    current.members,
    schedules: current.schedules,
    editingDay: day,
    selectedLunch: meals?['lunch'] as String?,
    selectedDinner: meals?['dinner'] as String?, isSaving: false, saveSuccess: false,
  ));
}

void selectMeals({
  required String? lunchId,
  required String? dinnerId,
}) {
  final current = state;

  if (current is! FoodMembersLoaded) return;
  if (current.isSaving || current.editingDay == null) return;

  emit(FoodMembersLoaded(
    current.members,
    schedules: current.schedules,
    editingDay: current.editingDay,
    selectedLunch: lunchId,
    selectedDinner: dinnerId,
    isSaving: false,
    saveSuccess: false,
  ));
}

Future<void> getMembers(String apartmentCode) async {
  final code = apartmentCode.trim();

  if (state is FoodMembersLoaded && _apartmentCode == code) {
    return;
  }

  emit(FoodMembersLoading());

  try {
  

    _apartmentCode = code;

    final members = await _data.getMembers(code);

    final schedules = <String, Map<String, dynamic>>{};

    for (final day in WeekDay.values) {
      schedules[day.day] = await _data.getDaySchedule(
        apartmentCode: code,
        day: day.day,
      );
    }

    emit(FoodMembersLoaded(
      members,
      schedules: schedules,
      isSaving: false,
      saveSuccess: false,
    ));
  } catch (e) {
    emit(FoodMembersError("تعذر تحميل اعضاء الشقة"));
  }
}


Future<void> saveDayMeals() async {
  final current = state;
  final code = _apartmentCode;

  if (current is! FoodMembersLoaded) return;
  if (current.isSaving) return;

  final day = current.editingDay;
  final lunchId = current.selectedLunch;
  final dinnerId = current.selectedDinner;

  if (code == null ||
      day == null ||
      lunchId == null ||
      dinnerId == null) {
    return;
  }
    

    emit(FoodMembersLoaded(
  current.members,
  schedules: current.schedules,
  editingDay: day,
  selectedLunch: lunchId,
  selectedDinner: dinnerId,
  isSaving: true,
  saveSuccess: false,
));

try {
  await _data.saveDayMeals(
    apartmentCode: code,
    day: day,
    lunchId: lunchId,
    dinnerId: dinnerId,
  );

 final updatedSchedules = <String, Map<String, dynamic>>{};
updatedSchedules.addAll(current.schedules);

final dayMeals = <String, dynamic>{};
dayMeals.addAll(current.schedules[day] ?? {});

dayMeals["lunch"] = lunchId;
dayMeals["dinner"] = dinnerId;

updatedSchedules[day] = dayMeals;

  emit(FoodMembersLoaded(
    current.members,
    schedules: updatedSchedules,
    isSaving: false,
    saveSuccess: true,
  ));
} catch (e) {
  emit(FoodMembersLoaded(
    current.members,
    schedules: current.schedules,
    editingDay: day,
    selectedLunch: lunchId,
    selectedDinner: dinnerId,
    isSaving: false,
    saveSuccess: false,
    saveError: 'تعذّر الحفظ، حاول مرة ثانية',
  ));
}
}


}
