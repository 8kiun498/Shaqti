import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pro_dialog/pro_dialog.dart';
import 'package:shaqti/core/shared/custom_success_snack.dart';
import 'package:shaqti/core/shared/custom_text.dart';
import 'package:shaqti/core/theme/app_colors.dart';
import 'package:shaqti/features/rules/cubit/rule_cubit.dart';
import 'package:shaqti/features/rules/cubit/rule_state.dart';

import '../../auth/cubit/auth_cubit.dart';
import '../../auth/cubit/auth_state.dart';

class RulesPage extends StatefulWidget {

  final String apartmentCode;

  const RulesPage({super.key, required this.apartmentCode});
  @override
  State<RulesPage> createState() => _RulesPageState();
}

class _RulesPageState extends State<RulesPage> {



  final _ruleController = TextEditingController();

  @override
  void dispose() {
    _ruleController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    context.read<RuleCubit>().getRules(widget.apartmentCode);

  }
  @override
  Widget build(BuildContext context) {

    final userModel = (context.read<AuthCubit>().state as SuccessAuthState).userModel;
    return

    Scaffold(
            backgroundColor: AppColors.white,
            appBar: AppBar(
              centerTitle: true,
              title: CustomText(text: "قوانين الشقة", size: 16),
              backgroundColor: AppColors.turquoise,
            ),

     bottomNavigationBar: userModel.isAdmin ? Padding(
          padding: const EdgeInsets.all(16),
          child: SafeArea(
            child:  ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.turquoise,
                foregroundColor: AppColors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: AppColors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  builder: (sheetContext) {
                    return Padding(
                      padding: EdgeInsets.fromLTRB(
                        20,
                        24,
                        20,
                        20 + MediaQuery.of(sheetContext).viewInsets.bottom,
                      ),
                      child: SafeArea(
                        top: false,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'إضافة قانون',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextField(
                              controller: _ruleController,
                              minLines: 3,
                              maxLines: 5,
                              textDirection: TextDirection.rtl,
                              decoration: InputDecoration(
                                hintText: 'اكتب قانون الشقة…',
                                filled: true,
                                fillColor: AppColors.turquoise.withAlpha(15),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.turquoise,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                final text = _ruleController.text.trim();
                                if (text.isEmpty) return;

                                final cubit = context.read<RuleCubit>();
                                final state = cubit.state;

                                if (state is! SuccessRuleState) return;

                                int nextOrder = 1;

                                for (final rule in state.getRules) {
                                  if (rule.order >= nextOrder) {
                                    nextOrder = rule.order + 1;
                                  }
                                }
                                Navigator.pop(sheetContext);

                                cubit.saveRules(
                                  apartmentCode: widget.apartmentCode,
                                  text: text,
                                  order: nextOrder,
                                );

                                _ruleController.clear();
                              },
                              child: const Text('إضافة'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              label: const Text('إضافة قانون'),
              icon: const Icon(Icons.add),

            ),
          ),
        ) : null


    ,body:  BlocConsumer<RuleCubit, RuleState>(
      listener: (context, state) {
        if (state is SavedRuleState) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(customSuccessSnack("تم الحفظ بنجاح"));
        }
      },
      builder: (context, state) {
        if (state is LoadingRuleState) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.turquoise),
          );
        }

        if (state is ErrorRuleState) {
          return Center(
            child: CustomText(
              text: state.message,
              size: 22,
              color: AppColors.turquoise,
            ),
          );
        }

        if (state is SuccessRuleState) {



          final rules = state.getRules;


          if(rules.isEmpty) {
            return  Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset("assets/empty.svg", height: 100),
                  const SizedBox(height: 10),
                  CustomText(
                    text: "لم تضع قوانين بعد",
                    size: 18,
                    color: AppColors.black,
                  ),
                ],
              ),
            );
          }






         return   Column(
              children: [


                Expanded(
                  child: ListView.builder(
                    itemCount: rules.length,
                    itemBuilder: (context, index) {
                      final rule = rules[index];
                      return Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          children: [
                            GestureDetector(
                              onLongPress: userModel.isAdmin? () {
                                showProDialog(
                                  context,
                                  type: DialogType.warning,
                                  title: "تحذير",
                                  description: "هل انت متاكد من حذف القانون",
                                  barrierDismissible: false,
                                  buttons: [
                                    DialogButton(
                                      text: "الغاء",
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                    DialogButton(
                                      text: "نعم",
                                      onPressed: () {
                                        context.read<RuleCubit>().deleteRules(apartmentCode: widget.apartmentCode, ruleId: rule.id);
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                );
                              } : null,
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(15),
                                constraints: BoxConstraints(minHeight: 90),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: AppColors.turquoise.withAlpha(30),
                                  border: Border.all(color: AppColors.turquoise),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          color: AppColors.turquoise.withAlpha(30),
                                        ),
                                        child: Icon(
                                          Icons.error_outline,
                                          color: AppColors.turquoise,
                                          size: 25,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: CustomText(text: "${index+1 } : ${rule.text}", size: 16),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
         );


          }
        return SizedBox.shrink();
      },
    )
          );


  }
}

