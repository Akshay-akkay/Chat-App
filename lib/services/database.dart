import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class DatabaseMethods with ChangeNotifier {
  var _getUserByUserNameSearchData;
  var currentUserId;
  var currentUserName;

  void getUserByUsername(String username) async {
    _getUserByUserNameSearchData = await Firestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .getDocuments();
    notifyListeners();
  }

  getUserByUserEmail(String username) async {
    return await Firestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .getDocuments();
  }

  getUserByUserId(String userId) async {
    String chatusername;
    var chatUserData =
        await Firestore.instance.collection('users').document(userId).get();
    chatusername = chatUserData['username'];
    return chatusername;
  }

  get userSearchData {
    return _getUserByUserNameSearchData;
  }

  uploadUserInfo(uid, userMap) {
    Firestore.instance
        .collection('users')
        .document(uid)
        .setData(userMap)
        .catchError((e) {
      print(e);
    });
  }

  getCurrentUserId() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    currentUserId = user.uid;
    return currentUserId;
  }

  getCurrentUsername() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    currentUserId = user.uid;
    var currentUserData = await Firestore.instance
        .collection('users')
        .document(currentUserId)
        .get();
    currentUserName = currentUserData['username'];
    return currentUserName;
  }

  createChatRoom(String chatroomId, chatroomMap) {
    Firestore.instance
        .collection('chatroom')
        .document(chatroomId)
        .setData(chatroomMap)
        .catchError((e) {
      print(e);
    });
  }

  addConversationMessages(String chatroomId, messageMap) {
    Firestore.instance
        .collection('chatroom')
        .document(chatroomId)
        .collection('chats')
        .add(messageMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getConversationMessages(String chatroomId) {
    return Firestore.instance
        .collection('chatroom')
        .document(chatroomId)
        .collection('chats')
        .orderBy(
          'createdAt',
          descending: true,
        )
        .snapshots();
  }

  getChatRooms(String userId) {
    return Firestore.instance
        .collection('chatroom')
        .where('users', arrayContains: userId)
        .snapshots();
  }
}
