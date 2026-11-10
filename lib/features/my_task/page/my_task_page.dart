import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shaqti/core/enums/week_day.dart';
import 'package:shaqti/core/shared/custom_text.dart';
import 'package:shaqti/core/theme/app_colors.dart';
import 'package:shaqti/features/auth/cubit/auth_cubit.dart';
import 'package:shaqti/features/auth/cubit/auth_state.dart';
import 'package:shaqti/features/my_task/cubit/my_task_cubit.dart';
import 'package:shaqti/features/my_task/cubit/my_task_state.dart';

class MyTaskPage extends StatelessWidget {
  const MyTaskPage({super.key});

  static const Color _primaryColor = Color(0xFF1E3A8A);
  static const Color _mutedColor = Color(0xFF64748B);
  static const Color _surfaceColor = Colors.white;
  static const Color _iconBackground = Color(0xFFEEF4FF);

  static String dayKeyFor(DateTime date) {
    return switch (date.weekday) {
      DateTime.sunday => WeekDay.sunurday.day,
      DateTime.monday => WeekDay.manday.day,
      DateTime.tuesday => WeekDay.tuesday.day,
      DateTime.wednesday => WeekDay.wednesday.day,
      DateTime.thursday => 'الخميس',
      DateTime.friday => 'الجمعة',
      DateTime.saturday => 'السبت',
      _ => WeekDay.sunurday.day,
    };
  }

  static String dayLabelFor(DateTime date) {
    return switch (date.weekday) {
      DateTime.monday => 'الاثنين',
      DateTime.tuesday => 'الثلاثاء',
      DateTime.wednesday => 'الأربعاء',
      DateTime.thursday => 'الخميس',
      DateTime.friday => 'الجمعة',
      DateTime.saturday => 'السبت',
      _ => 'الأحد',
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, authState) {
        if (authState is SuccessAuthState) {
          _loadTasks(context, authState);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: AppColors.turquoise),
          centerTitle: true, title: CustomText(text: "مهامي", size: 18,color: AppColors.white,),backgroundColor: AppColors.turquoise,),
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final minHeight = (constraints.maxHeight - 144)
                  .clamp(0.0, constraints.maxHeight)
                  .toDouble();

              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 20, 18, 124),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: minHeight),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 620),
                      child: BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, authState) {
                          if (authState is ErrorAuthState) {
                            return _buildTaskCard(
                              context,
                              InitialMyTask(),
                              authMessage: authState.message,
                            );
                          }

                          return BlocBuilder<MyTaskCubit, MyTaskState>(
                            builder: (context, state) =>
                                _buildTaskCard(context, state),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTaskCard(
    BuildContext context,
    MyTaskState state, {
    String? authMessage,
  }) {
    final tasks = state is LoadedMyTask
        ? state.tasks.entries
            .expand(
              (section) => section.value.map(
                (task) => _TaskItem(category: section.key, title: task),
              ),
            )
            .toList()
        : const <_TaskItem>[];

    final subtitle = authMessage ??
        (switch (state) {
          LoadedMyTask() => _taskCountLabel(tasks.length),
          ErrorMyTask() => 'تعذّر تحميل مهام اليوم',
          LoadingMyTask() => 'جاري تحميل مهام اليوم...',
          _ => 'جاري تحميل مهام اليوم...',
        });

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 26, 24, 20),
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFDCE4F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x120F2B64),
            blurRadius: 28,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'مهامي اليوم',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: _primaryColor,
                        fontSize: 28,
                        height: 1.2,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: _mutedColor,
                        fontSize: 19,
                        height: 1.35,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              _DayBadge(label: _todayLabel()),
            ],
          ),
          const SizedBox(height: 30),
          if (authMessage != null)
            _AuthNotice(message: authMessage)
          else if (state is LoadedMyTask && tasks.isNotEmpty)
            _TaskList(tasks: tasks)
          else if (state is LoadedMyTask)
            const _EmptyTasks()
          else if (state is ErrorMyTask)
            _LoadError(
              message: state.message,
              onRetry: () => _reload(context),
            )
          else
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: CircularProgressIndicator(color: _primaryColor),
            ),
        ],
      ),
    );
  }

  void _reload(BuildContext context) {
    final authState = context.read<AuthCubit>().state;
    if (authState is! SuccessAuthState) return;

    _loadTasks(context, authState);
  }

  void _loadTasks(BuildContext context, SuccessAuthState authState) {
    context.read<MyTaskCubit>().getMyTasks(
          apartmentCode: authState.userModel.apartmentCode,
          day: dayKeyFor(DateTime.now()),
          userId: authState.userModel.userId,
        );
  }

  String _taskCountLabel(int count) {
    if (count == 0) return 'لا توجد مهام لهذا اليوم';
    if (count == 1) return 'مهمة واحدة لهذا اليوم';
    if (count == 2) return 'مهمتان لهذا اليوم';

    final noun = count <= 10 ? 'مهام' : 'مهمة';
    return '${_arabicDigits(count)} $noun لهذا اليوم';
  }

  String _arabicDigits(int number) {
    const digits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return number
        .toString()
        .replaceAllMapped(
          RegExp(r'\d'),
          (match) => digits[int.parse(match[0]!)],
        );
  }

  String _todayLabel() => dayLabelFor(DateTime.now());
}

