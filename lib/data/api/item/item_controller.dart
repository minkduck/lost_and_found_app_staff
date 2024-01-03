import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../routes/route_helper.dart';
import '../../../utils/app_constraints.dart';
import '../../../utils/snackbar_utils.dart';

class ItemController extends GetxController{
  late String accessToken = "";
  late String uid = "";

  List<dynamic> _itemList = [];
  List<dynamic> get itemList => _itemList;

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;


  Future<List<dynamic>> getItemList() async {
    accessToken = await AppConstrants.getToken();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };
    var request = http.Request('GET', Uri.parse('${AppConstrants.GETITEMWITHPAGINATION_URL}ALL'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
/*      final jsonResponse = json.decode(responseBody);
      final List<Item> items = (jsonResponse['result'] as List).map((e) => Item.fromJson(e)).toList();
      _itemList.addAll(items);
      _isLoaded = true;
      update();
      print("itemlist " + _itemList.toString());*/
      final jsonResponse = json.decode(responseBody);

        final resultList = jsonResponse['result'];
        _itemList = resultList;
        _isLoaded = true;
        update();
        // print("itemlist " + _itemList.toString());
        return resultList;
    } else {
      print(response.statusCode);
      print(response.reasonPhrase);
      throw Exception('Failed to load getItemList');
    }
  }
  Future<Map<String, dynamic>> getItemListById(int id) async {
    accessToken = await AppConstrants.getToken();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };
    var request = http.Request('GET', Uri.parse(AppConstrants.GETITEMBYID_URL +id.toString()));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseBody);

      final resultList = jsonResponse['result'];
      // _itemList = resultList;
      _isLoaded = true;
      update();
      print("itemlistByid " + _itemList.toString());
      return resultList;
    } else {
      print(response.statusCode);
      print(response.reasonPhrase);
      throw Exception('Failed to load getItemListById');
    }
  }

  Future<List<dynamic>> getItemByUidList() async {
    accessToken = await AppConstrants.getToken();
    uid = await AppConstrants.getUid();
    // uid = 'FLtIEJvuMgfg58u4sXhzxPn9qr73';
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };
    var request = http.Request('GET', Uri.parse('${AppConstrants.GETITEMBYUID_URL}$uid&ItemStatus=ALL'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseBody);

      final resultList = jsonResponse['result'];
      _isLoaded = true;
      update();
      print("getItemByUidList " + resultList.toString());
      return resultList;
    } else {
      print(response.statusCode);
      print(response.reasonPhrase);
      throw Exception('Failed to load getItemByUidList');
    }
  }

  Future<void> createItem(
      String name,
      String description,
      String categoryId,
      String locationId,
      String foundDate,
      List<String> medias ) async {
    accessToken = await AppConstrants.getToken();
    var headers = {
      'Authorization': 'Bearer $accessToken'
    };
    var request = http.MultipartRequest('POST', Uri.parse(AppConstrants.POSTITEM_URL));
    request.fields.addAll({
      'Name': name,
      'Description': description,
      'CategoryId': categoryId,
      'LocationId': locationId,
      'FoundDate': foundDate,

    });
    for (var media in medias) {
      request.files.add(await http.MultipartFile.fromPath('Medias', media));
    }
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      SnackbarUtils().showSuccess(title: "Success", message: "Create item successfully");
      Get.toNamed(RouteHelper.getInitial(0));
    }
    else {
      print(response.reasonPhrase);
      print(response.statusCode);
      throw Exception('Failed to create Item');
    }

  }

  Future<void> deleteItemById(int itemId) async {
    accessToken = await AppConstrants.getToken();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };
    var request = http.Request('DELETE', Uri.parse("${AppConstrants.POSTITEM_URL}/$itemId"));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 204) {
      print(await response.stream.bytesToString());
      SnackbarUtils().showSuccess(title: "Success", message: "Delete item successfully");
      Get.toNamed(RouteHelper.getInitial(0));
    } else {
      print(response.statusCode);
      print(response.reasonPhrase);
      throw Exception('Failed to delete getItemList');
    }
  }

  Future<void> updateItemById(
      int itemId,
      String title,
      String description,
      String categoryId,
      String locationId,
      String foundDate,
      // String status
      ) async {
    accessToken = await AppConstrants.getToken();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };
    var request = http.Request('PUT', Uri.parse("${AppConstrants.POSTITEM_URL}/$itemId"));

    request.body = json.encode({
      "name": title,
      "description": description,
      "locationId": locationId,
      "categoryId": categoryId,
      "cabinetId": null,
      // "itemStatus": status,
      "foundDate": foundDate
    });
    print(request.body);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      SnackbarUtils().showSuccess(title: "Success", message: "Edit item successfully");
      Get.toNamed(RouteHelper.getInitial(0));
    } else {
      print(response.statusCode);
      print(response.reasonPhrase);
      throw Exception('Failed to delete getItemList');
    }
  }
}