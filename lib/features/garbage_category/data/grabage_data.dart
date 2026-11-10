import 'package:cloud_firestore/cloud_firestore.dart';

class GrabageData {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<void> saveGarbage({
    required String apartementCode,
    required String day,
    required String mamberId,
  }) async {
    await _firestore
        .collection("garbage_schadules")
        .doc(apartementCode)
        .collection("day")
        .doc(day)
        .set({"mamberId": mamberId});
  }

  Future<String?> getCarbage({
    required String apartementCode,
    required String day,
  }) async {
    final result = await _firestore
        .collection("garbage_schadules")
        .doc(apartementCode)
        .collection("day")
        .doc(day)
        .get();
    return result.data()?["mamberId"] as String?;
  }
}
