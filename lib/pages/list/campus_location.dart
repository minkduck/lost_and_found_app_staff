import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lost_and_found_app_staff/data/api/campus/campus_controller.dart';

import '../../utils/app_layout.dart';
import '../../utils/colors.dart';
import '../../widgets/big_text.dart';

class CampusLocation extends StatefulWidget {
  const CampusLocation({super.key});

  @override
  State<CampusLocation> createState() => _CampusLocationState();
}

class _CampusLocationState extends State<CampusLocation> {
  List<dynamic> campusGroupList = [];
  bool? loadFinished = false;
  final CampusController campusController = Get.put(CampusController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 1), () async {
      await campusController.getAllCampus().then((result) {
        setState(() {
          campusGroupList = result;
          loadFinished = true;
          print(campusGroupList);
        });
      });
    });

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    loadFinished = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Gap(AppLayout.getHeight(50)),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.grey,
                      size: 30,
                    ),
                  ),
                  BigText(
                    text: "View Campus and Location",
                    size: 20,
                    color: AppColors.secondPrimaryColor,
                    fontW: FontWeight.w500,
                  ),
                ],
              ),
              Gap(AppLayout.getHeight(50)),
              if (campusGroupList.isNotEmpty)
              ExpansionPanelList.radio(
                expandedHeaderPadding: EdgeInsets.all(12),
                elevation: 1,
                children: campusGroupList.map<ExpansionPanelRadio>((group) {
                  return ExpansionPanelRadio(
                    value: group['id'],
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                        title: Text(group['name'].toString(),style: Theme.of(context).textTheme.titleLarge,),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Gap(AppLayout.getHeight(5)),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: "- ID: ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      // Add other styling properties as needed
                                    ),
                                  ),
                                  TextSpan(
                                    text: "${group['id']}",

                                    // Add styling properties for the ID value if needed
                                  ),
                                ],
                              ),
                            ),
                            Gap(AppLayout.getHeight(5)),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: "- Address: ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      // Add other styling properties as needed
                                    ),
                                  ),
                                  TextSpan(
                                    text: "${group['address']}",

                                    // Add styling properties for the ID value if needed
                                  ),
                                ],
                              ),
                            ),
                            Gap(AppLayout.getHeight(5)),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: "- IsActive:: ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      // Add other styling properties as needed
                                    ),
                                  ),
                                  TextSpan(
                                    text: "${group['isActive']}",

                                    // Add styling properties for the ID value if needed
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    body: Column(
                      children: (group['locations'] as List<dynamic>)
                          .map<Widget>((location) {
                        return ListTile(
                          title: Text(location['locationName'].toString()),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "- ID: ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        // Add other styling properties as needed
                                      ),
                                    ),
                                    TextSpan(
                                      text: "${location['id']}",

                                      // Add styling properties for the ID value if needed
                                    ),
                                  ],
                                ),
                              ),

                              Gap(AppLayout.getHeight(5)),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "- Location Name: ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        // Add other styling properties as needed
                                      ),
                                    ),
                                    TextSpan(
                                      text: "${location['locationName']}",

                                      // Add styling properties for the ID value if needed
                                    ),
                                  ],
                                ),
                              ),

                              Gap(AppLayout.getHeight(5)),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "- Floor: ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        // Add other styling properties as needed
                                      ),
                                    ),
                                    TextSpan(
                                      text: "${location['floor']}",

                                      // Add styling properties for the ID value if needed
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }).toList(),
              )
              else if (campusGroupList.isEmpty && loadFinished!)
                SizedBox(
                  width: AppLayout.getScreenWidth(),
                  height: AppLayout.getScreenHeight()-200,
                  child: Center(
                    child: Text("It don't have any campus"),
                  ),
                )
              else
                SizedBox(
                  width: AppLayout.getWidth(100),
                  height: AppLayout.getHeight(300),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
