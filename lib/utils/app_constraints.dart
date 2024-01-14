import 'package:shared_preferences/shared_preferences.dart';

class AppConstrants{

  static Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token') ?? '';
  }
  static Future<String> getFcmToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('fcmToken') ?? '';
  }
  static Future<String> getUid() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('uid') ?? '';
  }
  static Future<String> getRole() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('role') ?? '';
  }

  static const String APP_NAME = "Lost&FoundStaff";
  static const int APP_VERSION = 1;

  static const String BASE_URL = "https://lostandfound.io.vn";
  static String TOKEN = '';


  //auth
  static const String LOGINGOOGLE_URL = "$BASE_URL/auth/googleLoginAuthenticate";
  static const String AUTHENTICATE_URL = "$BASE_URL/auth/authenticate?userDeviceToken=";

  //category
  static const String GETCATEGORYWITHPAGINATION_URL = "$BASE_URL/api/categories/all";
  static const String GETCATEGORYGROUPWITHPAGINATION_URL = "$BASE_URL/api/categoryGroups";

  //location
  static const String GETLOCATIONWITHPAGINATION_URL = "$BASE_URL/api/locations";
  static const String GETALLLOCATION_URL = "$BASE_URL/api/locations/all";

  //campus
  static const String GETALLCAMPUS_URL = "$BASE_URL/api/campuses";

  //campus
  static const String GETSTORAGE_URL = "$BASE_URL/api/storages?IsActive=All";

  //item
  static const String GETITEMWITHPAGINATION_URL = "$BASE_URL/api/items?ItemStatus=";
  static const String GETITEMBYID_URL = "$BASE_URL/api/items/id/";
  static const String GETITEMBYUID_URL = "$BASE_URL/api/items?FoundUserId=";
  static const String POSTITEM_URL = "$BASE_URL/api/items";

  //post
  static const String GETPOSTWITHPAGINATION_URL = "$BASE_URL/api/posts";
  static const String GETPOSTBYID_URL = "$BASE_URL/api/posts/";
  static const String POSTPOST_URL = "$BASE_URL/api/posts/";
  static const String GETPOSTMEDIABYID_URL = "$BASE_URL/api/posts/";
  static const String GETPOSTBYUID_URL = "$BASE_URL/api/posts/query-with-status?PostUserId=";
  static const String GETPOSTBYUSERID_URL = "$BASE_URL/api/posts?PostUserId=";
  static const String GETPOSTWITHSTATUS = "$BASE_URL/api/posts/query-with-status?PostStatus=All";


  //comment
  static const String GETCOMMENTBYPOSTBID_URL = "$BASE_URL/api/comments/get-by-post/";
  static const String POSTCOMMENTREPLYBYPOSTID_URL = "$BASE_URL/api/comments/reply-post/";
  static const String PUTCOMMENTBYPOSTID_URL = "$BASE_URL/api/comments/";

  //user
  static const String GETUSERBYUID_URL = "$BASE_URL/api/users/";
  static const String PUTUSERBYUID_URL = "$BASE_URL/api/users/";
  static const String POSTAVATARUSER_URL = "$BASE_URL/api/users/media";

  //claim
  static const String POSTCLAIMITEM_URL = "$BASE_URL/api/items/claim/";
  static const String POSTUNCLAIMITEM_URL = "$BASE_URL/api/items/unclaim/";
  static const String GETALLITEMCLAIMBYUSER_URL = "$BASE_URL/api/items/claims/member/all/";
  static const String GETLISTFOUNDERUSER_URL = "$BASE_URL/api/items/claims/founder/item/";
  static const String POSTDENYCLAIMBYITEMIDANDUSERID_URL = "$BASE_URL/api/items/deny";
  static const String POSTACCPECTCLAIMBYITEMIDANDUSERID_URL = "$BASE_URL/api/items/accept";

  //receipt
  static const String POSTRECEIPT_URL = "$BASE_URL/api/items/accept-with-receipt";
  static const String GETRECEIPTBYITEMID_URL = "$BASE_URL/api/receipts?ItemId=";
  static const String GETRECEIPTBYRECEIVERID_URL = "$BASE_URL/api/receipts?ReceiverId=";
  static const String GETRECEIPTBYSENDERID_URL = "$BASE_URL/api/receipts?SenderId=";

  //notification
  static const String GETALLNOTIBYUSERID_URL = "$BASE_URL/api/notifications/get-all-notification/";
  static const String PUSHNOTIFICATIONS_URL = "$BASE_URL/api/notifications/push";

  //giveaway
  static const String GETGIVEAWAYSTATUS_URL = "$BASE_URL/api/giveaways/query-with-status?GiveawayStatus=";
}