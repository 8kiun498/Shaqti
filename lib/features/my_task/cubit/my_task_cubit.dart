import "package:flutter_bloc/flutter_bloc.dart";
import "package:shaqti/features/my_task/data/my_task.dart";
import "my_task_state.dart";

class MyTaskCubit extends Cubit<MyTaskState> {
  MyTaskCubit() : super(InitialMyTask());

  final MyTask _data = MyTask();

  Future<void> getMyTasks({
    required String apartmentCode,
    required String day,
    required String userId,
  }) async {
    emit(LoadingMyTask());

    try {
      final tasks = await _data.myTasks(
        apartementCode: apartmentCode,
        day: day,
        userId: userId,
      );

      emit(LoadedMyTask(tasks: tasks));
    } catch (e) {
      emit(ErrorMyTask(message: "تعذّر تحميل مهامك، حاول مرة ثانية"));
    }
  }
}