import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lost_and_found_app_staff/pages/giveaway/giveaway_screen.dart';
import 'package:lost_and_found_app_staff/pages/list/all_list.dart';

import '../../utils/colors.dart';
import '../account/account_page.dart';
import '../message/message_page.dart';
import '../post/post_screen.dart';
import 'home_screen.dart';


class HomePageStorageManager extends StatefulWidget {
  final int initialIndex;

  HomePageStorageManager({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  State<HomePageStorageManager> createState() => _HomePageState(initialIndex);
}

class _HomePageState extends State<HomePageStorageManager> {
  int _selectedIndex;

  _HomePageState(this._selectedIndex);
  int _selectIndex = 0;
  List pages =[
    HomeScreen(),
    GiveawayScreen(),
    AllList(),
    MessagePage(),
    AccountPage(),
  ];


  void onTapNav(int index){
    setState(() {
      _selectIndex = index;
    });
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    _selectIndex = _selectedIndex;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_selectIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: AppColors.secondPrimaryColor,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _selectIndex,
        onTap: onTapNav,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined,),
              label: "Home"
          ),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.gift, size: 20,),
              label: "Giveaway"
          ),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.list, size: 20,),
              label: "List"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.message_outlined,),
              label: "Message"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person,),
              label: "Me"
          ),
        ],
      ),
    );
  }
}