import 'package:akkay_chat_app/services/database.dart';
import 'package:akkay_chat_app/widgets/chat/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatefulWidget {
  final String chatroomId;
  Messages(this.chatroomId);

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  void initState() {
    super.initState();
    chatMessagesStream =
        databaseMethods.getConversationMessages(widget.chatroomId);
  }

  final databaseMethods = DatabaseMethods();

  Stream chatMessagesStream;

  // Widget ChatMessageList() {
  //   databaseMethods.getConversationMessages(widget.chatroomId).then((value) {
  //     chatMessagesStream = value;
  //   });
  //   return StreamBuilder(
  //     stream: chatMessagesStream,
  //     builder: (ctx, snapshot) {
  //       return ListView.builder(
  //         reverse: true,
  //         itemCount: snapshot.data.length,
  //         itemBuilder: (ctx, index) => MessageBubble(
  //           chatDocs[index]['text'],
  //           chatDocs[index]['userId'] == futureSnapshot.data.uid,
  //           chatDocs[index]['username'],
  //           chatDocs[index]['userImage'],
  //           key: ValueKey(
  //             chatDocs[index].documentID,
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (ctx, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder(
          stream: chatMessagesStream,
          builder: (ctx, chatSnapshot) {
            if (chatSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final chatDocs = chatSnapshot.data.documents;
            return ListView.builder(
              reverse: true,
              itemCount: chatDocs.length,
              itemBuilder: (ctx, index) => MessageBubble(
                chatDocs[index]['message'],
                chatDocs[index]['userId'] == futureSnapshot.data.uid,
                chatDocs[index]['username'],
                chatDocs[index]['userImage'],
                key: ValueKey(
                  chatDocs[index].documentID,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
