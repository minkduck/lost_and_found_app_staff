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
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
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
              if (giveawayList.isNotEmpty)
              ListView.builder(
                  shrinkWrap: true,
                  reverse: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: giveawayList.length,
                  itemBuilder: (BuildContext context, int index) {
                    final giveaway = giveawayList[index];
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
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Status: ",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall,
                                  ),
                                  TextSpan(
                                    text: "${giveaway['giveawayStatus']}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall?.copyWith(color: AppColors.primaryColor),
                                  ),
                                ],
                              ),
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
                          Gap(AppLayout.getHeight(20)),
                          giveaway['giveawayStatus'] == "CLOSED" ? Column(
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
              else if (giveawayList.isEmpty && loadFinished!)
                SizedBox(
                  width: AppLayout.getScreenWidth(),
                  height: AppLayout.getScreenHeight()-200,
                  child: Center(
                    child: Text("It don't have any giveaway"),
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
