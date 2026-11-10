import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shaqti/features/auth/data/user_model.dart';

class WaterCategoryData {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveWater({
    required String apartementCode,
    required String day,
    required String mamberId,
  }) async {
    await _firestore
        .collection("water_schadule")
        .doc(apartementCode)
        .collection("day")
        .doc(day)
        .set({"mamberId": mamberId});
  }

  Future<String?> getWaterByDay({
    required String day,
  
    required String apartementcode,
  }) async {
    final result = await _firestore
        .collection("water_schadule")
        .doc(apartementcode)
        .collection("day")
        .doc(day)
        .get();
    return result.data()?["mamberId"] as String?;
  }
}
