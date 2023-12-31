import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lost_and_found_app_staff/pages/auth/login_page.dart';
import 'package:lost_and_found_app_staff/test/test_page.dart';
import 'package:lost_and_found_app_staff/utils/app_constraints.dart';

import 'home/home_page_manager.dart';
import 'home/home_page_storage_manager.dart';

class HomeLoginPage extends StatefulWidget {
  final int initialIndex;
  const HomeLoginPage({Key? key, required this.initialIndex}) : super(key: key);

  @override
  State<HomeLoginPage> createState() => _HomeLoginPageState();
}

class _HomeLoginPageState extends State<HomeLoginPage> {
  late String role = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AppConstrants.getRole().then((String value) {
      setState(() {
        role = value;
        print("role:" + role);
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Something Went Wrong!'),);
          } else if (snapshot.hasData) {

            return role == "Storage Manager" ? HomePageStorageManager(initialIndex: widget.initialIndex,) : HomePageManager(initialIndex: 0,);
          } else {
            return LoginPage();
          }
        },
      ),
    );
  }
}
