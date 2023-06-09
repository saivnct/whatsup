//Created by giangtpu on 08/06/2023.
//Giangbb Studio
//giangtpu@gmail.com
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsup/controllers/auth/auth_controller.dart';
import 'package:whatsup/screens/mobile_layout_screen.dart';
import 'package:whatsup/utils/colors.dart';
import 'package:whatsup/utils/utils.dart';
import 'package:whatsup/widgets/auth/user_image_picker.dart';

class UserInformationScreen extends ConsumerStatefulWidget {
  static const String routeName = '/user-information';
  const UserInformationScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<UserInformationScreen> createState() =>
      _UserInformationScreenState();
}

class _UserInformationScreenState extends ConsumerState<UserInformationScreen> {
  final TextEditingController nameController = TextEditingController();
  File? image;

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  void _onSelectedImage(File imageFile) async {
    image = imageFile;
  }

  void storeUserData() async {
    String name = nameController.text.trim();
    if (name.isEmpty) {
      showSnackBar(context: context, content: 'Please enter your name');
      return;
    }

    try {
      await ref
          .read(authControllerProvider)
          .saveUserDataToFirebase(name, image);

      if (!context.mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const MobileLayoutScreen(),
        ),
        (route) => false,
      );
    } catch (e) {
      print(e);
      showSnackBar(context: context, content: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting up your profile'),
        elevation: 0,
        backgroundColor: backgroundColor,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              UserImagePicker(
                onSelectedImage: _onSelectedImage,
              ),
              Row(
                children: [
                  Container(
                    width: size.width * 0.85,
                    padding: const EdgeInsets.all(20),
                    child: TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        hintText: 'Please enter your name',
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: storeUserData,
                    icon: const Icon(
                      Icons.done,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
