//Created by giangtpu on 08/06/2023.
//Giangbb Studio
//giangtpu@gmail.com
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsup/models/user_model.dart';
import 'package:whatsup/repository/firebase/firebase_storage_repository.dart';
import 'package:whatsup/utils/constant.dart';

//Provider ref -> Interact provider with provider
//Widget ref -> Makes widget interact with provider
final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    firebaseAuth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  ),
);

class AuthRepository {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  AuthRepository({
    required this.firebaseAuth,
    required this.firestore,
  });

  Future<UserModel?> getCurrentUserData() async {
    var userData = await firestore
        .collection(Constants.collectionUsers)
        .doc(firebaseAuth.currentUser?.uid)
        .get();

    UserModel? user;
    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
    }
    return user;
  }

  Future<void> signInWithPhone({
    required String phoneNumber,
    required PhoneVerificationFailed onVerificationFailed,
    required PhoneCodeSent onCodeSent,
    required PhoneCodeAutoRetrievalTimeout onCodeAutoRetrievalTimeout,
  }) async {
    await firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await firebaseAuth.signInWithCredential(credential);
      },
      verificationFailed: onVerificationFailed,
      codeSent: onCodeSent,
      codeAutoRetrievalTimeout: onCodeAutoRetrievalTimeout,
    );
  }

  Future<UserCredential> verifyOTP({
    required String verificationId,
    required String userOTP,
  }) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: userOTP,
    );
    UserCredential userCredential =
        await firebaseAuth.signInWithCredential(credential);
    return userCredential;
  }

  Future<void> saveUserDataToFirebase({
    required String name,
    required File? profilePic,
    required ProviderRef ref,
  }) async {
    String uid = firebaseAuth.currentUser!.uid;
    String? photoUrl;

    if (profilePic != null) {
      photoUrl =
          await ref.read(firebaseStorageRepositoryProvider).storeFileToFirebase(
                '${Constants.storageAvatar}/$uid',
                profilePic,
              );
    }

    var user = UserModel(
      name: name,
      uid: uid,
      profilePic: photoUrl,
      isOnline: true,
      phoneNumber: firebaseAuth.currentUser!.phoneNumber!,
      groupId: [],
    );

    await firestore
        .collection(Constants.collectionUsers)
        .doc(uid)
        .set(user.toMap());
  }

  Stream<UserModel> userData(String userId) {
    return firestore
        .collection(Constants.collectionUsers)
        .doc(userId)
        .snapshots()
        .map(
          (event) => UserModel.fromMap(
            event.data()!,
          ),
        );
  }

  void setUserState(bool isOnline) async {
    await firestore
        .collection(Constants.collectionUsers)
        .doc(firebaseAuth.currentUser!.uid)
        .update({
      UserModel.fieldIsOnline: isOnline,
    });
  }
}
