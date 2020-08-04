import 'package:akkay_chat_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class NewMessage extends StatefulWidget {
  final String chatRoomId;
  NewMessage(this.chatRoomId);

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = new TextEditingController();
  var _enteredMessage = '';

  // void _sendMessage() async {
  //   FocusScope.of(context).unfocus();
  //   final user = await FirebaseAuth.instance.currentUser();
  //   final userData =
  //       await Firestore.instance.collection('users').document(user.uid).get();
  //   Firestore.instance.collection('chat').add({
  //     'text': _enteredMessage,
  //     'createdAt': Timestamp.now(),
  //     'userId': user.uid,
  //     'username': userData['username'],
  //     'userImage': userData['image_url'],
  //   });
  //   _controller.clear();
  // }

  final databaseMethods = DatabaseMethods();

  _sendMessage() async {
    FocusScope.of(context).unfocus();
    final user = await FirebaseAuth.instance.currentUser();
    final userData =
        await Firestore.instance.collection('users').document(user.uid).get();
    Map<String, dynamic> messageMap = {
      'message': _enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData['username'],
      'userImage': userData['image_url'],
    };
    databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35),
        color: Colors.blueGrey,
      ),
      // margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.all(4),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.white.withOpacity(.5),
              ),
              padding: EdgeInsets.all(0),
              child: TextField(
                controller: _controller,
                // keyboardType: TextInputType.multiline,
                autocorrect: true,
                textCapitalization: TextCapitalization.sentences,
                enableSuggestions: true,
                cursorColor: Colors.pink,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  labelStyle: TextStyle(color: Colors.white),
                  hintText: 'Send a message.',
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                ),
                onChanged: (value) {
                  setState(() {
                    _enteredMessage = value;
                  });
                },
              ),
            ),
          ),
          SizedBox(
            width: 8,
          ),
          CircleAvatar(
            radius: 23,
            backgroundColor: Colors.white.withOpacity(.6),
            child: IconButton(
              icon: Icon(
                FontAwesome.send,
                color: Colors.black,
              ),
              onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
            ),
          )
        ],
      ),
    );
  }
}
