import 'package:flutter/material.dart';
import 'package:shagun_resort_review/utils/app_font.dart';
import '../utils/app_color.dart';

class CustomTextFormField extends StatelessWidget {
  final Color? cursorColor;
  final String?Function(String?)?validator;
  final TextEditingController? controller;
  final InputDecoration? decoration;
  final bool obscureText;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final InputBorder? border;
  final Color? fillColor;
  final Widget? suffixIcon;
  final String? labelText;
  final String? hintText;
  final TextStyle? labelStyle;
   const CustomTextFormField({Key? key,
     this.focusedBorder,
     this.cursorColor,
     this.validator,
     this.controller,
     this.decoration,
     this.obscureText = false,
     this.enabledBorder,
     this.border,
     this.fillColor,
     this.suffixIcon,
     this.labelText, this.labelStyle, this.hintText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      cursorColor: cursorColor,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 27, top: 22, bottom: 22),
        hintText: hintText,
          hintStyle: TextStyle(fontSize: 14, fontFamily: AppFont.poppinsMedium),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.red,),
          ),
        labelStyle: TextStyle(fontSize: 14, fontFamily: AppFont.poppinsMedium),
        labelText: labelText,
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 5.0),
          child: suffixIcon,
        ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Colors.red,),
              ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: AppColor.white,),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: AppColor.white,),
        ),
        filled: true,
        fillColor: fillColor,
        border: OutlineInputBorder(),
      ),
    );
  }
}
