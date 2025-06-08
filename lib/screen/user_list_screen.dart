import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/user_service.dart';
import 'user_profile_screen.dart'; // We'll create this for read-only profiles

class UserListScreen extends StatelessWidget {
  final UserService userService = UserService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: StreamBuilder<QuerySnapshot>(
        stream: userService.getAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error loading users'));
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final users = snapshot.data!.docs;

          if (users.isEmpty) {
            return Center(child: Text('No users found.'));
          }

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final userData = users[index].data() as Map<String, dynamic>;
              final displayName = userData['displayName'] ?? 'No Name';
              final email = userData['email'] ?? '';
              final uid = users[index].id;

              return ListTile(
                title: Text(displayName),
                subtitle: Text(email),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProfileScreen(uid: uid),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
