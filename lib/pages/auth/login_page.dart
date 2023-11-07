import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lost_and_found_app_staff/utils/app_assets.dart';
import 'package:lost_and_found_app_staff/utils/app_layout.dart';
import 'package:lost_and_found_app_staff/utils/colors.dart';
import 'package:lost_and_found_app_staff/widgets/app_text_field.dart';
import 'package:lost_and_found_app_staff/widgets/app_text_filed_title.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../widgets/app_button.dart';
import '../../../widgets/app_button_upload_image.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../utils/snackbar_utils.dart';
import '../../widgets/app_text_field_title_password.dart';
import '../home/home_page.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();


  Future<void> loginEmailPassword() async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text
      );
      SnackbarUtils().showSuccess(title: "Successs", message: "Login successfully");
      final user = await FirebaseAuth.instance.currentUser!;
      final idTokenUser = await user.getIdToken();
      print("id Token User: " + idTokenUser.toString());
      if (idTokenUser != null && idTokenUser.length > 1000) {
        print(idTokenUser.substring(1000));
      } else {
        print("String is too short to perform the second substring.");
      }
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', idTokenUser.toString());
      await prefs.setString('uid', user.uid);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        SnackbarUtils().showError(title: "Wrong email", message: "No user found for that email.");

      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        SnackbarUtils().showError(title: "Wrong password", message: "Wrong password provided for that user.");
      }
    }
  }

  Future<void> logout() async {

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Gap(AppLayout.getHeight(100)),
            Container(
              alignment: Alignment.center,
              child: Text(
                "Log In",
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ),
            Gap(AppLayout.getHeight(40)),
/*          Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 20),
              child: Text("NAME",
                  style: TextStyle(
                      fontSize: 20,
                      color: AppColors.titleColor,
                      fontWeight: FontWeight.bold)),
            ),
            Gap(AppLayout.getHeight(20)),
            AppTextField(textController: emailController, hintText: "")*/
            AppTextFieldTitle(
                textController: emailController,
                hintText: "",
                titleText: "EMAIL",
              validator: 'Please input email',
            ),
            Gap(AppLayout.getHeight(40)),
            AppTextFieldTitlePassword(
                textController: passwordController,
                hintText: "",
                titleText: "PASSWORD",
              validator: 'Please input password',
            ),
            Gap(AppLayout.getHeight(40)),
            Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 15),
              child: Text(
                "Forgot password?",
                style: TextStyle(
                    fontSize: 20,
                    color: AppColors.secondPrimaryColor),
              ),
            ),
            Gap(AppLayout.getHeight(40)),
            AppButtonUpLoadImage(
                boxColor: AppColors.primaryColor,
                textButton: "Log In",
                onTap: () {
                  loginEmailPassword();
                }),
            Gap(AppLayout.getHeight(40)),
            GestureDetector(
              onTap: () {
              },
              child: RichText(
                text: TextSpan(
                    text: "Don’t have an account?",
                    style: TextStyle(
                        fontSize: 20,
                        color: AppColors.titleLSColor),
                    children: [
                      TextSpan(
                          text: " Sign up",
                          style: TextStyle(
                              fontSize: 20,
                              color: AppColors.secondPrimaryColor,
                              fontWeight: FontWeight.bold
                          )
                      )
                    ]),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
