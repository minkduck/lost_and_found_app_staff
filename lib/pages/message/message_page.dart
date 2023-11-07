import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lost_and_found_app_staff/data/api/message/Chat.dart';
import 'package:lost_and_found_app_staff/pages/home/home_page.dart';
import 'package:lost_and_found_app_staff/pages/message/chat_page.dart';
import 'package:lost_and_found_app_staff/utils/app_layout.dart';
import 'package:lost_and_found_app_staff/utils/colors.dart';
import 'package:lost_and_found_app_staff/widgets/big_text.dart';

import 'chat_card.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(AppLayout.getWidth(20.0), 0,
                AppLayout.getWidth(20.0), AppLayout.getWidth(20.0)),
            color: AppColors.primaryColor,
            child: Column(
              children: [
                Gap(AppLayout.getHeight(40)),
                Row(
                  children: [
                    Text("Chats", style: Theme.of(context).textTheme.titleMedium,)
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: chatsData.length,
              itemBuilder: (context, index) => ChatCard(
                chat: chatsData[index],
                press: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChatPage(),
                  ),
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
