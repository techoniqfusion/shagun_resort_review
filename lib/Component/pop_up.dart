import 'package:flutter/material.dart';

Future popUp({required BuildContext context, required String title,
  List<Widget>? actions
}){
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Center(child: Text(title)),
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