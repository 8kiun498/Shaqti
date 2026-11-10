import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:shaqti/core/shared/custom_navbar.dart';
import 'package:shaqti/core/shared/custom_text.dart';
import 'package:shaqti/core/theme/app_colors.dart';
import 'package:shaqti/features/auth/cubit/auth_cubit.dart';
import 'package:shaqti/features/auth/cubit/auth_state.dart';
import 'package:shaqti/features/auth/pages/house_selection_page.dart';
import 'package:shaqti/features/auth/pages/login_page.dart';
import 'package:shaqti/features/my_account/page/profile_page.dart';
import 'package:shaqti/features/categories/pages/categories_page.dart';
import 'package:shaqti/features/categories/whdgets/custom_category.dart';
import 'package:shaqti/features/my_task/page/my_task_page.dart';
import 'package:shaqti/features/my_task/cubit/my_task_cubit.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Root extends StatefulWidget {
  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
int  currentIndex = 0;


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit,AuthState>(
      builder: (context, state) {
        if (state is LoadingAuthState &&
            context.read<AuthCubit>().hasCurrentUser) {
          return Scaffold(
            backgroundColor: AppColors.white,
            body: Skeletonizer(
              enabled: true,
              effect: ShimmerEffect(
                baseColor: AppColors.grey.withAlpha(30),
                highlightColor: AppColors.white,
                duration: const Duration(milliseconds: 900),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 10,
                  left: 10,
                  top: 40,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CustomText(
                          text: "اهلا , ",
                          size: 23,
                          weight: FontWeight.bold,
                        ),
                        CustomText(
                          text: "سجاد احمد 👋",
                          size: 23,
                          weight: FontWeight.bold,
                        ),
                      ],
                    ),
                    GridView.count(
                      padding: const EdgeInsets.only(top: 10),
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      children: [
                        CustomCategory(
                          image: "assets/food.svg",
                          category: "جدول الطعام",
                        ),
                        CustomCategory(
                          image: "assets/clean.svg",
                          category: "جدول التنظيف",
                        ),
                        CustomCategory(
                          image: "assets/need.svg",
                          category: "احتياجات الشقة",
                        ),
                        CustomCategory(
                          image: "assets/rules.svg",
                          category: "قوانين الشقة",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        if (state is! SuccessAuthState) {
          return HouseSelectionPage();
        }


        return Scaffold(
          extendBody: true,
        backgroundColor: AppColors.white,
        body: IndexedStack(
          index: currentIndex ,
          children: [
            CategoriesPage(
              apretemtnCode: state.userModel.apartmentCode,
              isAdmin: state.userModel.isAdmin,
            ),
            MyTaskPage(),
            ProfilePage(),
          ],
      
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(right: 15, left: 15, bottom: 30),

         child:  ClipRRect(
           borderRadius: BorderRadius.circular(40),
           child: BackdropFilter(
             filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),

             child: Container(
               height: 85,

              decoration: BoxDecoration(color:Colors.white.withValues(alpha: 0.65) ,borderRadius: BorderRadius.circular(40),
              border: Border.all(color: AppColors.white.withValues(alpha: 0.9),width: 1.5),
              boxShadow: [
                BoxShadow(color: Color(0xFF90A4AE).withValues(alpha: 0.25)
                ,blurRadius: 20,spreadRadius: 2,offset: Offset(0, 6))
              ],
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                  end: Alignment.bottomRight,

                  colors: [Color(0xFFC8D6DF).withValues(alpha: 0.75) ,Color(0xFFE2EBF0).withValues(alpha: 0.45)])
              ),


                child: Theme(
                  data: Theme.of(context).copyWith(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    splashFactory: NoSplash.splashFactory,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 5,left: 5),
                    child: BottomNavigationBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      showSelectedLabels: false,
                      selectedFontSize: 0,
                      unselectedFontSize: 0,
                      selectedItemColor: AppColors.white,
                      unselectedItemColor: AppColors.turquoise,
                      iconSize: 22,
                      items: [
                      BottomNavigationBarItem(
                        icon: CustomNavBar(label: "الاقسام", icon: LucideIcons.layoutGridCircles, isSelected: currentIndex==0),label: ""),
                      
                      
                      BottomNavigationBarItem(icon: CustomNavBar(label: "مهامي", icon:LucideIcons.listTodo, isSelected: currentIndex==1),label: ""),
                      BottomNavigationBarItem(icon: CustomNavBar(label: "حسابي", icon: LucideIcons.userRound, isSelected: currentIndex==2),label: "")
                    ],
                    onTap: (v) {
                      setState(() {
                        currentIndex = v;
                      });

                      if (v == 1) {
                        context.read<MyTaskCubit>().getMyTasks(
                              apartmentCode: state.userModel.apartmentCode,
                              day: MyTaskPage.dayKeyFor(DateTime.now()),
                              userId: state.userModel.userId,
                            );
                      }
                    },),
                  ),
                ),
              ),
           ),
         ),
         ),


      );
      },
      
    );

  }
}
