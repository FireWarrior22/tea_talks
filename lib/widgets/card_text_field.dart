import 'package:flutter/material.dart';
import 'package:tea_talks/utility/ui_constants.dart';

class CardTextField extends StatelessWidget {
  const CardTextField({
    required this.controller,
    required this.labelText,
    required this.keyboardType,
    required this.iconData,
    required this.obscureText,
  });

  final TextEditingController controller;
  final String labelText;
  final TextInputType keyboardType;
  final IconData iconData;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5.0,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: TextField(
          obscureText: obscureText,
          keyboardType: keyboardType,
          style: kLabelTextStyle,
          controller: controller,
          decoration: InputDecoration(
            icon: Icon(iconData, color: kSteelBlue),
            labelText: labelText,
            labelStyle: kLightLabelTextStyle.copyWith(color: kSteelBlue),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
