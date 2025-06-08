import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLogin = true;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String error = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthService>();

    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person_pin, size: 100, color: Colors.blueAccent),
              const SizedBox(height: 20),
              Text(
                isLogin ? 'Welcome Back' : 'Create Account',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              if (!isLogin)
                _buildTextField(nameController, 'Name', Icons.person),
              const SizedBox(height: 15),
              _buildTextField(emailController, 'Email', Icons.email),
              const SizedBox(height: 15),
              _buildTextField(passwordController, 'Password', Icons.lock, isPassword: true),
              const SizedBox(height: 25),
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                width: isLoading ? 60 : double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : () async {
                    setState(() {
                      isLoading = true;
                      error = '';
                    });

                    try {
                      if (isLogin) {
                        await auth.signIn(
                          emailController.text.trim(),
                          passwordController.text.trim(),
                        );
                      } else {
                        await auth.signUp(
                          nameController.text.trim(),
                          emailController.text.trim(),
                          passwordController.text.trim(),
                        );
                      }
                    } catch (e) {
                      setState(() => error = e.toString());
                    }

                    setState(() {
                      isLoading = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: isLoading
                      ? CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                      : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(isLogin ? Icons.login : Icons.person_add),
                      SizedBox(width: 8),
                      Text(isLogin ? 'Login' : 'Register', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextButton(
                onPressed: () {
                  setState(() {
                    isLogin = !isLogin;
                    error = '';
                  });
                },
                child: Text(
                  isLogin ? "Don't have an account? Register" : "Already have an account? Login",
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),
              if (error.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(error, style: TextStyle(color: Colors.red, fontSize: 14)),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon,
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
