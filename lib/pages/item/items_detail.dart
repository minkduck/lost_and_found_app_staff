import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:lost_and_found_app_staff/utils/app_assets.dart';
import 'package:lost_and_found_app_staff/widgets/app_button.dart';
import 'package:lost_and_found_app_staff/widgets/icon_and_text_widget.dart';
import 'package:lost_and_found_app_staff/widgets/small_text.dart';
import 'package:lost_and_found_app_staff/widgets/status_widget.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:get/get.dart';

import '../../data/api/item/claim_controller.dart';
import '../../data/api/item/item_controller.dart';
import '../../data/api/item/receipt_controller.dart';
import '../../data/api/message/Chat.dart';
import '../../data/api/message/chat_controller.dart';
import '../../data/api/user/user_controller.dart';
import '../../routes/route_helper.dart';
import '../../utils/app_constraints.dart';
import '../../utils/app_layout.dart';
import '../../utils/colors.dart';
import '../../widgets/big_text.dart';
import '../../widgets/time_widget.dart';
import '../message/chat_page.dart';
import 'claim_items.dart';
import 'edit_item.dart';

class ItemsDetails extends StatefulWidget {
  final int pageId;
  final String page;
  const ItemsDetails({Key? key, required this.pageId, required this.page}) : super(key: key);

  @override
  State<ItemsDetails> createState() => _ItemsDetailsState();
}


class _ItemsDetailsState extends State<ItemsDetails> {

  late List<String> imageUrls = [
    // AppAssets.airpods,
    // AppAssets.airpods,
    // AppAssets.airpods,
    // AppAssets.airpods,
  ];
  final PageController _pageController = PageController();
  double currentPage = 0;

  bool _isMounted = false;
  late String uid = "";
  bool isItemClaimed = false;
  int itemId = 0;

  Map<String, dynamic> itemlist = {};
  final ItemController itemController = Get.put(ItemController());
  final ClaimController claimController = Get.put(ClaimController());
  final ReceiptController receiptController = Get.put(ReceiptController());
  final UserController userController = Get.put(UserController());
  List<Map<String, dynamic>> userReceiptList = [];
  List<dynamic> recepitList = [];

  Future<void> claimItem() async {
    try {
      await claimController.postClaimByItemId(itemId);
      setState(() {
        isItemClaimed = true;
      });
    } catch (e) {
      print('Error claiming item: $e');
    }
  }

