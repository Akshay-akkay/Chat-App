import 'package:akkay_chat_app/screens/chat_screen.dart';
import 'package:akkay_chat_app/services/database.dart';
import 'package:akkay_chat_app/widgets/custom_search_bar.dart/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    final databaseMethods = Provider.of<DatabaseMethods>(context);
    final searchData = databaseMethods.userSearchData;

    getChatRoomId(String a, String b) {
      if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
        return "$b\_$a";
      } else {
        return "$a\_$b";
      }
    }

    /// create chatroom, send user to conversation screen with pushreplace

    void createChatroomAndStartConversation(
        String userId, String username) async {
      String myname = await databaseMethods.getCurrentUsername();
      String myId = await databaseMethods.getCurrentUserId();
      print('$myId <<<<<<<<<<<<<<<<<<<<<<<<<=========================');
      String chatroomId = getChatRoomId(myId, userId);

      List<String> users = [userId, myId];
      List<String> usernames = [username, myname];

      Map<String, dynamic> chatroomMap = {
        'users': users,
        'chatroomId': chatroomId,
        'usernames': usernames,
      };
      databaseMethods.createChatRoom(chatroomId, chatroomMap);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (ctx) => ChatScreen(chatroomId),
        ),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(
        appBar: AppBar(),
        needBackOption: true,
      ),
      body: Container(
        child: ListView.builder(
          itemCount: searchData != null ? searchData.documents.length : null,
          itemBuilder: (ctx, i) {
            return Container(
              margin: EdgeInsets.all(8),
              child: Row(
                children: <Widget>[
                  if (searchData != null)
                    CircleAvatar(
                      radius: 26,
                      backgroundImage: NetworkImage(
                        searchData.documents[i].data['image_url'],
                      ),
                    ),
                  if (searchData != null) SizedBox(width: 16),
                  if (searchData != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          searchData.documents[i].data['username'],
                        ),
                        Text(
                          searchData.documents[i].data['email'],
                        ),
                      ],
                    ),
                  if (searchData != null) Spacer(),
                  if (searchData != null)
                    GestureDetector(
                      onTap: () {
                        createChatroomAndStartConversation(
                          searchData.documents[i].documentID,
                          searchData.documents[i].data['username'],
                        );
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.lightBlueAccent,
                                Colors.pinkAccent,
                              ]),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Icon(
                          FontAwesome.send,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
