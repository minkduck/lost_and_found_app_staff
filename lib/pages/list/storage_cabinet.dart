import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:lost_and_found_app_staff/data/api/storage/storage_controller.dart';

import '../../data/api/campus/campus_controller.dart';
import '../../utils/app_layout.dart';
import '../../utils/colors.dart';
import '../../utils/snackbar_utils.dart';
import '../../widgets/big_text.dart';
import 'item_storage_list.dart';

class StorageCabinet extends StatefulWidget {
  const StorageCabinet({super.key});

  @override
  State<StorageCabinet> createState() => _StorageCabinetState();
}

class _StorageCabinetState extends State<StorageCabinet> {
  List<dynamic> storageGroupList = [];
  final StorageController storageController = Get.put(StorageController());
  bool? loadFinished = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 1), () async {
      await storageController.getAllStorages().then((result) {
        setState(() {
          storageGroupList = result;
          print(storageGroupList);
          loadFinished = true;
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
                    text: "View Storage and Cabinet",
                    size: 20,
                    color: AppColors.secondPrimaryColor,
                    fontW: FontWeight.w500,
                  ),
                ],
              ),
              Gap(AppLayout.getHeight(50)),
              if (storageGroupList.isNotEmpty)
              ExpansionPanelList.radio(
                expandedHeaderPadding: EdgeInsets.all(12),
                elevation: 1,
                children: storageGroupList.map<ExpansionPanelRadio>((group) {
                  return ExpansionPanelRadio(
                    value: group['id'],
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                        title: Text(group['location'].toString(),style: Theme.of(context).textTheme.titleLarge,),
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
                                    text: "- Location: ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      // Add other styling properties as needed
                                    ),
                                  ),
                                  TextSpan(
                                    text: "${group['location']}",

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
                                    text: "- Campus Name: ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      // Add other styling properties as needed
                                    ),
                                  ),
                                  TextSpan(
                                    text: "${group['campusName']}",

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
                                    text: "- IsActive: ",
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
                            Gap(AppLayout.getHeight(5)),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: "- Main Storage Manager: ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      // Add other styling properties as needed
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Gap(AppLayout.getHeight(5)),

                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(
                                      left: AppLayout.getWidth(16),
                                      top: AppLayout.getHeight(8)),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.grey[500],
                                    radius: 25,
                                    child: CircleAvatar(
                                      radius: 25,
                                      backgroundImage: NetworkImage(group['mainStorageManager']['avatar']??"https://upload.wikimedia.org/wikipedia/commons/d/d1/Image_not_available.png"),
                                    ),
                                  ),
                                ),
                                Gap(AppLayout.getHeight(20)),
                                Column(
                                  children: [
                                    Text(
                                      group.isNotEmpty
                                          ? group['mainStorageManager']['fullName'] :
                                      'No Name', style: TextStyle(fontSize: 12),
                                      maxLines: 5,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Gap(AppLayout.getHeight(5)),
                                    Text(
                                      group.isNotEmpty
                                          ? group['mainStorageManager']['email'] :
                                      'No Name', style: TextStyle(fontSize: 12),
                                      maxLines: 5,
                                      overflow: TextOverflow.ellipsis,
                                    ),

                                  ],
                                ),

                              ],
                            ),
                            Gap(AppLayout.getHeight(10)),

                          ],
                        ),
                      );
                    },
                    body: Column(
                      children: (group['cabinets'] as List<dynamic>)
                          .map<Widget>((cabinet) {
                        return ListTile(
                          title: Text(cabinet['name'].toString()),
                          subtitle: GestureDetector(
                            onTap: () {
                              if(cabinet['items'].length.toString() == '0'){
                                SnackbarUtils().showInfo(title: "", message: "It doesn't have any items");
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ItemCabinerList(
                                      itemCabinetList: cabinet['items'],
                                      cabinetName: cabinet['name'],
                                      // Assuming you want details of the first item
                                    ),
                                  ),
                                );
                              }
                            },
                            child: Column(
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
                                        text: "${cabinet['id']}",

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
                                        text: "- Storage Campus: ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          // Add other styling properties as needed
                                        ),
                                      ),
                                      TextSpan(
                                        text: "${cabinet['storage']['campusName']}",

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
                                        text: "- Storage Location: ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          // Add other styling properties as needed
                                        ),
                                      ),
                                      TextSpan(
                                        text: "${cabinet['storage']['location']}",

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
                                        text: "- IsActive: ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          // Add other styling properties as needed
                                        ),
                                      ),
                                      TextSpan(
                                        text: "${cabinet['isActive']}",

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
                                        text: "- Item count: ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          // Add other styling properties as needed
                                        ),
                                      ),
                                      TextSpan(
                                        text: cabinet['items'].length.toString(),

                                        // Add styling properties for the ID value if needed
                                      ),
                                    ],
                                  ),
                                ),
                                Gap(AppLayout.getHeight(5)),
                                Divider(color: Colors.grey,thickness: 1, indent: 30,endIndent: 30,),

                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }).toList(),
              )
              else if (storageGroupList.isEmpty && loadFinished!)
                SizedBox(
                  width: AppLayout.getScreenWidth(),
                  height: AppLayout.getScreenHeight()-200,
                  child: Center(
                    child: Text("It don't have any storage"),
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
