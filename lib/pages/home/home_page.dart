import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../account/account_page.dart';
import '../message/message_page.dart';
import 'home_screen.dart';


class HomePage extends StatefulWidget {
  final int initialIndex;

  HomePage({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState(initialIndex);
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex;

  _HomePageState(this._selectedIndex);
  int _selectIndex = 0;
  List pages =[
    HomeScreen(),
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