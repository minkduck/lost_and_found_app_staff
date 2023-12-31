import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lost_and_found_app_staff/pages/list/campus_location.dart';
import 'package:lost_and_found_app_staff/pages/list/storage_cabinet.dart';

import '../../utils/app_constraints.dart';
import '../../utils/app_layout.dart';
import '../../utils/colors.dart';
import '../../widgets/app_button.dart';
import 'category.dart';

class AllList extends StatefulWidget {
  const AllList({super.key});

  @override
  State<AllList> createState() => _AllListState();
}

class _AllListState extends State<AllList> {
  late String role = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AppConstrants.getRole().then((String value) {
      setState(() {
        role = value;
        print("role:" + role);
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Gap(AppLayout.getHeight(130)),
            role == "Storage Manager" ? AppButton(boxColor: AppColors.primaryColor, textButton: "Category", onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => CategoryList()));
            }) : Container(),
            Gap(AppLayout.getHeight(50)),
            role == "Manager" ?AppButton(boxColor: AppColors.primaryColor, textButton: "Campus & Location", onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => CampusLocation()));
            }) : Container(),
            Gap(AppLayout.getHeight(50)),
            role == "Storage Manager" ? AppButton(boxColor: AppColors.primaryColor, textButton: "Storage & Cabinet", onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => StorageCabinet()));
            }): Container(),

          ],
        ),
      ),
    );
  }
}
