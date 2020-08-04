import 'package:akkay_chat_app/screens/auth_screen.dart';
import 'package:akkay_chat_app/screens/main_screen.dart';
import 'package:akkay_chat_app/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => DatabaseMethods(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Chat',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.pink,
          backgroundColor: Colors.pink,
          accentColor: Colors.lightBlue,
          accentColorBrightness: Brightness.dark,
          errorColor: Colors.redAccent,
          buttonTheme: ButtonTheme.of(context).copyWith(
            buttonColor: Colors.lightBlueAccent,
            textTheme: ButtonTextTheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.onAuthStateChanged,
          builder: (ctx, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return SplashScreen();
            }
            if (userSnapshot.hasData) {
              return MainScreen();
            }
            return AuthScreen();
          },
        ),
      ),
    );
  }
}
