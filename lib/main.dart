// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:dass_frontend/admin/admin_dashboard.dart';
import 'package:dass_frontend/admin/users_view.dart';
import 'package:dass_frontend/admin/create_user.dart';
import 'package:dass_frontend/views/signin_screen.dart';
import 'package:dass_frontend/views/splash_screen.dart';
import 'package:dass_frontend/user/user_dashboard.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: splashScreen(),
      routes: {
        SigninScreen.routeName: (ctx) => SigninScreen(),
        AdminDashboard.routeName: (ctx) => AdminDashboard(),
        UsersView.routeName: (ctx) => UsersView(),
        CreateUser.routeName: (ctx) => CreateUser(),
        UserDashboard.routeName: (ctx) => UserDashboard(
              quizId: null,
            ),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
