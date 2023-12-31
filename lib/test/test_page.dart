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

  List myList=[
    'laravel',
    'flutter',
    'goLang'
  ];
  final List<Map<String, dynamic>> _items = List.generate(
      20,
          (index) => {
        'id': index,
        'title': 'Item $index',
        'description':
        'This is the description of the item $index. There is nothing important here. In fact, it is meaningless.',
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('hello'),
      ),
      body:SingleChildScrollView(
        child: Column(
          children: [
            ExpansionPanelList.radio(
              children: _items.map((e) => ExpansionPanelRadio(
                  value: e['id'],
                  headerBuilder: (BuildContext context, bool isExpanded)=>ListTile(
                    title: Text(e['title'].toString()),
                  ),
                  body: Container(
                    child: Text(
                        e['description']
                    ),
                  )
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