class _DayBadge extends StatelessWidget {
  const _DayBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 112),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: MyTaskPage._iconBackground,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: MyTaskPage._primaryColor,
          fontSize: 19,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _TaskItem {
  const _TaskItem({required this.category, required this.title});

  final String category;
  final String title;
}

class _TaskList extends StatelessWidget {
  const _TaskList({required this.tasks});

  final List<_TaskItem> tasks;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var index = 0; index < tasks.length; index++) ...[
          _TaskRow(task: tasks[index]),
          if (index < tasks.length - 1)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Divider(height: 1, color: Color(0xFFE2E8F0)),
            ),
        ],
      ],
    );
  }
}

class _TaskRow extends StatelessWidget {
  const _TaskRow({required this.task});

  final _TaskItem task;

  @override
  Widget build(BuildContext context) {
    final icon = switch (task.category) {
      'الطعام' => Icons.restaurant_menu_rounded,
      'الماء' => Icons.water_drop_outlined,
      'القمامة' => Icons.delete_outline_rounded,
      _ => Icons.task_alt_rounded,
    };

    return Row(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: MyTaskPage._iconBackground,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(icon, color: MyTaskPage._primaryColor, size: 38),
        ),
        const SizedBox(width: 18),
        Expanded(
          child: Text(
            task.title,
            textAlign: TextAlign.start,
            style: const TextStyle(
              color: MyTaskPage._primaryColor,
              fontSize: 22,
              height: 1.35,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyTasks extends StatelessWidget {
  const _EmptyTasks();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Icon(Icons.task_alt_rounded, size: 48, color: MyTaskPage._mutedColor),
          SizedBox(height: 10),
          Text(
            'لا توجد مهام مكلّف بها اليوم',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: MyTaskPage._mutedColor,
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthNotice extends StatelessWidget {
  const _AuthNotice({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          const Icon(
            Icons.lock_outline_rounded,
            size: 46,
            color: MyTaskPage._mutedColor,
          ),
          const SizedBox(height: 12),
          const Text(
            'سجّل الدخول لعرض مهامك',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: MyTaskPage._primaryColor,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: MyTaskPage._mutedColor, fontSize: 15),
          ),
        ],
      ),
    );
  }
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: MyTaskPage._mutedColor, fontSize: 16),
          ),
          const SizedBox(height: 10),
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('إعادة المحاولة'),
            style: TextButton.styleFrom(foregroundColor: MyTaskPage._primaryColor),
          ),
        ],
      ),
    );
  }
}
