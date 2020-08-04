import 'dart:io';

import 'package:akkay_chat_app/widgets/pickers/user_image_picker.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage(this.submitFn, this.isLoading);

  final bool isLoading;
  final void Function(
    String email,
    String password,
    bool isLogin,
    String username,
    File image,
    BuildContext ctx,
  ) submitFn;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _userEmail = '';
  String _userPassword = '';
  String _userName = '';
  bool _isLogin = true;
  File _userImageFile;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    if (_userImageFile == null && !_isLogin) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Please Pick An Image.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    if (isValid) {
      _formKey.currentState.save();
      FocusScope.of(context).unfocus();
      widget.submitFn(
        _userEmail,
        _userPassword,
        _isLogin,
        _userName,
        _userImageFile,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.lightBlueAccent,
                Colors.pink,
              ]),
        ),
        child: ListView(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 60, left: 10),
                        child: RotatedBox(
                            quarterTurns: -1,
                            child: Text(
                              _isLogin ? 'Sign In' : 'Sign Up',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 38,
                                fontWeight: FontWeight.w900,
                              ),
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0, left: 10.0),
                        child: Container(
                          //color: Colors.green,
                          height: 200,
                          width: 250,
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: 60,
                              ),
                              Center(
                                child: Text(
                                  _isLogin
                                      ? 'A world of possibility in an app.'
                                      : 'We can start something new.',
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (!_isLogin) UserImagePicker(_pickedImage),
                  if (!_isLogin)
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 50, left: 50, right: 50),
                      child: Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        child: TextFormField(
                          key: ValueKey('name'),
                          autocorrect: true,
                          textCapitalization: TextCapitalization.words,
                          enableSuggestions: false,
                          validator: (value) {
                            if (value.isEmpty || value.length < 4) {
                              return 'Name seems to be too short. Must be 4 characters long';
                            }
                            return null;
                          },
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            fillColor: Colors.lightBlueAccent,
                            labelText: 'Name',
                            labelStyle: TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                          onSaved: (value) {
                            _userName = value;
                          },
                        ),
                      ),
                    ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 50, right: 50),
                    child: Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                        key: ValueKey('email'),
                        autocorrect: false,
                        textCapitalization: TextCapitalization.none,
                        enableSuggestions: false,
                        validator: (value) {
                          if (value.isEmpty || !value.contains('@')) {
                            return 'Email Address doesn\'t seam right.';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          fillColor: Colors.lightBlueAccent,
                          labelText: 'E-Mail',
                          labelStyle: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                        onSaved: (value) {
                          _userEmail = value;
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 50, right: 50),
                    child: Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                        key: ValueKey('pass'),
                        validator: (value) {
                          if (value.isEmpty || value.length < 7) {
                            return 'Password seems too short. Must be 6 characters long.';
                          }
                          return null;
                        },
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        obscureText: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Password',
                          labelStyle: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                        onSaved: (value) {
                          _userPassword = value;
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 40, right: 50, left: 200),
                    child: Container(
                      alignment: Alignment.bottomRight,
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue[300],
                            blurRadius:
                                10.0, // has the effect of softening the shadow
                            spreadRadius:
                                1.0, // has the effect of extending the shadow
                            offset: Offset(
                              5.0, // horizontal, move right 10
                              5.0, // vertical, move down 10
                            ),
                          ),
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: FlatButton(
                        onPressed: _trySubmit,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            if (widget.isLoading)
                              Container(
                                  height: 15,
                                  width: 15,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  )),
                            if (!widget.isLoading)
                              Text(
                                _isLogin ? 'Sign In' : 'Sign Up',
                                style: TextStyle(
                                  color: Colors.lightBlueAccent,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.lightBlueAccent,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: _isLogin
                        ? MediaQuery.of(context).size.height / 4
                        : MediaQuery.of(context).size.height / 500,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 30, left: 55, right: 55),
                    child: Container(
                      alignment: Alignment.topRight,
                      //color: Colors.red,
                      height: 20,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            _isLogin
                                ? 'Your first time?'
                                : 'Have we met before?',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                          FlatButton(
                            padding: EdgeInsets.all(0),
                            onPressed: () {
                              setState(() {
                                _isLogin = !_isLogin;
                              });
                            },
                            child: Text(
                              _isLogin ? 'Sign Up' : 'Sign In',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
