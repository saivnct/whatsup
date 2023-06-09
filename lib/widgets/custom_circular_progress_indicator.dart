//Created by giangtpu on 25/05/2023.
//Giangbb Studio
//giangtpu@gmail.com
import 'package:flutter/material.dart';
import 'package:whatsup/utils/colors.dart';

class CustomCircularProgressIndicator extends StatelessWidget {
  const CustomCircularProgressIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator(
      color: tabColor,
    );
  }
}
