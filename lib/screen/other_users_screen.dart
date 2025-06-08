import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_profile_screen.dart';

class OtherUsersScreen extends StatelessWidget {
  final CollectionReference usersCollection =
  FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text('Registered Users')),
      body: StreamBuilder<QuerySnapshot>(
        stream: usersCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Text('Error loading users',
                    style: TextStyle(color: theme.colorScheme.error)));
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data!.docs;

          if (users.isEmpty) {
            return Center(child: Text('No users found.'));
          }

          return ListView.separated(
            itemCount: users.length,
            separatorBuilder: (_, __) => Divider(),
            itemBuilder: (context, index) {
              final userDoc = users[index];
              final userData = userDoc.data() as Map<String, dynamic>?;

              final displayName = userData?['displayName'] ?? 'No name';
              final email = userData?['email'] ?? 'No email';

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: theme.primaryColorLight,
                  child: Text(
                    displayName.isNotEmpty
                        ? displayName[0].toUpperCase()
                        : '?',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(displayName),
                subtitle: Text(email),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProfileScreen(uid: userDoc.id),
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
