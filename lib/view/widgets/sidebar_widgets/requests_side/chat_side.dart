import 'package:flutter/material.dart';
import 'package:layout/layout.dart';

import '../../../../utils/constants.dart';
import '../../common/custom_button.dart';
import '../../common/custom_text_field.dart';
import '../../ui_widgets/appbar_widget/user_avatar.dart';
import 'chat_item.dart';

class ChatSide extends StatefulWidget {
  const ChatSide({super.key});

  @override
  State<ChatSide> createState() => _ChatSideState();
}

class _ChatSideState extends State<ChatSide> {
  final textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final mockMessages = [
      ChatMessage(
          content: 'How can I help you?',
          from: 'clerk',
          timestamp: DateTime.now()),
    ];
    return Scaffold(
      key: const Key('requestUserSide'),
      backgroundColor: Colors.transparent,
      appBar: _appBar(context),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg_pattern.png"),
            repeat: ImageRepeat.repeat,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                child: ListView.builder(
                  reverse: true,
                  itemCount: mockMessages.length,
                  itemBuilder: (context, index) {
                    final message = mockMessages[index];
                    final received = message.from == 'Prova';
                    return ChatItemWidget(
                      content: message.content,
                      received: received,
                      timestamp: message.timestamp,
                      key: Key(
                        message.content + (message.timestamp.toIso8601String()),
                      ),
                    );
                  },
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(11),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: textController,
                      onChanged: (text) {},
                      hintText: 'Type a message',
                      prefixIcon: (Icons.message),
                    ),
                  ),
                  const Gutter(),
                  CustomButton(
                    outline: false,
                    transparent: false,
                    onPressed: () {
                      textController.clear();
                      mockMessages.add(
                        ChatMessage(
                          content: textController.text,
                          from: 'me',
                          timestamp: DateTime.now(),
                        ),
                      );
                    },
                    child: const Text('Send'),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(right: 16),
          child: Row(
            children: <Widget>[
              const SizedBox(width: 12),
              UserAvatar(
                avatarUrl: userAvatar,
                onPressed: () {},
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Text(
                      'Clerk',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'online',
                      style: TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatMessage {
  final String content;
  final String from;
  final DateTime timestamp;

  ChatMessage(
      {required this.content, required this.from, required this.timestamp});
}
