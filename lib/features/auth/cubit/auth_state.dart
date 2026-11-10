import 'package:shaqti/features/auth/data/user_model.dart';

abstract class AuthState {}

class InitialAuthState extends AuthState {}

class LoadingAuthState extends AuthState {}

class SuccessAuthState extends AuthState {
  final UserModel userModel;

  SuccessAuthState({required this.userModel});
}

class ErrorAuthState extends AuthState {
  final String message;

  ErrorAuthState({required this.message});
}
