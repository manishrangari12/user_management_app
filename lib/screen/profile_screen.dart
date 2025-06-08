import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import '../../auth_service.dart';
import 'user_list_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _imageFile;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _imageFile = File(picked.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthService>();
    final user = auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.group),
            tooltip: 'View Users',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => UserListScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              await auth.signOut();
            },
          ),
        ],
      ),
      body: user == null
          ? Center(child: Text('No user found'))
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _imageFile != null
                    ? FileImage(_imageFile!)
                    : null,
                child: _imageFile == null
                    ? Text(
                  user.displayName != null && user.displayName!.isNotEmpty
                      ? user.displayName!.substring(0, 1).toUpperCase()
                      : 'U',
                  style: TextStyle(fontSize: 40),
                )
                    : null,
              ),
            ),
            SizedBox(height: 20),
            Text(
              user.displayName ?? 'No Name',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(user.email ?? 'No Email'),
            SizedBox(height: 40),
            ElevatedButton.icon(
              icon: Icon(Icons.edit),
              label: Text('Edit Profile'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => EditProfileScreen(user: user)),
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(Icons.group),
              label: Text('View Registered Users'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => UserListScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
