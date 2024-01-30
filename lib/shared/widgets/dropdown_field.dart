import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/shared/constants/colors.dart';
import 'package:flutter_getx_boilerplate/shared/utils/common_widget.dart';
import 'package:get/get.dart';

class DropdownField extends StatelessWidget {
  final TextInputType keyboardType;
  final String labelText;
  final String placeholder;
  final Color color;
  final String? dropdownValue;
  final Color? bgInputColor;
  final void Function(String?)? onChanged;

  DropdownField({
    this.keyboardType = TextInputType.text,
    this.labelText = '',
    this.placeholder = '',
    this.color = Colors.white,
    required this.dropdownValue,
    this.bgInputColor = ColorConstants.bgInputColor,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (this.labelText.isNotEmpty)
          Text(
            this.labelText + ':',
            style: Get.textTheme.bodyLarge!
                .copyWith(color: Colors.white, fontWeight: FontWeight.w400),
          ),
        CommonWidget.rowHeight(height: context.isTablet ? 24 : 12),
        Material(
          color: Colors.white,
          child: DropdownButton<String>(
            padding: EdgeInsets.symmetric(horizontal: 16),
            underline: SizedBox.shrink(),
            menuMaxHeight: 200,
            isExpanded: true,
            items: [
              DropdownMenuItem(
                value: 'Operator',
                child: Text('Operator'),
              ),
              DropdownMenuItem(
                value: 'Client',
                child: Text('Client'),
              ),
            ],
            value: dropdownValue!,
            onChanged: (value) {
              onChanged!.call(value);
            },
          ),
        ),
        SizedBox(
          height: 16,
        ),
        // TextFormField(
        //   decoration: InputDecoration(
        //     fillColor: bgInputColor!.withOpacity(0.75),
        //     // fillColor: ColorConstants.bgInputColor,
        //     contentPadding:
        //         EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        //     focusedBorder: OutlineInputBorder(
        //       borderRadius: BorderRadius.circular(100),
        //       borderSide: BorderSide(width: 1),
        //     ),
        //     enabledBorder: OutlineInputBorder(
        //       borderRadius: BorderRadius.circular(100),
        //       borderSide: BorderSide(width: 1),
        //     ),
        //     hintText: this.placeholder,
        //     floatingLabelBehavior: FloatingLabelBehavior.never,
        //     focusColor: ColorConstants.bgInputColor,
        //     border: OutlineInputBorder(
        //       borderRadius: BorderRadius.circular(100),
        //       borderSide: BorderSide(width: 1),
        //     ),
        //     filled: true,
        //     isDense: true,
        //   ),
        //   controller: this.controller,
        //   style: TextStyle(
        //     color: color,
        //     fontSize: fontSize,
        //     fontWeight: FontWeight.normal,
        //   ),
        //   enabled: true,
        //   keyboardType: this.keyboardType,
        //   obscureText: this.password,
        //   autocorrect: false,
        //   validator: this.validator,
        // )
      ],
    );
  }
}
