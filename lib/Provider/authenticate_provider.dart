import 'package:flutter/material.dart';
import 'package:shagun_resort_review/API/call_api.dart';
import 'package:shagun_resort_review/API/resource.dart';
import 'package:shagun_resort_review/Component/pop_up.dart';
import 'package:shagun_resort_review/Service/secure_storage.dart';
import 'package:shagun_resort_review/utils/app_route.dart';


class AuthProvider extends ChangeNotifier {
  bool isButtonEnabled = false;
  bool loginLoader = false;
  final api = AppApi();
  final secureStorage = SecureStorage();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  /// Button Enable/Disable Functionality
  toggleButton() {
    emailController.addListener(() {
      if(emailController.text.isNotEmpty && passwordController.text.isNotEmpty){
        isButtonEnabled = true;
        notifyListeners();
      }
      else{
        isButtonEnabled = false;
        notifyListeners();
      }
    });
    passwordController.addListener(() {
      if(emailController.text.isNotEmpty && passwordController.text.isNotEmpty){
        isButtonEnabled = true;
        notifyListeners();
      }
      else{
        isButtonEnabled = false;
        notifyListeners();
      }
    });
  }

  /// Login Functionality
  Future login(BuildContext context) async{
    Map<String, dynamic> body = {
      "email" : emailController.text,
      "password" : passwordController.text
    };
    try{
      if(emailController.text.isNotEmpty && passwordController.text.isNotEmpty){
        /// Login Api Calling
         api.loginApi(body).then((response) async {
            updateLoader(true); // show loader
           Resource resData = response as Resource;
           if(response.status == true){
             updateLoader(true);
              await secureStorage.writeSecureData('userId', resData.data['user_id']);    // insert data in local storage
              await secureStorage.writeSecureData('userToken', resData.data['token']);  // insert data in local storage
               Navigator.popAndPushNamed(context, AppScreen.bookingStatus);
               updateLoader(false);
               emailController.clear();    // clear email controller
               passwordController.clear(); // clear password controller
           } else{
             updateLoader(false); // hide loader
             popUp(context: context, title: response.message, // show popUp
             actions: [
               TextButton(
                 onPressed: () {
                   Navigator.of(context).pop();
                 },
                 child: const Text("okay"),
               ),
             ],
             );
           }
           // notifyListeners();
       });
      }
    } catch(error){
      print("Login API error $error");
      rethrow;
    }
  }

  /// Show/Hide loader functionality
  updateLoader(bool status) {
    loginLoader = status;
    notifyListeners();
  }
}
