import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lost_and_found_app_staff/pages/home/home_page_manager.dart';
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

import '../../data/api/user/user_controller.dart';
import '../../test/test_page.dart';
import '../../utils/app_constraints.dart';
import '../../utils/snackbar_utils.dart';
import '../../widgets/app_text_field_title_password.dart';
import '../home/home_page_storage_manager.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  late String accessToken = "";

  Map<String, dynamic> userList = {};
  final UserController userController= Get.put(UserController());
  late String fcmToken ;

  Future<void> getFcmToken() async {
    final prefs = await SharedPreferences.getInstance();
    fcmToken = prefs.getString('fcmToken')!;
    print("fcmToken: " + fcmToken);
  }

  Future<void> postAuthen() async {
    await getFcmToken();
    accessToken = await AppConstrants.getToken();

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };
    var request = http.Request('POST', Uri.parse(AppConstrants.AUTHENTICATE_URL+fcmToken));
    request.body = json.encode({
      "userDeviceToken" : fcmToken
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      print("post Authen device token successful");
    }
    else {
      print(response.reasonPhrase);
    }

  }

  Future<void> loginEmailPassword() async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      final user = await FirebaseAuth.instance.currentUser!;
      final idTokenUser = await user.getIdToken();
      userList = await userController.getUserLoginByUserId(user.uid, idTokenUser!);

      final prefs = await SharedPreferences.getInstance();
      print("id Token User: " + idTokenUser.toString());
      if (idTokenUser != null && idTokenUser.length > 1000) {
        print(idTokenUser.substring(1000));
      } else {
        print("String is too short to perform the second substring.");
      }
      // Wait for setString operation to complete before moving on
      await prefs.setString('role', userList['role'].toString());

      await prefs.setString('access_token', idTokenUser.toString());
      await prefs.setString('uid', user.uid);
      await postAuthen();

      if (userList['role'] == "Storage Manager") {
        SnackbarUtils().showSuccess(title: "Success", message: "Login successfully");
        await prefs.setString('campusId', userList['campus']['id'].toString());
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePageStorageManager(initialIndex: 0)),
        );
      } else if (userList['role'] == "Manager") {
        SnackbarUtils().showSuccess(title: "Success", message: "Login successfully");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePageManager(initialIndex: 0,)),
        );
      } else {
        SnackbarUtils().showError(title: "Unsuccess", message: "You do not have permission to log into the system");
        // Handle other roles or logout here
        logout();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
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
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print('Error during logout: $e');
    }
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
            AppTextFieldTitleEmail(
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

class AppTextFieldTitleEmail extends StatelessWidget {
  late var textController;
  final String hintText;
  final String titleText;
  final String validator;

  AppTextFieldTitleEmail({
    Key? key,
    required this.textController,
    required this.hintText,
    required this.titleText,
    required this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 20),
          child: Text(
            titleText,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Gap(AppLayout.getHeight(15)),
        Container(
          height: AppLayout.getHeight(55),
          margin: EdgeInsets.only(
              left: AppLayout.getHeight(20), right: AppLayout.getHeight(20)),
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(AppLayout.getHeight(20)),
              boxShadow: [
                BoxShadow(
                    blurRadius: 4,
                    spreadRadius: 4,
                    offset: Offset(0, 4),
                    color: Colors.grey.withOpacity(0.2))
              ]),
          child: TextFormField(
            onSaved: (value) => textController = value,
            style: Theme.of(context).textTheme.headlineSmall,
            controller: textController,
            decoration: InputDecoration(
              isDense: true,
              hintText: hintText,
              hintStyle: Theme.of(context).textTheme.labelSmall,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppLayout.getHeight(20)),
                borderSide: BorderSide(
                  width: 1.0,
                  color: Colors.white,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppLayout.getHeight(20)),
                borderSide: BorderSide(width: 1.0, color: Colors.white),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return validator;
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
