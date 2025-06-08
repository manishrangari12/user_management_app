import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screen/login_screen.dart';      // You will create this
import 'screen/profile_screen.dart';    // You will create this

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = context.watch<User?>();

    if (user == null) {
      return LoginScreen();
    } else {
      return ProfileScreen();
    }
  }
}
