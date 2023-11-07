import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../utils/app_constraints.dart';
import '../../../utils/snackbar_utils.dart';

class UserController extends GetxController {
  late String accessToken = "";
  late String uid = "";

  bool _isLoaded = false;

  bool get isLoaded => _isLoaded;

  Future<Map<String, dynamic>> getUserByUid() async {
    accessToken = await AppConstrants.getToken();
    uid = await AppConstrants.getUid();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };
    var request = http.Request(
        'GET', Uri.parse(AppConstrants.GETUSERBYUID_URL + uid));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseBody);

      final resultList = jsonResponse['result'];
      _isLoaded = true;
      update();
      print("getUser " + resultList.toString());
      return resultList;
    } else {
      print(response.statusCode);
      print(response.reasonPhrase);
      throw Exception('Failed to load getUserByUid');
    }
  }
}