import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/user_service.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;

  const EditProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final UserService userService = UserService();

  // Personal Info
  late TextEditingController nameController;
  late TextEditingController dobController;
  String gender = 'Male';  // default
  late TextEditingController addressController;

  // Education
  late TextEditingController degreeController;
  late TextEditingController institutionController;
  late TextEditingController yearPassingController;

  // Occupation
  late TextEditingController jobTitleController;
  late TextEditingController companyController;
  late TextEditingController experienceController;

  bool loading = true;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with empty strings initially
    nameController = TextEditingController();
    dobController = TextEditingController();
    addressController = TextEditingController();

    degreeController = TextEditingController();
    institutionController = TextEditingController();
    yearPassingController = TextEditingController();

    jobTitleController = TextEditingController();
    companyController = TextEditingController();
    experienceController = TextEditingController();

    // Load data from Firestore
    userService.getUserProfile(widget.user.uid).first.then((snapshot) {
      final data = snapshot.data() as Map<String, dynamic>? ?? {};

      nameController.text = data['Name'] ?? '';
      dobController.text = data['DateOfBirth'] ?? '';
      gender = data['Gender'] ?? 'Male';
      addressController.text = data['Address'] ?? '';

      degreeController.text = data['Degree'] ?? '';
      institutionController.text = data['Institution'] ?? '';
      yearPassingController.text = data['YearOfPassing'] ?? '';

      jobTitleController.text = data['JobTitle'] ?? '';
      companyController.text = data['Company'] ?? '';
      experienceController.text = data['Experience'] ?? '';

      setState(() {
        loading = false;
      });
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    dobController.dispose();
    addressController.dispose();

    degreeController.dispose();
    institutionController.dispose();
    yearPassingController.dispose();

    jobTitleController.dispose();
    companyController.dispose();
    experienceController.dispose();

    super.dispose();
  }

  void saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final updatedData = {
        'Name': nameController.text,
        'DateOfBirth': dobController.text,
        'Gender': gender,
        'Address': addressController.text,
        'Degree': degreeController.text,
        'Institution': institutionController.text,
        'YearOfPassing': yearPassingController.text,
        'JobTitle': jobTitleController.text,
        'Company': companyController.text,
        'Experience': experienceController.text,
      };

      await userService.createOrUpdateUserProfile(widget.user);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully!')),
      );
      Navigator.pop(context);
    }
  }

  // Optional: Show date picker for DOB
  Future<void> _selectDate() async {
    DateTime? initialDate;
    if (dobController.text.isNotEmpty) {
      initialDate = DateTime.tryParse(dobController.text);
    }
    initialDate ??= DateTime(2000);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      dobController.text = picked.toIso8601String().split('T')[0]; // yyyy-mm-dd
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: Text('Edit Profile')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Personal Info', style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: 10),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (val) =>
                val == null || val.isEmpty ? 'Enter your name' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: dobController,
                decoration: InputDecoration(
                  labelText: 'Date of Birth',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: _selectDate,
                  ),
                ),
                readOnly: true,
                validator: (val) =>
                val == null || val.isEmpty ? 'Select date of birth' : null,
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: gender,
                decoration: InputDecoration(labelText: 'Gender'),
                items: ['Male', 'Female', 'Other']
                    .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => gender = val);
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: addressController,
                decoration: InputDecoration(labelText: 'Address'),
                maxLines: 2,
              ),

              SizedBox(height: 20),
              Text('Education', style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: 10),
              TextFormField(
                controller: degreeController,
                decoration: InputDecoration(labelText: 'Degree'),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: institutionController,
                decoration: InputDecoration(labelText: 'Institution'),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: yearPassingController,
                decoration: InputDecoration(labelText: 'Year of Passing'),
                keyboardType: TextInputType.number,
              ),

              SizedBox(height: 20),
              Text('Occupation', style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: 10),
              TextFormField(
                controller: jobTitleController,
                decoration: InputDecoration(labelText: 'Job Title'),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: companyController,
                decoration: InputDecoration(labelText: 'Company'),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: experienceController,
                decoration: InputDecoration(labelText: 'Experience (years)'),
                keyboardType: TextInputType.number,
              ),

              SizedBox(height: 30),
              ElevatedButton(
                onPressed: saveProfile,
                child: Text('Save Profile'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
