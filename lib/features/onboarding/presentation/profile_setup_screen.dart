// lib/features/onboarding/presentation/profile_setup_screen.dart - CREATE THIS FILE

import 'package:flutter/material.dart';
import '../../../data/local/isar_service.dart';
import '../../../data/local/entities/user_profile.dart';
import '../../dashboard/presentation/main_navigation_screen.dart';

class ProfileSetupScreen extends StatefulWidget {
  @override
  _ProfileSetupScreenState createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final IsarService _isarService = IsarService();
  
  String selectedGender = 'male';
  int age = 25;
  double weight = 70.0;
  double height = 170.0;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final profile = UserProfile()
        ..userId = DateTime.now().millisecondsSinceEpoch.toString()
        ..email = "user@example.com"
        ..name = _nameController.text.trim()
        ..gender = selectedGender
        ..age = age
        ..currentWeight = weight
        ..targetWeight = weight
        ..height = height
        ..goal = 'maintain'
        ..activityLevel = 'moderate'
        ..exerciseGoal = 'moderate'
        ..dailyCalorieGoal = 2100.0
        ..dailyProteinGoal = 105.0
        ..dailyCarbsGoal = 260.0
        ..dailyFatGoal = 70.0
        ..dailyFiberGoal = 30.0;

      await _isarService.saveUserProfile(profile);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainNavigationScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setup Your Profile'),
        backgroundColor: Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(24),
          children: [
            Text(
              'Let\'s get to know you!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'This helps us personalize your nutrition goals',
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 32),
            
            // Name Field
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Your Name',
                hintText: 'Enter your name',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            
            SizedBox(height: 20),
            
            // Gender
            Text('Gender', style: TextStyle(fontWeight: FontWeight.w600)),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: Text('Male'),
                    value: 'male',
                    groupValue: selectedGender,
                    onChanged: (value) {
                      setState(() => selectedGender = value!);
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: Text('Female'),
                    value: 'female',
                    groupValue: selectedGender,
                    onChanged: (value) {
                      setState(() => selectedGender = value!);
                    },
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 32),
            
            // Save Button
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text('Continue', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
