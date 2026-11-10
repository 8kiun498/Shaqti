import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shaqti/features/auth/data/user_model.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(InitialAuthState());

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool get hasCurrentUser => _auth.currentUser != null;

  String _generateCode() {
    final random = Random();

    return (1000000 + random.nextInt(900000)).toString();
  }

  Future<void> craetApartement({
    required String apartmentName,
    required String name,
    required String email,
    required String password,
  }) async {
    emit(LoadingAuthState());
    try {
      final credantial = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      final code = _generateCode();

      final userModel = UserModel(
        userId: credantial.user!.uid,
        name: name,
        apartmentName: apartmentName,
        email: email,
        apartmentCode: code,
        isAdmin: true,
      );

      await _firestore
          .collection("users")
          .doc(userModel.userId)
          .set(userModel.toJson());

      emit(SuccessAuthState(userModel: userModel));
    } on FirebaseAuthException catch (e) {
      emit(ErrorAuthState(message: e.message ?? 'حدث خطأ في التسجيل دخول'));
    } catch (e) {
      emit(ErrorAuthState(message: 'حدث خطأ غير متوقع، حاول مرة أخرى'));
    }
  }

  Future<void> joinApartment({
    required String name,
    required String email,
    required String password,
    required String apartmentCode,
  }) async {
    emit(LoadingAuthState());
    try {
      final quary = await _firestore
          .collection("users")
          .where("apartmentCode", isEqualTo: apartmentCode.trim())
          .where("isAdmin", isEqualTo: true)
          .limit(1)
          .get();

      if (quary.docs.isEmpty) {
        emit(ErrorAuthState(message: "رمز الشقة غير صحيح"));
        return;
      }

      final apartementName = quary.docs.first.data()["apartmentName"] ?? " ";

      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final userModel = UserModel(
        userId: credential.user!.uid,
        name: name.trim(),
        email: email.trim(),
        apartmentName: apartementName,
        apartmentCode: apartmentCode.trim(),
        isAdmin: false,
      );

      await _firestore
          .collection('users')
          .doc(userModel.userId)
          .set(userModel.toJson());

      emit(SuccessAuthState(userModel: userModel));
    } on FirebaseAuthException catch (e) {
      emit(ErrorAuthState(message: (e.code)));
    } catch (e) {

      emit(ErrorAuthState(message: "حدث خطأ غير متوقع، حاول مرة أخرى"));
    }
  }

  Future<void> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    emit(LoadingAuthState());

    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final uid = credential.user?.uid;
      if (uid == null) {
        emit(ErrorAuthState(message: 'تعذّر تسجيل الدخول'));
        return;
      }

      final doc = await _firestore.collection('users').doc(uid).get();
      final data = doc.data();
      if (data == null) {
        emit(ErrorAuthState(message: 'بيانات المستخدم غير موجودة'));
        return;
      }

      emit(SuccessAuthState(userModel: UserModel.fromJson(data)));
    } on FirebaseAuthException catch (e) {
      emit(ErrorAuthState(message: e.message ?? 'تعذّر تسجيل الدخول'));
    } catch (_) {
      emit(ErrorAuthState(message: 'حدث خطأ غير متوقع، حاول مرة أخرى'));
    }
  }

  Future<void> loginWithGoogle() async {
    emit(LoadingAuthState());

    try {
      final googleUser = await GoogleSignIn.instance.authenticate();
      final googleCredential = GoogleAuthProvider.credential(
        idToken: googleUser.authentication.idToken,
      );

      final result = await _auth.signInWithCredential(googleCredential);
      final doc = await _firestore
          .collection('users')
          .doc(result.user!.uid)
          .get();

      final userModel = UserModel.fromJson(doc.data()!);
      emit(SuccessAuthState(userModel: userModel));
    } catch (_) {
      emit(ErrorAuthState(message: 'فشل تسجيل الدخول بواسطة Google'));
    }
  }

  Future<void> loadCurrentUser() async {
    final user = _auth.currentUser;

    if (user == null) {
      emit(InitialAuthState());
      return;
    }

    emit(LoadingAuthState());

    try {
      final doc = await _firestore.collection('users').doc(user.uid).get();

      final data = doc.data();

      if (data == null) {
        emit(ErrorAuthState(message: 'بيانات المستخدم غير موجودة'));
        return;
      }

      final userModel = UserModel.fromJson(data);

      emit(SuccessAuthState(userModel: userModel));
    } catch (e) {
      emit(ErrorAuthState(message: 'تعذّر تحميل بيانات المستخدم'));
    }
  }



  Future<void> signOut() async {
    emit(LoadingAuthState());

    try {
      await _auth.signOut();
      await GoogleSignIn.instance.signOut();
      emit(InitialAuthState());
    } catch (_) {
      emit(ErrorAuthState(message: 'تعذّر تسجيل الخروج، حاول مرة أخرى'));
    }
  }
}
