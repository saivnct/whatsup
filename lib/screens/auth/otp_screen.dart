//Created by giangtpu on 08/06/2023.
//Giangbb Studio
//giangtpu@gmail.com
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsup/controllers/auth/auth_controller.dart';
import 'package:whatsup/screens/auth/user_information_screen.dart';
import 'package:whatsup/utils/colors.dart';
import 'package:whatsup/utils/utils.dart';
import 'package:whatsup/widgets/custom_circular_progress_indicator.dart';

class OTPScreen extends ConsumerStatefulWidget {
  static const String routeName = '/otp-screen';
  final String verificationId;

  const OTPScreen({
    Key? key,
    required this.verificationId,
  }) : super(key: key);

  @override
  ConsumerState<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends ConsumerState<OTPScreen> {
  bool _isLoading = false;

  void verifyOTP(WidgetRef ref, BuildContext context, String userOTP) async {
    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
    });

    try {
      await ref.read(authControllerProvider).verifyOTP(
            widget.verificationId,
            userOTP,
          );

      if (!context.mounted) return;

      //push and cannot go back
      Navigator.pushNamedAndRemoveUntil(
        context,
        UserInformationScreen.routeName,
        (route) => false,
      );

      return;
    } on FirebaseAuthException catch (e) {
      print(e.code);
      showSnackBar(
        context: context,
        content: 'Error ${e.code} - ${e.message!}',
      );

      if (e.code == 'session-expired') {
        Navigator.pop(context);
        return;
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verifying your number'),
        elevation: 0,
        backgroundColor: backgroundColor,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text('We have sent an SMS with a code.'),
            SizedBox(
              width: size.width * 0.5,
              child: TextField(
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  hintText: '- - - - - -',
                  hintStyle: TextStyle(
                    fontSize: 30,
                  ),
                ),
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  if (val.length == 6) {
                    verifyOTP(ref, context, val.trim());
                  }
                },
              ),
            ),
            if (_isLoading)
              Column(
                children: const [
                  SizedBox(height: 20),
                  CustomCircularProgressIndicator(),
                ],
              )
          ],
        ),
      ),
    );
  }
}
