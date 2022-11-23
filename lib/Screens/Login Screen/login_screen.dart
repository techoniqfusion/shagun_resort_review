import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shagun_resort_review/Component/custom_buttom.dart';
import 'package:shagun_resort_review/Component/textform_field.dart';
import 'package:shagun_resort_review/utils/app_color.dart';
import 'package:shagun_resort_review/utils/app_font.dart';
import 'package:shagun_resort_review/utils/app_images.dart';
import 'package:shagun_resort_review/utils/app_size.dart';
import '../../Provider/authenticate_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    Key? key,
  }) : super(key: key);
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isButtonEnabled = false;
  // show the password or not
  bool _isObscure = true;
  final provider = AuthProvider();

  @override
  void initState(){
    super.initState();
  }

  @override
  void dispose() {
    /// Dispose all controllers
    provider.emailController.dispose();
    provider.passwordController.dispose();
    super.dispose();
  }

  /// Email Validation
  String? validateEmail(String? value) {
    if (value!.isEmpty) {
      return "Required";
    } else if (!RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value)) {
      return "Please enter a valid email address";
    }
    return null;
  }

  /// Password Validation
  String? validatePass(String? value) {
    if (value!.isEmpty) {
      return "Required";
    } else if (value.length < 6) {
      return "Should at least 6 characters";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context,listen: false);
    provider.toggleButton();
    return Scaffold(
        backgroundColor: AppColor.white,
        body: SafeArea(
          child: Stack(
            // fit: StackFit.expand,
              children:[
                Align(
                  alignment: AlignmentDirectional.topCenter,
                    child: Image.asset(
                        AppImages.pool, 
                        height: AppSize.getHeight(context) * 0.35,
                        width: AppSize.getWidth(context), fit: BoxFit.cover)),
            Positioned(
              bottom: 0,
              child: Column(
                children: [
                  Container(height: 3,width: 26,
                  decoration: BoxDecoration(
                      color: AppColor.lightGrey,
                      borderRadius: BorderRadius.circular(10)),
                  ),
                  const SizedBox(height: 5,),

                  /// Login View
                  Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: formKey,
                    child: Container(
                      height: AppSize.getHeight(context) * 0.63,
                      width: AppSize.getWidth(context),
                      decoration: const BoxDecoration(
                          color: AppColor.lightGrey,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15), topRight: Radius.circular(15)
                          )),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 11),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Text("Hello Again!",style: TextStyle(fontFamily: AppFont.poppinsMedium,fontSize: 24),),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 80.0),
                              child: Text("welcome back you've been dismissed",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                fontSize: 18,fontFamily: AppFont.poppinsRegular,
                              ),),
                            ),

                            /// Username TextField
                            CustomTextFormField(
                              fillColor: AppColor.white,
                              hintText: "Enter username",
                              validator: validateEmail,
                              controller: provider.emailController,
                            ),

                            /// Password TextField
                            CustomTextFormField(
                              obscureText: _isObscure,
                              fillColor: AppColor.white,
                              hintText: "Enter password",
                              validator: validatePass,
                              controller: provider.passwordController,
                              suffixIcon: IconButton(
                                  icon: Icon(
                                    _isObscure ? Icons.visibility_off : Icons.visibility, color: AppColor.green,),
                                  onPressed: () {
                                    setState(() {
                                      _isObscure = !_isObscure;
                                    });
                                  }),
                            ),

                            /// Login Button
                            CustomButton(
                              backgroundColor: context.watch<AuthProvider>().isButtonEnabled ? MaterialStateProperty.all<Color?>(AppColor.green) : MaterialStateProperty.all<Color?>(Colors.grey.withOpacity(0.4)),
                                onPressed: context.watch<AuthProvider>().isButtonEnabled
                                    ? () {
                                  formKey.currentState!.validate();
                                  /// Login Functionality
                                  provider.login(context);
                                  // print("login loader is ${provider.loginLoader}");
                                } : null,
                                buttonText: "Login",
                              height: 57,
                              width: AppSize.getWidth(context),
                              isLoading: context.watch<AuthProvider>().loginLoader
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ])));
  }
}
