import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shaqti/features/rules/cubit/rule_state.dart';
import 'package:shaqti/features/rules/data/rule_data.dart';

class RuleCubit extends Cubit<RuleState> {
  RuleCubit() : super(InitialRuleState());

  final RuleData _data = RuleData();





  Future<void> getRules(String apartmentCode) async {
    emit(LoadingRuleState());

    try {
      final rules = await _data.getRules(apartmentCode);
      emit(SuccessRuleState(getRules: rules));
    } catch (e) {
      final String message = "حدث خطا يرجى اعادة تحديث الصفحة";
      emit(ErrorRuleState(message: message));
    }
  }


  Future<void> saveRules({
    required String apartmentCode,
    required String text,
    required int order,
  }) async {
    emit(LoadingRuleState());
    try {
      await _data.saveRules(
        apartmentCode: apartmentCode,
        text: text,
        order: order,
      );
      emit(SavedRuleState());
      await getRules(apartmentCode);
    } catch (e) {
      emit(
        ErrorRuleState(message: "حدث خطا غير متوقع يرجى اعادة تحديث الصفحة"),
      );
    }


  }




  Future<void> deleteRules({
    required String apartmentCode,
    required String ruleId,

  }) async {
    emit(LoadingRuleState());
    try {
      await _data.deleteRules(apartmentCode: apartmentCode, ruleId: ruleId);
      await getRules(apartmentCode);
    } catch (e) {
      emit(
        ErrorRuleState(message: "حدث خطا غير متوقع يرجى اعادة تحديث الصفحة"),
      );
    }}

}
