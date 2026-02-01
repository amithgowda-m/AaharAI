// lib/features/profile/presentation/profile_screen.dart - CREATE THIS FILE

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/local/isar_service.dart';
import '../../../../data/local/entities/user_profile.dart';
import 'package:aahar_ai/auth/auth_service.dart';
import 'package:aahar_ai/features/auth/presentation/login_screen.dart';


class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  UserProfile? profile;
  bool isLoading = true;
  bool isSaving = false;

  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _currentWeightController = TextEditingController();
  final _targetWeightController = TextEditingController();
  final _heightController = TextEditingController();

  String selectedGender = 'male';
  String selectedGoal = 'maintain';
  String selectedActivityLevel = 'moderate';
  String selectedExerciseGoal = 'moderate';
  List<String> selectedHealthConditions = [];

  final List<String> healthConditionOptions = [
    'None',
    'Diabetic',
    'Hypertension',
    'Heart Disease',
    'Stress',
    'Anxiety',
    'Loneliness',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _currentWeightController.dispose();
    _targetWeightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    setState(() => isLoading = true);

    try {
      final currentUser = AuthService.getCurrentUser();
      if (currentUser != null) {
        final isarService = ref.read(isarProvider);
        profile = await isarService.getUserProfile(currentUser.id);

        if (profile != null) {
          _nameController.text = profile!.name;
          _ageController.text = profile!.age.toString();
          _currentWeightController.text = profile!.currentWeight.toString();
          _targetWeightController.text = profile!.targetWeight.toString();
          _heightController.text = profile!.height.toString();
          selectedGender = profile!.gender;
          selectedGoal = profile!.goal;
          selectedActivityLevel = profile!.activityLevel;
          selectedExerciseGoal = profile!.exerciseGoal;
          selectedHealthConditions = List.from(profile!.healthConditions);
        }
      }

      setState(() => isLoading = false);
    } catch (e) {
      print('Error loading profile: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> _saveProfile() async {
    setState(() => isSaving = true);

    try {
      final currentUser = AuthService.getCurrentUser();
      if (currentUser == null) return;

      final isarService = ref.read(isarProvider);

      if (profile == null) {
        profile = UserProfile()
          ..userId = currentUser.id
          ..email = currentUser.email ?? '';
      }

      profile!.name = _nameController.text.trim();
      profile!.age = int.tryParse(_ageController.text) ?? 25;
      profile!.currentWeight = double.tryParse(_currentWeightController.text) ?? 70.0;
      profile!.targetWeight = double.tryParse(_targetWeightController.text) ?? 70.0;
      profile!.height = double.tryParse(_heightController.text) ?? 170.0;
      profile!.gender = selectedGender;
      profile!.goal = selectedGoal;
      profile!.activityLevel = selectedActivityLevel;
      profile!.exerciseGoal = selectedExerciseGoal;
      profile!.healthConditions = selectedHealthConditions;

      await isarService.saveUserProfile(profile!);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ Profile updated successfully!'),
            backgroundColor: Color(0xFF2E7D32),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => isSaving = false);
    }
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('Logout'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await AuthService.signOut();
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false,
        );
      }
    }
  }

  Future<void> _deleteAccount() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Account', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you sure you want to permanently delete your account?'),
            SizedBox(height: 12),
            Text('⚠️ This action cannot be undone.', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber[900])),
            Text('All your data including diet plans, history, and preferences will be erased forever.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('DELETE PERMANENTLY'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      if (!mounted) return;
      // Double check
      final doubleConfirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Final Confirmation'),
          content: Text('Please confirm one last time. There is no going back.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text('I UNDERSTAND, DELETE'),
            ),
          ],
        ),
      );

      if (doubleConfirm == true) {
        if (!mounted) return;
        setState(() => isLoading = true);
        final error = await AuthService.deleteAccount();
        
        if (error != null) {
          if (mounted) {
            setState(() => isLoading = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: $error')),
            );
          }
        } else {
          if (mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
              (route) => false,
            );
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: Color(0xFFFAFAFA),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF2E7D32)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Color(0xFF2E7D32),
                    child: Text(
                      profile?.name.substring(0, 1).toUpperCase() ?? 'U',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    profile?.email ?? '',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 32),

            // Basic Info
            Text(
              'Basic Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),

            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Age',
                      prefixIcon: Icon(Icons.cake),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedGender,
                    decoration: InputDecoration(
                      labelText: 'Gender',
                      prefixIcon: Icon(Icons.wc),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: [
                      DropdownMenuItem(value: 'male', child: Text('Male')),
                      DropdownMenuItem(value: 'female', child: Text('Female')),
                    ],
                    onChanged: (value) {
                      setState(() => selectedGender = value!);
                    },
                  ),
                ),
              ],
            ),

            SizedBox(height: 24),

            // Physical Stats
            Text(
              'Physical Stats',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _currentWeightController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Current Weight (kg)',
                      prefixIcon: Icon(Icons.monitor_weight),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _targetWeightController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Target Weight (kg)',
                      prefixIcon: Icon(Icons.flag),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),

            TextField(
              controller: _heightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Height (cm)',
                prefixIcon: Icon(Icons.height),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            SizedBox(height: 24),

            // Goals
            Text(
              'Goals & Activity',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: selectedGoal,
              decoration: InputDecoration(
                labelText: 'Fitness Goal',
                prefixIcon: Icon(Icons.flag),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: [
                DropdownMenuItem(value: 'weight_loss', child: Text('Weight Loss')),
                DropdownMenuItem(value: 'weight_gain', child: Text('Weight Gain')),
                DropdownMenuItem(value: 'maintain', child: Text('Maintain Weight')),
                DropdownMenuItem(value: 'muscle_gain', child: Text('Muscle Gain')),
              ],
              onChanged: (value) {
                setState(() => selectedGoal = value!);
              },
            ),

            SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: selectedActivityLevel,
              decoration: InputDecoration(
                labelText: 'Activity Level',
                prefixIcon: Icon(Icons.directions_run),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: [
                DropdownMenuItem(value: 'sedentary', child: Text('Sedentary (Little/No Exercise)')),
                DropdownMenuItem(value: 'light', child: Text('Light (1-2 days/week)')),
                DropdownMenuItem(value: 'moderate', child: Text('Moderate (3-5 days/week)')),
                DropdownMenuItem(value: 'active', child: Text('Active (6-7 days/week)')),
                DropdownMenuItem(value: 'very_active', child: Text('Very Active (Intense)')),
              ],
              onChanged: (value) {
                setState(() => selectedActivityLevel = value!);
              },
            ),

            SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: selectedExerciseGoal,
              decoration: InputDecoration(
                labelText: 'Exercise Goal',
                prefixIcon: Icon(Icons.fitness_center),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: [
                DropdownMenuItem(value: 'none', child: Text('None')),
                DropdownMenuItem(value: 'light', child: Text('Light')),
                DropdownMenuItem(value: 'moderate', child: Text('Moderate')),
                DropdownMenuItem(value: 'intense', child: Text('Intense')),
              ],
              onChanged: (value) {
                setState(() => selectedExerciseGoal = value!);
              },
            ),

            SizedBox(height: 24),

            // Health Conditions
            Text(
              'Health Conditions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: healthConditionOptions.map((condition) {
                final isSelected = selectedHealthConditions.contains(condition.toLowerCase());
                return FilterChip(
                  label: Text(condition),
                  selected: isSelected,
                  selectedColor: Color(0xFF2E7D32).withOpacity(0.3),
                  checkmarkColor: Color(0xFF2E7D32),
                  onSelected: (selected) {
                    setState(() {
                      final conditionLower = condition.toLowerCase();
                      if (selected) {
                        if (conditionLower == 'none') {
                          selectedHealthConditions.clear();
                        }
                        selectedHealthConditions.add(conditionLower);
                      } else {
                        selectedHealthConditions.remove(conditionLower);
                      }
                    });
                  },
                );
              }).toList(),
            ),

            SizedBox(height: 32),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: isSaving ? null : _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isSaving
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Save Profile',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),

            SizedBox(height: 16),

            // Logout Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton.icon(
                onPressed: _logout,
                icon: Icon(Icons.logout, color: Colors.red),
                label: Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.red, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),

            // Delete Account Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: TextButton.icon(
                onPressed: _deleteAccount,
                icon: Icon(Icons.delete_forever, color: Colors.red),
                label: Text(
                  'Delete Account',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                  ),
                ),
                style: TextButton.styleFrom(
                   foregroundColor: Colors.red,
                ),
              ),
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
