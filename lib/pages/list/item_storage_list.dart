import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../test/time/time_widget.dart';
import '../../utils/app_layout.dart';
import '../../utils/colors.dart';
import '../../widgets/app_button.dart';
import '../../widgets/big_text.dart';
import '../../widgets/icon_and_text_widget.dart';
import '../../widgets/time_ago_found_widget.dart';
import '../item/items_detail.dart';

class ItemCabinerList extends StatefulWidget {
  final List<dynamic> itemCabinetList;
  final String cabinetName;
  ItemCabinerList({required this.itemCabinetList, required this.cabinetName});

  @override
  State<ItemCabinerList> createState() => _ItemCabinerListState();
}

class _ItemCabinerListState extends State<ItemCabinerList> {

  String? getUrlFromItem(Map<String, dynamic> item) {
    if (item.containsKey('itemMedias')) {
      final itemMedias = item['itemMedias'] as List;
      if (itemMedias.isNotEmpty) {
        final media = itemMedias[0] as Map<String, dynamic>;
        if (media.containsKey('media')) {
          final mediaData = media['media'] as Map<String, dynamic>;
          if (mediaData.containsKey('url')) {
            return mediaData['url'] as String;
          }
        }
      }
      return "https://upload.wikimedia.org/wikipedia/commons/d/d1/Image_not_available.png";
    }
    return "https://upload.wikimedia.org/wikipedia/commons/d/d1/Image_not_available.png";
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
                    text: "List Items of Cabinet ${widget.cabinetName}",
                    size: 20,
                    color: AppColors.secondPrimaryColor,
                    fontW: FontWeight.w500,
                  ),
                ],
              ),
              Center(
                child: GridView.builder(
                  padding: EdgeInsets.all(15),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: AppLayout.getWidth(200),
                    childAspectRatio: 0.55,
                    crossAxisSpacing: AppLayout.getWidth(20),
                    mainAxisSpacing: AppLayout.getHeight(20),
                  ),
                  itemCount: widget.itemCabinetList.length,
                  itemBuilder: (context, index) {
                    final item = widget.itemCabinetList[index];
                    final mediaUrl = getUrlFromItem(item) ??
                        "https://upload.wikimedia.org/wikipedia/commons/d/d1/Image_not_available.png";
                    if (item['foundDate'] != null) {
                      String foundDate = item['foundDate'];
                      if (foundDate.contains('|')) {
                        List<String> dateParts = foundDate.split('|');
                        if (dateParts.length == 2) {
                          String date = dateParts[0].trim();
                          String slot = dateParts[1].trim();

                          // Check if the date format needs to be modified
                          if (date.contains(' ')) {
                            // If it contains time, remove the time part
                            date = date.split(' ')[0];
                          }
                          DateFormat originalDateFormat = DateFormat("yyyy-MM-dd");
                          DateTime originalDate = originalDateFormat.parse(date);

                          // Format the date in the desired format
                          DateFormat desiredDateFormat = DateFormat("dd-MM-yyyy");
                          String formattedDate = desiredDateFormat.format(originalDate);
                          String timeAgo = TimeAgoFoundWidget.formatTimeAgo(originalDate);

                          // Update the foundDate in the itemlist
                          item['foundDate'] = '$timeAgo';
                        }
                      }
                    }

                    return Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: AppLayout.getHeight(140),
                            width: AppLayout.getWidth(180),
                            child: Image.network(
                              mediaUrl,
                              fit: BoxFit.fill,
                              errorBuilder: (context, error, stackTrace) {
                                print("Error loading image: $error");
                                return Image.network(
                                  "https://upload.wikimedia.org/wikipedia/commons/d/d1/Image_not_available.png",
                                  fit: BoxFit.fill,
                                );
                              },
                            )
                          ),
                          Container(
                            color: Theme.of(context).cardColor,
                            padding: EdgeInsets.only(
                              bottom: AppLayout.getHeight(28.5),
                              left: AppLayout.getWidth(8),
                              right: AppLayout.getWidth(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Gap(AppLayout.getHeight(8)),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item['name'] ?? 'No Name',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                Gap(AppLayout.getHeight(15)),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: Theme.of(context).iconTheme.color,
                                      size: AppLayout.getHeight(24),
                                    ),
                                    const Gap(5),
                                    Expanded(
                                      child: Text(
                                        item['locationName'] ??
                                            'No Location',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                Gap(AppLayout.getWidth(15)),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Align(
                                    alignment:
                                    Alignment.centerLeft,
                                    child: Text(
                                      item['foundDate'] ?? '',
                                      maxLines: 1,
                                      overflow:
                                      TextOverflow.ellipsis,
                                      style:
                                      TextStyle(fontSize: 15),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: AppButton(
                              boxColor: AppColors.secondPrimaryColor,
                              textButton: "Details",
                              fontSize: 18,
                              height: AppLayout.getHeight(30),
                              width: AppLayout.getWidth(180),
                              topLeft: 1,
                              topRight: 1,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ItemsDetails(
                                        pageId: item['id'], page: "item"),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}



