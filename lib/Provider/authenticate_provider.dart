import 'package:flutter/material.dart';
import 'package:shagun_resort_review/API/call_api.dart';
import 'package:shagun_resort_review/API/resource.dart';
import 'package:shagun_resort_review/Component/pop_up.dart';
import 'package:shagun_resort_review/utils/app_route.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool isButtonEnabled = false;
  bool isChecked = false;
  bool loginLoader = false;
  final api = AppApi();

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
               final prefs = await SharedPreferences.getInstance();
               await prefs.setBool('isLoggedIn', true);
               await prefs.setString('userId', resData.data['user_id']);
               await prefs.setString('userToken', resData.data['token']);
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

  /// Logout User
  Future logOutUser()async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
  }

  /// Show/Hide loader functionality
  updateLoader(bool status) {
    loginLoader = status;
    notifyListeners();
  }
}
