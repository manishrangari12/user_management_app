import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'edit_profile_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  String name = '';
  String email = '';
  String password = '';
  String confirmPassword = '';
  bool loading = false;
  String errorMessage = '';

  Future<void> register() async {
    if (_formKey.currentState!.validate()) {
      if (password != confirmPassword) {
        setState(() {
          errorMessage = 'Passwords do not match';
        });
        return;
      }

      setState(() => loading = true);
      try {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email.trim(),
          password: password,
        );

        // You might want to save the name in user profile here (optional)

        // After registering, navigate to edit profile screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => EditProfileScreen(user: userCredential.user!)),
        );
      } on FirebaseAuthException catch (e) {
        setState(() {
          errorMessage = e.message ?? 'Registration failed';
          loading = false;
        });
      } catch (e) {
        setState(() {
          errorMessage = 'An error occurred';
          loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onChanged: (val) => name = val,
                validator: (val) =>
                val == null || val.trim().isEmpty ? 'Please enter your name' : null,
              ),
              SizedBox(height: 15),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                keyboardType: TextInputType.emailAddress,
                onChanged: (val) => email = val,
                validator: (val) =>
                val == null || !val.contains('@') ? 'Enter a valid email' : null,
              ),
              SizedBox(height: 15),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                obscureText: true,
                onChanged: (val) => password = val,
                validator: (val) =>
                val == null || val.length < 6 ? 'Password must be at least 6 characters' : null,
              ),
              SizedBox(height: 15),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  prefixIcon: Icon(Icons.lock_outline),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                obscureText: true,
                onChanged: (val) => confirmPassword = val,
                validator: (val) =>
                val == null || val.length < 6 ? 'Confirm password must be at least 6 characters' : null,
              ),
              SizedBox(height: 25),
              loading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: register,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text('Register', style: TextStyle(fontSize: 18)),
              ),
              if (errorMessage.isNotEmpty) ...[
                SizedBox(height: 20),
                Text(errorMessage, style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600)),
              ],
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Already have an account? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
