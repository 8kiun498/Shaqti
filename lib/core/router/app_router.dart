import 'package:go_router/go_router.dart';
import 'package:shaqti/features/auth/pages/admin_signup_page.dart';
import 'package:shaqti/features/auth/pages/house_selection_page.dart';
import 'package:shaqti/features/auth/pages/login_page.dart';
import 'package:shaqti/features/auth/pages/mamber_signup_page.dart';
import 'package:shaqti/features/categories/pages/categories_page.dart';
import 'package:shaqti/features/food_category/pages/food_category_page.dart';
import 'package:shaqti/features/garbage_category/page/garbage_category_page.dart';
import 'package:shaqti/features/my_account/page/about_app.dart';
import 'package:shaqti/features/my_account/page/apartement_details.dart';
import 'package:shaqti/features/my_account/page/languages_page.dart';
import 'package:shaqti/features/my_account/page/notification_page.dart';
import 'package:shaqti/features/my_account/page/profile_page.dart';
import 'package:shaqti/features/my_task/page/my_task_page.dart';
import 'package:shaqti/features/rules/pages/rules_page.dart';
import 'package:shaqti/features/water_category/page/water_page.dart';
import 'package:shaqti/root.dart';
import 'package:shaqti/splash_page.dart';

class AppRouter {
  static final GoRouter appRouter = GoRouter(
    initialLocation: "/splash",
    routes: [
      GoRoute(
        path: "/splash",
        builder: (context, state) {
          return SplashPage();
        },
      ),

      GoRoute(
        path: "/house_section",
        builder: (context, state) {
          return HouseSelectionPage();
        },
      ),

      GoRoute(
        path: "/login",
        builder: (context, state) {
          return LoginPage();
        },
      ),

      GoRoute(
        path: "/admin_signup",
        builder: (context, state) {
          return AdminSignupPage();
        },
      ),

      GoRoute(
        path: "/mamber_signup",
        builder: (context, state) {
          return MamberSignupPage();
        },
      ),

      GoRoute(
        path: "/root",
        builder: (context, state) {
          return Root();
        },
      ),
      GoRoute(
        path: "/categories",
        builder: (context, state) {
          final  code = state.pathParameters["apretemtnCode"]!;
          final isAdmin = bool.parse(state.pathParameters["isAdmin"]!);
          return CategoriesPage(apretemtnCode: code, isAdmin: isAdmin ,);
        },
      ),

            GoRoute(
        path: "/food",
        builder: (context, state) {
          return const FoodCategoryPage();
        },
      ),

            GoRoute(
        path: "/water",
        builder: (context, state) {
          return const WaterPage();
        },
      ),

            GoRoute(
        path: "/garbage",
        builder: (context, state) {
          return const GarbageCategoryPage();
        },
      ),

            GoRoute(
        path: "/my_task",
        builder: (context, state) {
          return const MyTaskPage();
        },
      ),

      GoRoute(
        path: "/rules/:apretemtnCode",
        builder: (context, state) {
          final code = state.pathParameters["apretemtnCode"]!;
          return RulesPage(apartmentCode: code);
        },
      ),

            GoRoute(
        path: "/my_account",
        builder: (context, state) {
          return  ProfilePage();
        },
      ),

            GoRoute(
        path: "/apartement_details",
        builder: (context, state) {
          return  ApartementDetails();
        },
      ),

            GoRoute(
        path: "/about_app",
        builder: (context, state) {
          return const AboutAppPage();
        },
      ),

            GoRoute(
        path: "/notification",
        builder: (context, state) {
          return const NotificationPage();
        },
      ),

            GoRoute(
        path: "/languages",
        builder: (context, state) {
          return  LanguagesPage();
        },
      ),
    ],
  );
}
