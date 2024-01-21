import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:lost_and_found_app_staff/data/api/giveaway/giveaway_controller.dart';

import '../../data/api/notifications/notification_controller.dart';
import '../../test/time/time_widget.dart';
import '../../utils/app_assets.dart';
import '../../utils/app_layout.dart';
import '../../utils/colors.dart';
import '../../widgets/big_text.dart';

class GiveawayScreen extends StatefulWidget {
  const GiveawayScreen({super.key});

  @override
  State<GiveawayScreen> createState() => _GiveawayScreenState();
}

class _GiveawayScreenState extends State<GiveawayScreen> {
  bool _isMounted = false;
  bool? loadFinished = false;

  List<dynamic> giveawayList = [];
  final GiveawayController giveawayController = Get.put(GiveawayController());

  List<Map<String, String>> giveawayStatusList = [
    {'name': 'ONGOING', 'displayName':'ONGOING'},
    {'name': 'REWARD_DISTRIBUTION_IN_PROGRESS', 'displayName':'DISTRIBUTING REWARD'},
    {'name': 'CLOSED', 'displayName':'CLOSED'},
  ];

  List<String> selectedGiveawayStatus = ['ONGOING'];

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
    }
    return "https://upload.wikimedia.org/wikipedia/commons/d/d1/Image_not_available.png";
  }

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    Future.delayed(Duration(seconds: 1), () async {
      giveawayController.getGiveawayStatusList().then((result) {
        if (_isMounted) {
          setState(() {
            giveawayList = result;
            loadFinished = true;
          });
        }
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
    List<dynamic> filteredGiveawayList = giveawayList
        .where((giveaway) =>
    selectedGiveawayStatus.isEmpty ||
        selectedGiveawayStatus.contains(giveaway['giveawayStatus']))
        .toList();

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child:  Column(
              children: [
                Gap(AppLayout.getHeight(50)),
                Row(
                  children: [
                    BigText(
                      text: "Giveaway",
                      size: 20,
                      color: AppColors.secondPrimaryColor,
                      fontW: FontWeight.w500,
                    ),
                  ],
                ),
                Gap(AppLayout.getHeight(25)),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: giveawayStatusList
                          .map((status) => GestureDetector(
                        onTap: () {
                          setState(() {
                            if (selectedGiveawayStatus.contains(status['name'])) {
                              selectedGiveawayStatus.remove(status['name']);
                            } else {
                              selectedGiveawayStatus.add(status['name']!);
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          child: BigText(
                            text: status['displayName'] != null ? status['displayName'].toString() : 'No Status',
                            color: selectedGiveawayStatus.contains(status['name'])
                                ? AppColors
                                .primaryColor // Selected text color
                                : AppColors.secondPrimaryColor,
                            fontW: FontWeight.w500,
                          ),
                        ),
                      ))
                          .toList(),
                    ),
                  ),
                ),
                if (loadFinished! && giveawayList.isNotEmpty)
                  ListView.builder(
                      shrinkWrap: true,
                      reverse: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: filteredGiveawayList.length,
                      itemBuilder: (BuildContext context, int index) {
                        final giveaway = filteredGiveawayList[index];
                        final winnerUser = giveaway['winnerUser'];

                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Theme.of(context).cardColor,
                          ),
                          margin: EdgeInsets.only(
                              bottom: AppLayout.getHeight(20)),
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  "Giveaway ${giveaway['item']['name']}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium,
                                ),
                              ),
                              Container(
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  giveaway['createdDate'] != null
                                      ? 'Posted date: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(giveaway['createdDate']))}'
                                      : 'No Date',
                                  style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey),
                                ),
                              ),
                              Gap(AppLayout.getHeight(10)),
                              Container(
                                height:
                                MediaQuery.of(context).size.height *
                                    0.25,
                                // Set a fixed height or use any other value
                                child: ListView.builder(
                                  padding: EdgeInsets.zero, // Add this line to set zero padding
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: giveaway['item']['itemMedias']
                                      .length,
                                  itemBuilder: (context, indexs) {
                                    return Container(
                                      alignment: Alignment.centerLeft,
                                      margin: EdgeInsets.only(
                                          left: AppLayout.getWidth(20)),
                                      height: AppLayout.getHeight(151),
                                      width: AppLayout.getWidth(180),
                                      child: Image.network(
                                          giveaway['item']['itemMedias']
                                          [indexs]['media']['url'] ?? Container(),
                                          fit: BoxFit.fill),
                                    );
                                  },
                                ),
                              ),
                              Gap(AppLayout.getHeight(10)),

                              Container(
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  giveaway['item']['description'],
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall,
                                ),
                              ),
                              Gap(AppLayout.getHeight(20)),
                              Container(
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  giveaway['startAt'] != null
                                      ? "Start Date: ${DateFormat('dd-MM-yyyy - HH:mm a').format(DateTime.parse(giveaway['startAt']))}"
                                      : 'No Date',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall,
                                ),
                              ),

                              Gap(AppLayout.getHeight(20)),
                              Container(
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  giveaway['startAt'] != null
                                      ? 'End Date: ${DateFormat('dd-MM-yyyy - HH:mm a').format(DateTime.parse(giveaway['endAt']))}'
                                      : 'No Date',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall,
                                ),
                              ),

                              Gap(AppLayout.getHeight(20)),
                              Container(
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  giveaway['giveawayStatus'] == 'REWARD_DISTRIBUTION_IN_PROGRESS'
                                      ? 'Status: DISTRIBUTING REWARD'
                                      : 'Status: ${giveaway['giveawayStatus']}',
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                              ),

                              Gap(AppLayout.getHeight(20)),
                              Container(
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  "Participation: ${giveaway['participantsCount']}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall,
                                ),
                              ),
                              Gap(AppLayout.getHeight(30)),
                              giveaway['giveawayStatus'] == "REWARD_DISTRIBUTION_IN_PROGRESS" ? Column(
                                children: [
                                  Container(
                                    alignment: Alignment.bottomLeft,
                                    child: Text(
                                      "Winner: ",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                  ),
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
                                            backgroundImage: NetworkImage(winnerUser['avatar']??"https://upload.wikimedia.org/wikipedia/commons/d/d1/Image_not_available.png"),
                                          ),
                                        ),
                                      ),
                                      Gap(AppLayout.getHeight(20)),
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              winnerUser.isNotEmpty
                                                  ? winnerUser['fullName'] :
                                              'No Name', style: TextStyle(fontSize: 12),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Gap(AppLayout.getHeight(5)),
                                            Text(
                                              winnerUser.isNotEmpty
                                                  ? winnerUser['email'] :
                                              'No Name', style: TextStyle(fontSize: 12),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),

                                          ],
                                        ),
                                      ),

                                    ],
                                  ),

                                ],
                              ) : Container(),
                            ],
                          ),
                        );
                      })
                else if (loadFinished! && giveawayList.isEmpty)
                  SizedBox(
                    width: AppLayout.getScreenWidth(),
                    height: AppLayout.getScreenHeight()-200,
                    child: Center(
                      child: Text("It doesn't have any giveaway"),
                    ),
                  )
                else
                  SizedBox(
                    width: AppLayout.getScreenWidth(),
                    height: AppLayout.getScreenHeight()-200,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),

              ],
            )
        ),
      ),
    );
  }
}
