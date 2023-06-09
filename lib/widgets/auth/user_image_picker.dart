//Created by giangtpu on 25/05/2023.
//Giangbb Studio
//giangtpu@gmail.com
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsup/utils/constant.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key, required this.onSelectedImage});

  final void Function(File imageFile) onSelectedImage;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage;

  void _pickImage() async {
    final pickImage = await ImagePicker().pickImage(
        source: ImageSource.gallery, imageQuality: 50, maxWidth: 150);

    if (pickImage == null) {
      return;
    }

    setState(() {
      _pickedImage = File(pickImage.path);
    });

    widget.onSelectedImage(_pickedImage!);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: Stack(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage: Constants.avatarPlaceHolder,
            backgroundColor: Colors.black,
            foregroundImage:
                _pickedImage != null ? FileImage(_pickedImage!) : null,
          ),
          const Positioned(
            bottom: 0,
            right: 10,
            child: Icon(Icons.add_a_photo),
          ),
        ],
      ),
    );
  }
}
