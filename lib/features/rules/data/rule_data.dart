import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shaqti/features/auth/data/user_model.dart';
import 'package:shaqti/features/rules/data/rule_model.dart';

class RuleData {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<void> saveRules (
      {required String apartmentCode ,
        required String text, required int order})  async{

         await _firestore.collection("rules").doc(apartmentCode)
             .collection("items").doc().set({"text" : text, "order" :order});
  }

  Future<void> deleteRules (
      {required String apartmentCode ,
        required String ruleId})  async{

    await _firestore.collection("rules").doc(apartmentCode)
        .collection("items").doc(ruleId).delete();
  }

  Future<List<RuleModel>> getRules(String apartmentCode) async {
    final result = await _firestore
        .collection("rules")
        .doc(apartmentCode)
        .collection("items").orderBy("order")
        .get();

    return result.docs
        .map((doc) => RuleModel.fromMap(doc.data(), doc.id))
        .toList();
  }

}