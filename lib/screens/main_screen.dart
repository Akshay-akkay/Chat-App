import 'package:akkay_chat_app/screens/profile_screen.dart';
import 'package:akkay_chat_app/screens/search_screen.dart';
import 'package:akkay_chat_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final databaseMethods = DatabaseMethods();
  String myUserId;
  Stream chatRoomsStream;

  @override
  void initState() {
    super.initState();
    getUserName() async {
      myUserId = await databaseMethods.getCurrentUserId();
    }

    getUserName();
    getChatRooms() async {
      chatRoomsStream = databaseMethods.getChatRooms(myUserId);
    }

    getChatRooms();
  }

  String chatUsername;
  void getChatUsername(chatUserId) async {
    chatUsername = await databaseMethods.getUserByUserId(chatUserId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DashChat'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Feather.search),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => SearchScreen(),
                  ),
                );
              }),
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
      body: StreamBuilder(
        stream: chatRoomsStream,
        builder: (ctx, snapshot) {
          return ListView.builder(
            itemCount: snapshot.data.documents.length - 1,
            itemBuilder: (ctx, i) {
              String chatUserId = snapshot.data.documents[i].data['chatroomId']
                  .toString()
                  .replaceAll('_', "")
                  .replaceAll(myUserId, '');
              getChatUsername(chatUserId);
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://firebasestorage.googleapis.com/v0/b/akkay-chat.appspot.com/o/user_image%2FGSPLfA7ZrMMVvCMbCI2wJzTUdon2.jpg?alt=media&token=fd7408f4-2991-49a9-a153-0b79beef89c8'),
                ),
                title: Text(chatUsername != null ? chatUsername : 'nullllll'),
                subtitle: null,
                trailing: null,
              );
            },
          );
        },
      ),
    );
  }
}
