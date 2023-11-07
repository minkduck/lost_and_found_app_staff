import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';


import '../data/api/user/user_controller.dart';
import '../utils/app_constraints.dart';


Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  Get.lazyPut(() => sharedPreferences);
  //api client
  // Get.lazyPut(() => ApiClient(appBaseUrl: AppConstrants.BASE_URL));

  //item
  // Get.lazyPut(() => ItemController());

  //location
  // Get.lazyPut(() => LocationController());

  //category
  // Get.lazyPut(() => CategoryController());

  //post
  // Get.lazyPut(() => PostController());

  //comment
  // Get.lazyPut(() => CommentController());

  //user
  Get.lazyPut(() => UserController());

  //claim
  // Get.lazyPut(() => ClaimController());

}
