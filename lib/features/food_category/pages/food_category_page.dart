import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shaqti/core/enums/meal_day.dart';
import 'package:shaqti/core/shared/custom_snack.dart';
import 'package:shaqti/core/shared/custom_success_snack.dart';
import 'package:shaqti/core/shared/custom_text.dart';
import 'package:shaqti/core/theme/app_colors.dart';
import 'package:shaqti/features/auth/cubit/auth_cubit.dart';
import 'package:shaqti/features/auth/cubit/auth_state.dart';
import 'package:shaqti/features/food_category/cubit/food_cubit.dart';
import 'package:shaqti/features/food_category/cubit/food_state.dart';
import 'package:shaqti/features/food_category/widgets/food_card.dart';
import '../../../core/enums/week_day.dart';


class FoodCategoryPage extends StatefulWidget {
  const FoodCategoryPage({super.key});

  @override
  State<FoodCategoryPage> createState() => _FoodCategoryPageState();
}

class _FoodCategoryPageState extends State<FoodCategoryPage> {


@override
  void initState() {

     super.initState();

     
    final authState = context.read<AuthCubit>().state;

if (authState is SuccessAuthState) {
  final code = authState.userModel.apartmentCode;
  context.read<FoodCubit>().getMembers(code);
}
   
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(color: AppColors.white),
          title: Text("جدول الطعام", style: TextStyle(color: AppColors.white),),
          centerTitle: true,
          backgroundColor: AppColors.turquoise,),
        body: BlocListener<FoodCubit,FoodState>(
  listener: (context, state) {
    if (state is! FoodMembersLoaded) return;

    if (state.saveSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        customSuccessSnack("تم الحفظ بنجاح"),
      );
    } else if (state.saveError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        customSnack(state.saveError!),
      );
    }
  },
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Container(
                    width: double.infinity,height: 200,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),
                        color: AppColors.turquoise.withAlpha(30)
                        ,border: Border.all(color: AppColors.turquoise)),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
          
                          Container(
                              margin: EdgeInsets.only(left: 10),
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: AppColors.turquoise.withAlpha(30)),
                              child: Icon(Icons.error_outline, color: AppColors.turquoise,size: 25,)),
                          Expanded(child: Column(
                            children: [
                              CustomText(text: "1 - الخميس والجمعة والسبت يكون الجدول بالاتفاق مع الموجودين بالشقة فقط . "
                                , size: 14, color: Colors.black,),
                              CustomText(text: "2 - الشخص الي يسوي الوجبة نفسة الي يسوي الشاي . ", size: 14),
                              CustomText(text: " 3 - غسل المواعين يكون على الشخص المرافق بالجدول .", size: 14)
                            ],
                          ))
                        ],
                      ),
                    ),
          
                  ),
                ),
                SizedBox(
          
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 1,);
                    },
                    itemCount: WeekDay.values.length,
                    itemBuilder: (context, index) {
                      return FoodCard(weekDay: WeekDay.values[index].day,
                          lunch: MealDay.lunch.meal,
                          dinner: MealDay.dinner.meal,
                      );
                    },
                  ),
          
                ),
          
          
              ],
            ),
          ),
        ),

        
    );
  }
}
