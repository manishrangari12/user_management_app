import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/user_service.dart';
import 'edit_profile_screen.dart';
import 'other_users_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatelessWidget {
  final String uid;
  final UserService userService = UserService();

  ProfileScreen({required this.uid});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final User? user = FirebaseAuth.instance.currentUser;  // get current user

    return Scaffold(
      appBar: AppBar(title: Text('My Profile')),
      body: StreamBuilder<DocumentSnapshot>(
        stream: userService.getUserProfile(uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading profile',
                style: TextStyle(color: theme.colorScheme.error),
              ),
            );
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.data() as Map<String, dynamic>?;

          if (data == null) {
            return Center(child: Text('Profile not found.'));
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: theme.primaryColorLight,
                  child: Text(
                    (data['displayName'] ?? 'U').substring(0, 1).toUpperCase(),
                    style: TextStyle(fontSize: 40, color: Colors.white),
                  ),
                ),
                SizedBox(height: 20),
                Text('Name:', style: theme.textTheme.titleMedium),
                Text(data['displayName'] ?? '', style: theme.textTheme.titleLarge),
                SizedBox(height: 10),
                Text('Email:', style: theme.textTheme.titleMedium),
                Text(data['email'] ?? '', style: theme.textTheme.bodyLarge),
                SizedBox(height: 10),
                Text('Bio:', style: theme.textTheme.titleMedium),
                Text(data['bio'] ?? '', style: theme.textTheme.bodyMedium),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      icon: Icon(Icons.edit),
                      label: Text('Edit Profile'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      onPressed: user == null
                          ? null
                          : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditProfileScreen(user: user),
                          ),
                        );
                      },
                    ),
                    ElevatedButton.icon(
                      icon: Icon(Icons.group),
                      label: Text('View Users'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        backgroundColor: theme.colorScheme.secondary,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => OtherUsersScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
