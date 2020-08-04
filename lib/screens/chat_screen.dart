import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../widgets/chat/messages.dart';
import '../widgets/chat/new_message.dart';
import '../screens/profile_screen.dart';

class ChatScreen extends StatefulWidget {
  final String chatRoomId;
  ChatScreen(this.chatRoomId);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
    final fbm = FirebaseMessaging();
    fbm.configure(
      onMessage: (msg) {
        print(msg);
        return;
      },
      onLaunch: (msg) {
        print(msg);
        return;
      },
      onResume: (msg) {
        print(msg);
        return;
      },
    );
    fbm.subscribeToTopic('chat');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DashChat'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => ProfileScreen(),
                ),
              );
            },
          )
        ],
      ),
      body: Container(
        color: Colors.transparent,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Messages(widget.chatRoomId),
            ),
            NewMessage(widget.chatRoomId),
          ],
        ),
      ),
    );
  }
}
