import 'package:flutter/material.dart';

Widget tryAgain({required String errorMsg, required Function () onTap}){
  return Column(mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Center(
        child: Text(
          errorMsg,
          style: const TextStyle(color: Colors.black),
        ),
      ),
      TextButton(onPressed: onTap,
          child: const Text("try again"))
    ],
  );
}