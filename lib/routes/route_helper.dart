import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lost_and_found_app_staff/pages/home_login_page.dart';
import 'package:lost_and_found_app_staff/utils/app_constraints.dart';

import '../pages/home/home_page_manager.dart';
import '../pages/home/home_page_storage_manager.dart';
import '../pages/item/items_detail.dart';

class RouteHelper {
  static const String splashPage = "/splash-page";
  static const String initial = "/";
  static const String item = "/item";

  static Future<String> getRoleAsync() async {
    return await AppConstrants.getRole();
  }

  static String getItem(int pageId, String page) {
    // Ensure that pageId and page are not null
    pageId ??= 0;
    page ??= 'default'; // Provide a default value if page is null

    return '$item?pageId=$pageId&page=$page';
  }

  static String getInitial(int initialIndex) => '$initial?initialIndex=$initialIndex';

  static List<GetPage> routes = [
    GetPage(
      name: initial,
      page: () {
        return FutureBuilder<String>(
          future: getRoleAsync(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else {
              var initialIndex = int.tryParse(Get.parameters['initialIndex'] ?? '0');
              var role = snapshot.data;
              return role == "Storage Manager"
                  ? HomePageStorageManager(initialIndex: initialIndex ?? 0,)
                  : HomePageManager(initialIndex: initialIndex ?? 0,);
            }
          },
        );
      },
    ),
    GetPage(
      name: item,
      page: () {
        var pageId = int.tryParse(Get.parameters['pageId'] ?? '0');
        var page = Get.parameters['page'] ?? 'default';
        return ItemsDetails(pageId: pageId!, page: page);
      },
      transition: Transition.fadeIn,
    ),
  ];
}
