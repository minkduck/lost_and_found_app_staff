import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lost_and_found_app_staff/pages/auth/login_page.dart';
import 'package:lost_and_found_app_staff/pages/home_login_page.dart';
import 'package:lost_and_found_app_staff/routes/route_helper.dart';
import 'package:lost_and_found_app_staff/utils/theme.dart';
import 'data/api/firebase/firebase_notification.dart';
import 'helper/dependencies.dart' as dep;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseNotification().initNotifications();
  await dep.init();


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Found and Lost App',
      debugShowCheckedModeBanner: false,

      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      themeMode: ThemeMode.system,

      home: LoginPage(),
      getPages: RouteHelper.routes,
    );
  }
}