  // Function to unclaim an item
  Future<void> unclaimItem() async {
    try {
      await claimController.postUnClaimByItemId(itemId);
      setState(() {
        isItemClaimed = false;
      });
    } catch (e) {
      print('Error unclaiming item: $e');
    }
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'ACTIVE':
        return AppColors.primaryColor;
      case 'RETURNED':
        return AppColors.secondPrimaryColor;
      case 'CLOSED':
        return Colors.red;
      default:
        return Colors.grey; // Default color, you can change it to your preference
    }
  }


  Future<void> _refreshData() async {
    await itemController.getItemListById(widget.pageId).then((result) {
      if (_isMounted) {
        setState(() {
          itemlist = result;
          if (itemlist != null) {
            if (itemlist['itemClaims'] != null && itemlist['itemClaims'] is List) {
              var claimsList = itemlist['itemClaims'];
              var matchingClaim = claimsList.firstWhere(
                    (claim) => claim['userId'] == uid,
                orElse: () => null,
              );

              if (matchingClaim != null) {
                isItemClaimed = matchingClaim['claimStatus'] == true ? true : false;
              }
            }
            if (itemlist['foundDate'] != null) {
              String foundDate = itemlist['foundDate'];
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

                  // Parse the original date
                  DateFormat originalDateFormat = DateFormat("yyyy-MM-dd");
                  DateTime originalDate = originalDateFormat.parse(date);

                  // Format the date in the desired format
                  DateFormat desiredDateFormat = DateFormat("dd-MM-yyyy");
                  String formattedDate = desiredDateFormat.format(originalDate);

                  // Update the foundDate in the itemlist
                  itemlist['foundDate'] = '$formattedDate $slot';
                }
              }
            }

          }
        });
      }
    });
    await receiptController.getReceiptByItemId(widget.pageId).then((result) async {
      if (_isMounted) {
        recepitList = result;
        for (var receipt in recepitList) {
          final userId = receipt['receiverId'];
          final userMap = await userController.getUserByUserId(userId);
          final Map<String, dynamic> claimInfo = {
            'receipt': receipt,
            'user': userMap != null ? userMap : null, // Check if user is null
          };
          print("claimInfo:" + claimInfo.toString());
          setState(() {
            userReceiptList.add(claimInfo);
          });
        }
      }

    });
  }


    @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        currentPage = _pageController.page ?? 0;
      });
    });
    itemId = widget.pageId;
    _isMounted = true;
    Future.delayed(Duration(seconds: 1), () async {
      uid = await AppConstrants.getUid();
      // uid = "FLtIEJvuMgfg58u4sXhzxPn9qr73";
      await itemController.getItemListById(widget.pageId).then((result) {
        if (_isMounted) {
          setState(() {
            itemlist = result;
            if (itemlist != null) {
              var itemMedias = itemlist['itemMedias'];

              if (itemMedias != null && itemMedias is List) {
                List mediaList = itemMedias;

                for (var media in mediaList) {
                  String imageUrl = media['media']['url'];
                  imageUrls.add(imageUrl);
                }
              }
              if (itemlist['itemClaims'] != null && itemlist['itemClaims'] is List) {
                var claimsList = itemlist['itemClaims'];
                var matchingClaim = claimsList.firstWhere(
                      (claim) => claim['userId'] == uid,
                  orElse: () => null,
                );

                if (matchingClaim != null) {
                  isItemClaimed = matchingClaim['claimStatus'] == true ? true : false;
                }
              }
              if (itemlist['foundDate'] != null) {
                String foundDate = itemlist['foundDate'];
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

                    // Parse the original date
                    DateFormat originalDateFormat = DateFormat("yyyy-MM-dd");
                    DateTime originalDate = originalDateFormat.parse(date);

                    // Format the date in the desired format
                    DateFormat desiredDateFormat = DateFormat("dd-MM-yyyy");
                    String formattedDate = desiredDateFormat.format(originalDate);

                    // Update the foundDate in the itemlist
                    itemlist['foundDate'] = '$formattedDate $slot';
                  }
                }
              }

            }
          });
        }
      });
      await receiptController.getReceiptByItemId(widget.pageId).then((result) async {
        if (_isMounted) {
          recepitList = result;
          for (var receipt in recepitList) {
            final userId = receipt['receiverId'];
            final userMap = await userController.getUserByUserId(userId);
            final Map<String, dynamic> claimInfo = {
              'receipt': receipt,
              'user': userMap != null ? userMap : null, // Check if user is null
            };
            print("claimInfo:" + claimInfo.toString());
            setState(() {
              userReceiptList.add(claimInfo);
            });
          }
        }

      });

    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: itemlist.isNotEmpty ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // Align children to the left
              children: [
                Gap(AppLayout.getHeight(20)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                          text: "Home",
                          size: 20,
                          color: AppColors.secondPrimaryColor,
                          fontW: FontWeight.w500,
                        ),
                      ],
                    ),
                    itemlist['user']['id'] == uid ? itemlist['itemStatus'] != 'RETURNED' ? Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditItem(
                                  itemId: itemId,
                                  initialCategory: itemlist['categoryName'], // Pass the initial data
                                  initialTitle: itemlist['name'], // Pass the initial data
                                  initialDescription: itemlist['description'], // Pass the initial data
                                  initialLocation: itemlist['locationName'],
                                  status: itemlist['itemStatus'],
                                  foundDate: itemlist['foundDate'],
                                ),
                              ),
                            );
                          },
                          child: Text("Edit", style: TextStyle(color: AppColors.primaryColor, fontSize: 20),),
                        ),
                        Gap(AppLayout.getWidth(15)),
                        GestureDetector(
                          onTap: () async {
                            await itemController.deleteItemById(itemId);
                          },
                          child: Text("Delete", style: TextStyle(color: Colors.redAccent, fontSize: 20),),
                        ),

                      ],
                    ) : Container() : Container()
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: AppLayout.getWidth(30), top: AppLayout.getHeight(10)),
                  child: Text('Items Details', style: Theme.of(context).textTheme.displayMedium,),
                ),
                Gap(AppLayout.getHeight(20)),

                Container(
                  margin: EdgeInsets.only(left: 20),
                  height: AppLayout.getHeight(350),
                  width: AppLayout.getWidth(350),
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: imageUrls.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.network(imageUrls[index]??"https://upload.wikimedia.org/wikipedia/commons/d/d1/Image_not_available.png",fit: BoxFit.fill,));
                      // child: Image.network(imageUrls[index],fit: BoxFit.fill,));               );
                    },
                  ),
                ),
                Center(
                  child: DotsIndicator(
                    dotsCount: imageUrls.isEmpty ? 1 : imageUrls.length,
                    position: currentPage,
                    decorator: const DotsDecorator(
                      size: Size.square(10.0),
                      activeSize: Size(20.0, 10.0),
                      activeColor: Colors.blue,
                      spacing: EdgeInsets.all(3.0),
                    ),
                  ),
                ),
                Gap(AppLayout.getHeight(20)),
                Text("   "+ itemlist['itemStatus'] ??
                    'No Status',style: TextStyle(color: _getStatusColor(itemlist['itemStatus']), fontSize: 20),),

                // Container(
                //     padding: EdgeInsets.only(left: AppLayout.getWidth(20)),
                //     child: StatusWidget(text: "Found", color: Colors.grey)),
                Padding(
                  padding: EdgeInsets.only(
                      left: AppLayout.getWidth(16), top: AppLayout.getHeight(16)),
                  child: Text(
                    itemlist.isNotEmpty
                        ? itemlist['name']
                        : 'No Name', // Provide a default message if item is not found
                    style: Theme.of(context).textTheme.labelMedium,
                  ),

                ),
                // create Date
                Container(
                    padding: EdgeInsets.only(
                        left: AppLayout.getWidth(16),
                        top: AppLayout.getHeight(8)),
                    child: IconAndTextWidget(
                        icon: Icons.timer_sharp,
                        text: itemlist['createdDate'] != null
                            ? "CreatedDate: " '${DateFormat('dd-MM-yyyy').format(DateTime.parse(itemlist['createdDate']))} at ${DateFormat('HH:mm:ss').format(DateTime.parse(itemlist['createdDate']))}'
                            : 'No Date',
                        iconColor: Colors.grey)),

                //foundDate
                Container(
                    padding: EdgeInsets.only(
                        left: AppLayout.getWidth(16),
                        top: AppLayout.getHeight(8)),
                    child: IconAndTextWidget(
                        icon: Icons.timer_sharp,
                        text: "FoundDate: " + itemlist['foundDate'],
                        iconColor: Colors.grey)),
                Gap(AppLayout.getHeight(5)),
                //category
                Container(
                    padding: EdgeInsets.only(
                        left: AppLayout.getWidth(16),
                        top: AppLayout.getHeight(8)),
                    child: IconAndTextWidget(
                        icon: Icons.category,
                        text: itemlist.isNotEmpty
                            ? itemlist['categoryName']
                            : 'No Location',
                        iconColor: Colors.black)),
                Gap(AppLayout.getHeight(5)),
                //location
                Container(
                    padding: EdgeInsets.only(
                        left: AppLayout.getWidth(16),
                        top: AppLayout.getHeight(8)),
                    child: IconAndTextWidget(
                        icon: Icons.location_on,
                        text: itemlist.isNotEmpty
                            ? itemlist['locationName']
                            : 'No Location',
                        iconColor: Colors.black)),
                //description
                Gap(AppLayout.getHeight(10)),
                Container(
                    padding: EdgeInsets.only(
                        left: AppLayout.getWidth(18),
                        top: AppLayout.getHeight(8)),
                    child: SmallText(
                      text: itemlist.isNotEmpty
                          ? itemlist['description']
                          : 'No Description',
                      size: 15,
                    )),
                //profile user
                Gap(AppLayout.getHeight(10)),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                          left: AppLayout.getWidth(16),
                          top: AppLayout.getHeight(8)),
                      child: CircleAvatar(
                        backgroundColor: Colors.grey[500],
                        radius: 50,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(itemlist['user']['avatar']??"https://upload.wikimedia.org/wikipedia/commons/d/d1/Image_not_available.png"),
                        ),
                      ),
                    ),
                    Gap(AppLayout.getHeight(50)),
                    Expanded(
                      child: Text(
                        itemlist.isNotEmpty
                          ? itemlist['user']['fullName'] :
                          'No Name', style: TextStyle(fontSize: 20),
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                      ),

                    )
                  ],
                ),
                Gap(AppLayout.getHeight(40)),
                itemlist['user']['id'] == uid ? Container() : Center(
                    child: AppButton(boxColor: AppColors.secondPrimaryColor, textButton: "Send Message", onTap: () async {
                      String otherUserId = itemlist['user']['id'];

                      await ChatController().createUserChats(uid, otherUserId);
                      // Get.toNamed(RouteHelper.getInitial(2));
                      String chatId = uid.compareTo(otherUserId) > 0 ? uid + otherUserId : otherUserId + uid;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                            chat: Chat(
                              uid: otherUserId,
                              name: itemlist['user']['fullName'] ?? 'No Name',
                              image: itemlist['user']['avatar'] ?? '',
                              lastMessage: '', // You may want to pass initial message if needed
                              time: '',
                              chatId:chatId, // You may want to pass the chatId if needed
                              formattedDate: '',
                              otherId: otherUserId,
                              date: DateTime.now(),
                            ),
                          ),
                        ),
                      );
