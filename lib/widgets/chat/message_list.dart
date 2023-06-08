//Created by giangtpu on 07/06/2023.
//Giangbb Studio
//giangtpu@gmail.com
import 'package:flutter/material.dart';
import 'package:whatsup/data/mock.dart';
import 'package:whatsup/widgets/chat/my_message_card.dart';
import 'package:whatsup/widgets/chat/sender_message_card.dart';

class MessageList extends StatelessWidget {
  const MessageList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: mockMessages.length,
      itemBuilder: (context, index) {
        if (mockMessages[index]['isMe'] == true) {
          return MyMessageCard(
            message: mockMessages[index]['text'].toString(),
            date: mockMessages[index]['time'].toString(),
          );
        }
        return SenderMessageCard(
          message: mockMessages[index]['text'].toString(),
          date: mockMessages[index]['time'].toString(),
        );
      },
    );
  }
}
