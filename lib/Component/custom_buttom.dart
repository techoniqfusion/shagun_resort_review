import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils/app_color.dart';
import '../utils/app_font.dart';

class CustomButton extends StatelessWidget {
  final MaterialStateProperty<Color?>? backgroundColor;
  final MaterialStateProperty<Color?>? foregroundColor;
  final void Function()? onPressed;
  final double? height;
  final double? width;
  final String buttonText;
  final Color? textColor;
  final bool isLoading;
  const CustomButton(
      {Key? key,
      this.backgroundColor,
      this.onPressed,
      this.height,
      this.isLoading = false,
      this.width,
      required this.buttonText,
      this.textColor = AppColor.white, this.foregroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    return ElevatedButton(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all<double?>(0),
        backgroundColor: backgroundColor,
         foregroundColor: foregroundColor,
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
      ),
      onPressed: !isLoading ? onPressed : null,
      child: Container(
        height: height,
        width: width,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: isLoading
              ? const CupertinoActivityIndicator(radius: 15, color: AppColor.white,
            // color: !bgReverse ? Colors.white : color
          )
              : Text(
            buttonText,
            style: TextStyle(
                color: textColor,
                fontSize: 14,
                fontFamily: AppFont.poppinsRegular),
          ),
        ),
      ),
    );
  }
}
