//Created by giangtpu on 08/06/2023.
//Giangbb Studio
//giangtpu@gmail.com
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsup/models/user_model.dart';
import 'package:whatsup/repository/auth/auth_repository.dart';

//Provider ref -> Interact provider with provider
//Widget ref -> Makes widget interact with provider
final authControllerProvider = Provider((ref) {
  //ref allow us to interact with other providers
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository: authRepository, ref: ref);
});

final userDataAuthProvider = FutureProvider((ref) {
  // watch method make a provider read another provider – even if the value exposed by that other provider never changes.
  final authController = ref.watch(authControllerProvider);
  return authController.getUserData();
});

class AuthController {
  final AuthRepository authRepository;
  final ProviderRef ref;
  AuthController({
    required this.authRepository,
    required this.ref,
  });

  Future<UserModel?> getUserData() async {
    UserModel? user = await authRepository.getCurrentUserData();
    return user;
  }

  Future<void> signInWithPhone({
    required String phoneNumber,
    required PhoneVerificationFailed onVerificationFailed,
    required PhoneCodeSent onCodeSent,
    required PhoneCodeAutoRetrievalTimeout onCodeAutoRetrievalTimeout,
  }) async {
    return authRepository.signInWithPhone(
        phoneNumber: phoneNumber,
        onVerificationFailed: onVerificationFailed,
        onCodeSent: onCodeSent,
        onCodeAutoRetrievalTimeout: onCodeAutoRetrievalTimeout);
  }

  Future<UserCredential> verifyOTP(
      String verificationId, String userOTP) async {
    return authRepository.verifyOTP(
      verificationId: verificationId,
      userOTP: userOTP,
    );
  }

  Future<void> saveUserDataToFirebase(String name, File? profilePic) {
    return authRepository.saveUserDataToFirebase(
      name: name,
      profilePic: profilePic,
      ref: ref,
    );
  }

  Stream<UserModel> userDataById(String userId) {
    return authRepository.userData(userId);
  }

  void setUserState(bool isOnline) {
    authRepository.setUserState(isOnline);
  }
}
