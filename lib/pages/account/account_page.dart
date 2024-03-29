import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lost_and_found_app_staff/pages/account/profile_page.dart';
import 'package:lost_and_found_app_staff/pages/auth/login_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/api/user/user_controller.dart';
import '../../utils/app_layout.dart';
import '../../utils/colors.dart';
import '../../widgets/app_button.dart';
import '../../widgets/icon_and_text_widget.dart';
import '../claims/item_claim_by_user.dart';
import 'my_qr_code.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

Future<void> logout() async {
  try {
    await FirebaseAuth.instance.signOut();
  } catch (e) {
    print('Error during logout: $e');
  }
}

class _AccountPageState extends State<AccountPage> {
    bool _isMounted = false;
  Map<String, dynamic> userList = {};
  final UserController userController= Get.put(UserController());

  Future<void> _refreshData() async {
    _isMounted = true;
    await userController.getUserByUid().then((result) {
      if (_isMounted) {
        setState(() {
          userList = result;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    Future.delayed(Duration(seconds: 1), () async {
      await userController.getUserByUid().then((result) {
        if (_isMounted) {
          setState(() {
            userList = result;
          });
        }
      });
    });

  }
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Center(
          child: Column(
            children: [
              Gap(AppLayout.getHeight(130)),
              AppButton(boxColor: AppColors.primaryColor, textButton: "Profile", onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => ProfilePage()));

              }),
              Gap(AppLayout.getHeight(80)),

              InkWell(
                onTap: () async {
                  await logout();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Ink(
                  width: AppLayout.getWidth(325),
                  height: AppLayout.getHeight(50),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor, // Set the color here
                    // borderRadius: BorderRadius.circular(AppLayout.getHeight(15)),
                    borderRadius: BorderRadius.all(Radius.circular(15)),

                    boxShadow: [
                      BoxShadow(
                          blurRadius: 4,
                          spreadRadius: 4,
                          offset: Offset(0, 4),
                          color: Colors.grey.withOpacity(0.2))
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      "Log out",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 25,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }
}
