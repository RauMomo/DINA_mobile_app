import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/shared/shared.dart';
import 'package:get/get.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String labelText;
  final String placeholder;
  final Color color;
  final double fontSize;
  final bool password;
  final String? Function(String?)? validator;

  InputField({
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.labelText = '',
    this.placeholder = '',
    this.color = Colors.white,
    this.fontSize = 22.0,
    this.password = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          this.labelText + ':',
          style: Get.textTheme.bodyLarge!
              .copyWith(color: Colors.white, fontWeight: FontWeight.w400),
        ),
        CommonWidget.rowHeight(height: context.isTablet ? 24 : 12),
        TextFormField(
          decoration: InputDecoration(
            fillColor: ColorConstants.bgInputColor,
            // fillColor: ColorConstants.bgInputColor,
            contentPadding: EdgeInsets.symmetric(vertical: 10.0),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100),
              borderSide: BorderSide(width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100),
              borderSide: BorderSide(width: 1),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            focusColor: ColorConstants.bgInputColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100),
              borderSide: BorderSide(width: 1),
            ),
            filled: true,
            isDense: true,
          ),
          controller: this.controller,
          style: TextStyle(
            color: color,
            fontSize: fontSize,
            fontWeight: FontWeight.normal,
          ),
          enabled: true,
          keyboardType: this.keyboardType,
          obscureText: this.password,
          autocorrect: false,
          validator: this.validator,
        )
      ],
    );
  }
}
