import 'package:flutter/material.dart';

Future popUp({required BuildContext context, required String title,
  List<Widget>? actions
}){
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title,textAlign: TextAlign.center,),
      actions: actions
      // <Widget>[
      //   TextButton(
      //     onPressed: () {
      //       Navigator.of(context).pop();
      //     },
      //     child: const Text("okay"),
      //   ),
      // ],
    ),
  );
}