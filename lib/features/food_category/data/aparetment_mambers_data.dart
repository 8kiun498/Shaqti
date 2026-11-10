import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shaqti/features/auth/data/user_model.dart';

class ApartmentMembersData {
  Future<List<UserModel>> getMembers(String apartmentCode) async {
    final result = await FirebaseFirestore.instance
        .collection('users')
        .where('apartmentCode', isEqualTo: apartmentCode.trim())
        .get();

    return result.docs
        .map((doc) => UserModel.fromJson(doc.data()))
        .toList();
  }




Future<Map<String, dynamic>> getDaySchedule({
  required String apartmentCode,
  required String day,
}) async {
  final doc = await FirebaseFirestore.instance
      .collection('food_schedules')
      .doc(apartmentCode)
      .collection('days')
      .doc(day)
      .get();

  return doc.data() ?? {};
}



Future<void> saveDayMeals({
  required String apartmentCode,
  required String day,
  required String lunchId,
  required String dinnerId,
}) async {
  await FirebaseFirestore.instance
      .collection('food_schedules')
      .doc(apartmentCode)
      .collection('days')
      .doc(day)
      .set({
        'lunch': lunchId,
        'dinner': dinnerId,
      }, SetOptions(merge: true));
}
}