import 'package:shaqti/features/rules/data/rule_model.dart';

abstract class RuleState {}


class InitialRuleState extends RuleState {}

class LoadingRuleState extends RuleState {}


class SuccessRuleState extends RuleState {
  final List<RuleModel> getRules ;

  SuccessRuleState({required this.getRules});
}


class ErrorRuleState extends RuleState {

  final String message ;

  ErrorRuleState({required this.message});
}

class SavedRuleState extends RuleState{}



