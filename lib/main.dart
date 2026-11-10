import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shaqti/core/router/app_router.dart';
import 'package:shaqti/features/auth/cubit/auth_cubit.dart';
import 'package:shaqti/features/auth/pages/login_page.dart';
import 'package:shaqti/features/food_category/cubit/food_cubit.dart';
import 'package:shaqti/features/garbage_category/cubit/garbage_cubit.dart';
import 'package:shaqti/features/my_task/cubit/my_task_cubit.dart';
import 'package:shaqti/features/rules/cubit/rule_cubit.dart';
import 'package:shaqti/features/water_category/cubit/water_category_cubit.dart';
import 'package:shaqti/root.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  await GoogleSignIn.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          lazy: false,
          create: (_)=>AuthCubit()..loadCurrentUser()),
        BlocProvider<FoodCubit>(create: (_)=> FoodCubit()),
        BlocProvider<RuleCubit>(create: (_)=> RuleCubit()),
        BlocProvider<WaterCategoryCubit>(create: (_)=> WaterCategoryCubit()),
        BlocProvider<GarbageCubit>(create: (_)=> GarbageCubit()),
        BlocProvider<MyTaskCubit>(create: (_)=>MyTaskCubit())
      ],
      child: MaterialApp.router(
        routerConfig: AppRouter.appRouter,
      debugShowCheckedModeBanner: false,
      
      
       locale: Locale("ar"),
       supportedLocales: [
        Locale("ar"),
        Locale("en")
       ],
      
       localizationsDelegates: [
         GlobalMaterialLocalizations.delegate,
         GlobalCupertinoLocalizations.delegate,
         GlobalWidgetsLocalizations.delegate
       ],
      
      
      
      
      
      ),
    );
  }
}


