import 'package:shaqti/features/auth/data/user_model.dart';

abstract class GarbageStete {}

class InitialGarbageState extends GarbageStete {}

class LoadingGrbageState extends GarbageStete {}

class LoadedGrbageState extends GarbageStete {
  final List<UserModel> members;
  final Map<String, String?> garbageByDay;

  final bool isSaving;
  final bool saveSuccess;
  final String? saveError;
  final String? editingDay;
  final String? selectedMemberId;

  LoadedGrbageState({
    required this.members,
    required this.garbageByDay,
    this.isSaving = false,
    this.saveSuccess = false,
    this.saveError,
    this.editingDay,
    this.selectedMemberId,
  });
}

class ErrorGrbageState extends GarbageStete {
  final String message;

  ErrorGrbageState({required this.message});
}
