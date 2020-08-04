import 'package:akkay_chat_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  CustomAppBar({
    Key key,
    this.appBar,
    this.needBackOption = false,
  }) : super(key: key);

  final AppBar appBar;
  final bool needBackOption;

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
}

final searchTextEditingController = TextEditingController();

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    final databaseMethods = Provider.of<DatabaseMethods>(context);
    return AppBar(
      backgroundColor: Colors.pinkAccent,
      elevation: 0,
      leading: FlatButton(
        focusColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        splashColor: Colors.white30,
        onPressed: () {
          if (widget.needBackOption) {
            Navigator.pop(context);
          }
        },
        child: Icon(
          widget.needBackOption ? Feather.arrow_left : Feather.feather,
          color: Colors.white,
          size: 25,
        ),
      ),
      centerTitle: true,
      title: TextField(
        controller: searchTextEditingController,
        style: TextStyle(
          color: Colors.white,
        ),
        decoration: InputDecoration(
          hintText: 'Search username..',
          hintStyle: TextStyle(
            color: Colors.white54,
          ),
          border: InputBorder.none,
        ),
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(.8),
                  Colors.grey,
                ],
              ),
            ),
            child: FlatButton(
              focusColor: Colors.white,
              splashColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              child: Icon(
                Feather.search,
                size: 22,
                color: Colors.white,
              ),
              onPressed: () {
                databaseMethods
                    .getUserByUsername(searchTextEditingController.text);
              },
            ),
          ),
        ),
      ],
    );
  }
}
