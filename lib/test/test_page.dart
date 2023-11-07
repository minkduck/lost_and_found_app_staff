import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lost_and_found_app_staff/data/api/user/user_controller.dart';

import '../utils/app_constraints.dart';
class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  late String fcmToken = "";
  late String accessToken = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('hello'),
      ),
      body:Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              // fcmToken = await AppConstrants.getFcmToken();
              // accessToken = await AppConstrants.getToken();
              // SnackbarUtils().showSuccess(title: "Successs", message: "Login google successfully");
              // SnackbarUtils().showError(title: "Error", message: "Some thing wrong");
              // SnackbarUtils().showInfo(title: "Info", message: "Info");
              // SnackbarUtils().showLoading(message: "loading");
              // Get.find<ItemController>().getItemByUidList();
              // Get.find<CategoryController>().getCategoryList();
              // Get.find<PostController>().getPostByUidList();
              // Get.find<LocationController>().getLocationList();
              // Get.find<CommentController>().getCommentByPostId(1);
              Get.find<UserController>().getUserByUid();

            },
            child: Text('button'),
          ),
          Column(
              children:[
                // Text(fcmToken ?? ''),
                // Text(accessToken ?? ''),
              ]
          )
        ],
      ),
    );
  }
}
