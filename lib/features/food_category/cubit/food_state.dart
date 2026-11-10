import 'package:shaqti/features/auth/data/user_model.dart';

abstract class FoodState {}

class FoodInitial extends FoodState {}

class FoodMembersLoading extends FoodState {}

class FoodMembersLoaded extends FoodState {
  final List<UserModel> members;


 final String? editingDay;
final String? selectedLunch;
final String? selectedDinner;
  final bool isSaving;
  final bool saveSuccess;
  final String? saveError;
  
    final Map<String, Map<String, dynamic>> schedules;


  FoodMembersLoaded(
      this.members, {
         this.editingDay, this.selectedLunch, this.selectedDinner, required this.isSaving, required this.saveSuccess, this.saveError,  this.schedules =const{}});
}

class FoodMembersError extends FoodState {
  final String message;

  FoodMembersError(this.message);
}