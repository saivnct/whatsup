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
import 'package:whatsup/widgets/custom_circular_progress_indicator.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const routeName = '/login-screen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final phoneController = TextEditingController();
  Country? country;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
  }

  void pickCountry() {
    showCountryPicker(
        context: context,
        useSafeArea: true,
        countryListTheme: CountryListThemeData(
          flagSize: 25,
          backgroundColor: backgroundColor,
          textStyle: Theme.of(context).textTheme.titleMedium,
          // bottomSheetHeight: 500, // Optional. Country list modal height
          //Optional. Sets the border radius for the bottomsheet.
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          //Optional. Styles the search field.
          inputDecoration: InputDecoration(
            labelText: 'Search',
            hintText: 'Start typing to search',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color:
                    Theme.of(context).colorScheme.onBackground.withOpacity(0.2),
              ),
            ),
          ),
        ),
        onSelect: (Country c) {
          setState(() {
            country = c;
          });
        });
  }

  void sendPhoneNumber() async {
    FocusScope.of(context).unfocus();
    String phoneNumber = phoneController.text.trim();
    if (country == null || phoneNumber.isEmpty) {
      showSnackBar(context: context, content: 'Fill out all the fields');
      return;
    }

    setState(() {
      _isLoading = true;
    });

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
            onSendPhoneNumberSuccess(verificationId);
          }),
          onCodeAutoRetrievalTimeout: (String verificationId) {
            onSendPhoneNumberFailed('OTP Time out, please try again', true);
          });
    } catch (e) {
      onSendPhoneNumberFailed(e.toString(), false);
    }
  }

  void onSendPhoneNumberSuccess(String verificationId) {
    setState(() {
      _isLoading = false;
    });
    Navigator.pushNamed(
      context,
      OTPScreen.routeName,
      arguments: verificationId,
    );
  }

  void onSendPhoneNumberFailed(String error, bool shouldBack) {
    setState(() {
      _isLoading = false;
    });

    showSnackBar(context: context, content: error);

    if (shouldBack) {
      Navigator.of(context).pop();
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
              _isLoading
                  ? const CustomCircularProgressIndicator()
                  : SizedBox(
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
