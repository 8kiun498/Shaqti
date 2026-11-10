import 'package:shaqti/features/auth/data/user_model.dart';

abstract class WaterCategoryState {}

class InitialWaterCategory extends WaterCategoryState {}

class LoadingWaterCategory extends WaterCategoryState {}
class LoadedWaterCategory extends WaterCategoryState {
  final List<UserModel> members;
  final Map<String, String?> waterByDay;

  final bool isSaving;
  final bool saveSuccess;
  final String? saveError;
  final String? editingDay;
  final String? selectedMemberId;

  LoadedWaterCategory({
    required this.members,
    required this.waterByDay,
    this.isSaving = false,
    this.saveSuccess = false,
    this.saveError, this.editingDay, this.selectedMemberId,
  });
}

class ErrorWaterCategory extends WaterCategoryState {
  final String message;

  ErrorWaterCategory({required this.message});
}
