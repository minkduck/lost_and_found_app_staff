import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../data/api/category/category_controller.dart';
import '../../utils/app_layout.dart';
import '../../utils/colors.dart';
import '../../widgets/big_text.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({Key? key}) : super(key: key);

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  List<dynamic> categoryGroupList = [];
  final CategoryController categoryController = Get.put(CategoryController());

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () async {
      await categoryController.getCategoryGroupList().then((result) {
        setState(() {
          categoryGroupList = result;
          print(categoryGroupList);
        });
      });
    });
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
                    text: "View Category",
                    size: 20,
                    color: AppColors.secondPrimaryColor,
                    fontW: FontWeight.w500,
                  ),
                ],
              ),
              Gap(AppLayout.getHeight(50)),
              ExpansionPanelList.radio(
                expandedHeaderPadding: EdgeInsets.all(12),
                elevation: 1,
                children: categoryGroupList.map<ExpansionPanelRadio>((group) {
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
                                    text: "- Description: ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      // Add other styling properties as needed
                                    ),
                                  ),
                                  TextSpan(
                                    text: "${group['description']}",

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
                      children: (group['categories'] as List<dynamic>)
                          .map<Widget>((category) {
                        return ListTile(
                          title: Text(category['name'].toString()),
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
                                      text: "${category['id']}",

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
                                      text: "- Description: ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        // Add other styling properties as needed
                                      ),
                                    ),
                                    TextSpan(
                                      text: "${category['description']}",

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
                                      text: "- IsSensitive: ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        // Add other styling properties as needed
                                      ),
                                    ),
                                    TextSpan(
                                      text: "${category['isSensitive']}",

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
                                      text: "- Value: ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        // Add other styling properties as needed
                                      ),
                                    ),
                                    TextSpan(
                                      text: "${category['value']}",

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
                                      text: "${category['isActive']}",

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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
