abstract class MyTaskState {}

class InitialMyTask extends MyTaskState {}

class LoadingMyTask extends MyTaskState {}

class LoadedMyTask extends MyTaskState {
  final Map<String, List<String>> tasks;

  LoadedMyTask({required this.tasks});
}

class ErrorMyTask extends MyTaskState {
  final String message;

  ErrorMyTask({required this.message});
}