/*                      BuildContext contextReference = context;

                      // Find the chatId based on user IDs
                      String myUid = await AppConstrants.getUid(); // Get current user ID
                      String chatId = myUid.compareTo(otherUserId) > 0 ? myUid + otherUserId : otherUserId + myUid;

                      // Navigate to ChatPage with the relevant chat information
                      Navigator.push(
                        contextReference, // Use the context reference
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                            chat: Chat(
                              chatId: chatId,
                              uid: myUid,
                              otherId: otherUserId,
                            ),
                          ),
                        ),
                      );*/
                    })),
                Gap(AppLayout.getHeight(20)),
                itemlist['itemStatus'] != 'RETURNED' ? itemlist['user']['id'] == uid ? Center(
                    child: AppButton(
                        boxColor: AppColors.secondPrimaryColor,
                        textButton: "List Claim",
                        onTap: () {
                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) => ClaimItems(pageId: widget.pageId, page: "Claim user",itemUserId: itemlist['user']['id'],)));
                        }))
                    : Container() : Column(
                  children: [
                    Text('Receiver: ',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    Padding(
                      padding:  EdgeInsets.only(left: 8.0),
                      child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: userReceiptList.length,
                          itemBuilder: (BuildContext context, int index) {
                            final userReceiptInfo = userReceiptList[index];
                            final claim = userReceiptInfo['claim'];
                            final user = userReceiptInfo['user'];
                            return Row(
                              children: [
                                Container(
                                  child: CircleAvatar(
                                    radius: 30,
                                    backgroundImage: NetworkImage(user['avatar']),
                                  ),
                                ),
                                Gap(AppLayout.getWidth(10)),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user['fullName'] ?? '-',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context).textTheme.titleMedium,
                                      ),
                                      Gap(AppLayout.getHeight(5)),
                                      Text(
                                        user['email'] ?? '-',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context).textTheme.titleSmall,
                                      ),

                                    ],
                                  ),
                                ),

                              ],
                            );
                          }

                      ),
                    )
                  ],
                ),
              ],
            )
                : SizedBox(
              width: AppLayout.getScreenWidth(),
              height: AppLayout.getScreenHeight(),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
