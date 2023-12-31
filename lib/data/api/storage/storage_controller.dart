import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../utils/app_constraints.dart';

class StorageController extends GetxController{
  late String accessToken = "";
  Future<List<dynamic>> getAllStorages() async {
    accessToken = await AppConstrants.getToken();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };
    var request = http.Request('GET', Uri.parse(AppConstrants.GETSTORAGE_URL));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseBody);

      final resultList = jsonResponse['result'];
      update();
      print("storage:  " + resultList.toString());
      return resultList;
    } else {
      print(response.statusCode);
      print(response.reasonPhrase);
      throw Exception('Failed to load All Storages');
    }
  }

}