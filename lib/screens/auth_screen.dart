import 'dart:io';

import 'package:akkay_chat_app/screens/login.page.dart';
import 'package:akkay_chat_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;
  final databaseMethods = DatabaseMethods();

  void _submitAuthForm(
    String email,
    String password,
    bool isLogin,
    String username,
    File image,
    BuildContext ctx,
  ) async {
    AuthResult authResult;

    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        //...
        final ref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child(authResult.user.uid + '.jpg');

        await ref.putFile(image).onComplete;

        final url = await ref.getDownloadURL();

        await databaseMethods.uploadUserInfo(authResult.user.uid, {
          'username': username,
          'email': email,
          'image_url': url,
        });
      }
    } on PlatformException catch (err) {
      var message = 'An error occured, please check your credentials!';

      if (err.message != null) {
        message = err.message;
      }

      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          // elevation: 60,
          behavior: SnackBarBehavior.floating,
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      setState(() {
        _isLoading = false;
      });
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: LoginPage(
      _submitAuthForm,
      _isLoading,
    ));
  }
}
