import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lost_and_found_app_staff/data/api/comment/comment_controller.dart';
import 'package:lost_and_found_app_staff/data/api/post/post_controller.dart';

import '../../test/time/time_widget.dart';
import '../../utils/app_assets.dart';
import '../../utils/app_constraints.dart';
import '../../utils/app_layout.dart';
import '../../utils/colors.dart';
import '../../widgets/big_text.dart';
import '../../widgets/icon_and_text_widget.dart';

class PostDetail extends StatefulWidget {
  final int pageId;
  final String page;

  const PostDetail({Key? key, required this.pageId, required this.page})
      : super(key: key);

  @override
  State<PostDetail> createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  bool _isMounted = false;

  Map<String, dynamic> postList = {};
  final PostController postController = Get.put(PostController());
  List<dynamic> commentList = [];
  final CommentController commentController = Get.put(CommentController());
  var commentTextController = TextEditingController();
  var editCommentTextController = TextEditingController();
  late String uid = "";

  Future<void> postCommentAndReloadComments(String comment) async {
    await CommentController().postCommentByPostId(widget.pageId, comment);
    commentTextController.clear();
    final result = await commentController.getCommentByPostId(widget.pageId);
    if (_isMounted) {
      setState(() {
        commentList = result;
      });
    }
  }
  Future<void> loadAndDisplayLocationNames(dynamic postList) async {
    if (postList['postLocationList'] != null) {
      List<dynamic> postLocationList = postList['postLocationList'];

      if (postLocationList.isNotEmpty) {
        List locationNames = postLocationList.map((location) {
          return location['locationName'];
        }).toList();
        print(locationNames);
        if (_isMounted) {
          setState(() {
            postList['postLocationNames'] = locationNames.join(', ');
          });
        }
      }
    }
  }
  Future<void> loadAndDisplayCategoryNames(dynamic postList) async {
    if (postList['postCategoryList'] != null) {
      List<dynamic> postCategoryList = postList['postCategoryList'];

      if (postCategoryList.isNotEmpty) {
        List categoryNames = postCategoryList.map((caregories) {
          return caregories['name'];
        }).toList();
        print(categoryNames);
        if (_isMounted) {
          setState(() {
            postList['postCategoryNames'] = categoryNames.join(', ');
          });
        }
      }
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
    await postController.getPostListById(widget.pageId).then((result) {
      if (_isMounted) {
        setState(() {
          postList = result;
        });
      }
    });
    await commentController.getCommentByPostId(widget.pageId).then((result) {
      if (_isMounted) {
        setState(() {
          commentList = result;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    Future.delayed(Duration(seconds: 0), () async {
      await postController.getPostListById(widget.pageId).then((result) {
        if (_isMounted) {
          setState(() {
            postList = result;
          });
        }
      });
      await commentController.getCommentByPostId(widget.pageId).then((result) {
        if (_isMounted) {
          setState(() {
            commentList = result;
          });
        }
      });
      uid = await AppConstrants.getUid();
      loadAndDisplayLocationNames(postList);
      loadAndDisplayCategoryNames(postList);
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12.0),                child: SingleChildScrollView(

      child: postList.isNotEmpty ? Column(
                  children: [
                    Gap(AppLayout.getHeight(50)),
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
                              text: "Post",
                              size: 20,
                              color: AppColors.secondPrimaryColor,
                              fontW: FontWeight.w500,
                            ),
                          ],
                        ),
                        Row(children: [
                          GestureDetector(
                            onTap: () async {
                              await postController.deleteItemById(postList['id']);
                            },
                            child: Text("Delete", style: TextStyle(color: Colors.redAccent, fontSize: 20),),
                          ),

                        ],)
                      ],
                    ),
                    Gap(AppLayout.getHeight(30)),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).cardColor,
                      ),
                      // color: Colors.red,
                      margin: EdgeInsets.only(bottom: AppLayout.getHeight(20)),
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundImage:
                                    NetworkImage(postList['user']['avatar']!),
                              ),
                              Gap(AppLayout.getHeight(15)),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    postList['user']['fullName'] ?? 'No Name',
                                    style: Theme.of(context).textTheme.titleSmall,
                                  ),
                                  Gap(AppLayout.getHeight(5)),
                                  Text(
                                    postList['createdDate'] != null
                                        ? '${TimeAgoWidget.formatTimeAgo(DateTime.parse(postList['createdDate']))}  --  '
                                        '${DateFormat('dd-MM-yyyy').format(DateTime.parse(postList['createdDate']))}'
                                        : 'No Date',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey),
                                  )
                                ],
                              )
                            ],
                          ),
                          Gap(AppLayout.getHeight(30)),
                          Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                postList['title'] ?? 'No title',
                                style: Theme.of(context).textTheme.titleMedium,
                              )),
                          Gap(AppLayout.getHeight(15)),
                          Container(
                            height:
                            MediaQuery.of(context).size.height *
                                0.25,
                            // Set a fixed height or use any other value
                            child: ListView.builder(
                              padding: EdgeInsets.zero, // Add this line to set zero padding
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: postList['postMedias']
                                  .length,
                              itemBuilder: (context, indexs) {
                                return Container(
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.only(
                                      left: AppLayout.getWidth(20)),
                                  height: AppLayout.getHeight(151),
                                  width: AppLayout.getWidth(180),
                                  child: Image.network(
                                      postList['postMedias']
                                      [indexs]['media']['url'] ?? Container(),
                                      fit: BoxFit.fill),
                                );
                              },
                            ),
                          ),
                          Gap(AppLayout.getHeight(10)),
                          Container(
                            child: Text(postList['postContent'],
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                          Gap(AppLayout.getHeight(30)),
                          Row(
                            children: [
                              Icon(
                                Icons.category,
                                color: Theme.of(context).iconTheme.color,
                                size: AppLayout.getHeight(24),
                              ),
                              const Gap(5),
                              Expanded(
                                child: Text(
                                  postList['postCategoryNames'] ?? 'No Categories',
                                  maxLines: 5,
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
                                  postList['postLocationNames'] ?? 'No Locations',
                                  maxLines: 5,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          Gap(AppLayout.getHeight(15)),
                          Row(
                            children: [
                              Icon(
                                Icons.timer_sharp,
                                color: Theme.of(context).iconTheme.color,
                                size: AppLayout.getHeight(24),
                              ),
                              const Gap(5),
                              postList['lostDateFrom'] != null || postList['lostDateTo'] != null ? Row(
                                children: [
                                  Text(
                                    postList['lostDateFrom'] != null
                                        ? DateFormat('yyyy-MM-dd').format(DateTime.parse(postList['lostDateFrom']))
                                        : '-',
                                    maxLines: 5,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(" to "),
                                  Text(
                                    postList['lostDateTo'] != null
                                        ? DateFormat('yyyy-MM-dd').format(DateTime.parse(postList['lostDateTo']))
                                        : '-',
                                    maxLines: 5,
                                    overflow: TextOverflow.ellipsis,
                                  ),

                                ],
                              ) : Text("Don't remember"),
                            ],
                          ),
                          Gap(AppLayout.getHeight(15)),
                          Row(
                            children: [
                              Icon(
                                Icons.check_box,
                                color: Theme.of(context).iconTheme.color,
                                size: AppLayout.getHeight(24),
                              ),
                              const Gap(5),
                              Text(
                                postList['postStatus'] ?? 'No Status',
                                style: TextStyle(
                                  color: _getStatusColor(postList['postStatus']),
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),

                          Gap(AppLayout.getHeight(30)),
                        ],
                      ),
                    ),
                  ],
                )
                    : SizedBox(
                  width: AppLayout.getWidth(100),
                  height: AppLayout.getHeight(300),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
