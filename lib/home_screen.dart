import 'package:flutter/material.dart';
import 'screen/login_screen.dart';
import 'screen/register_screen.dart';
import 'screen/profile_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen()));
              },
              child: Text('Login'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterScreen()));
              },
              child: Text('Register'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen()));
              },
              child: Text('Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
