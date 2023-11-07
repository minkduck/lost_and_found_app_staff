import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/api/user/user_controller.dart';
import '../../utils/app_layout.dart';
import '../../utils/colors.dart';
import '../../widgets/icon_and_text_widget.dart';

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
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      body: Column(
        children: [
          userList.isNotEmpty ? Column(
            children: [
              Gap(AppLayout.getHeight(70)),
              CircleAvatar(
                radius: 80,
                backgroundImage:
                NetworkImage(userList['avatar'] ?? ''),
              ),
              Gap(AppLayout.getHeight(30)),
              Text(userList['fullName']?? '', style: Theme.of(context).textTheme.headlineMedium,),
              Gap(AppLayout.getHeight(30)),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30),
                padding: EdgeInsets.only(top: AppLayout.getHeight(20), bottom: AppLayout.getHeight(20)),
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 4,
                          spreadRadius: 4,
                          offset: Offset(0, 4),
                          color: Colors.grey.withOpacity(0.2))
                    ]),
                // color: Colors.red,
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding:  EdgeInsets.only(bottom: AppLayout.getHeight(8), left: AppLayout.getWidth(40)),
                      child: IconAndTextWidget(icon: Icons.email, text: userList['email']?? '-', iconColor: AppColors.secondPrimaryColor),
                    ),

                    Divider(color: Colors.grey,thickness: 1, indent: 30,endIndent: 30,),
                    Gap(AppLayout.getHeight(10)),

                    Padding(
                      padding: EdgeInsets.only(bottom: AppLayout.getHeight(8), left: AppLayout.getWidth(40)),
                      child: IconAndTextWidget(icon: FontAwesomeIcons.genderless, text: userList['gender'] ?? '-', iconColor: AppColors.secondPrimaryColor),

                    ),
                    Divider(color: Colors.grey,thickness: 1, indent: 30,endIndent: 30,),
                    Gap(AppLayout.getHeight(10)),

                    Padding(
                      padding: EdgeInsets.only(bottom: AppLayout.getHeight(8), left: AppLayout.getWidth(40)),
                      child: IconAndTextWidget(icon: Icons.phone, text: userList['phone']?? '-', iconColor: AppColors.secondPrimaryColor),
                    ),

                  ],
                ),
              ),
              Gap(AppLayout.getHeight(150)),
            ],
          ) : Center(child: CircularProgressIndicator(),),

          InkWell(
            onTap: () async {
              logout();
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
    );
  }
}
