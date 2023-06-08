//Created by giangtpu on 08/06/2023.
//Giangbb Studio
//giangtpu@gmail.com
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsup/controllers/auth/auth_controller.dart';
import 'package:whatsup/screens/auth/otp_screen.dart';
import 'package:whatsup/utils/colors.dart';
import 'package:whatsup/utils/utils.dart';
import 'package:whatsup/widgets/custom_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const routeName = '/login-screen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final phoneController = TextEditingController();
  Country? country;

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
  }

  void pickCountry() {
    showCountryPicker(
        context: context,
        onSelect: (Country c) {
          setState(() {
            country = c;
          });
        });
  }

  void sendPhoneNumber() async {
    String phoneNumber = phoneController.text.trim();
    if (country == null || phoneNumber.isEmpty) {
      showSnackBar(context: context, content: 'Fill out all the fields');
      return;
    }

    try {
      //Provider ref -> Interact provider with provider
      //Widget ref -> Makes widget interact with provider

      //we use read here because it's just one time thing. We dont need to continously take look at it and see if there is any changes over there
      ref.read(authControllerProvider).signInWithPhone(
          phoneNumber: '+${country!.phoneCode}$phoneNumber',
          onVerificationFailed: (e) {
            throw Exception(e.message);
          },
          onCodeSent: ((String verificationId, int? resendToken) async {
            Navigator.pushNamed(
              context,
              OTPScreen.routeName,
              arguments: verificationId,
            );
          }),
          onCodeAutoRetrievalTimeout: (String verificationId) {
            showSnackBar(
              context: context,
              content: 'OTP Time out, please try again',
            );

            Navigator.of(context).pop();
          });
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter your phone number'),
        elevation: 0,
        backgroundColor: backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('WhatsUp will need to verify your phone number.'),
              const SizedBox(height: 10),
              TextButton(
                onPressed: pickCountry,
                child: const Text('Pick Country'),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  if (country != null)
                    Text('+${country!.phoneCode}')
                  else
                    const Text('+XXX'),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: size.width * 0.7,
                    child: TextField(
                      controller: phoneController,
                      decoration: const InputDecoration(
                        hintText: 'phone number',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.6),
              SizedBox(
                width: 90,
                child: CustomButton(
                  onPressed: sendPhoneNumber,
                  text: 'NEXT',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
