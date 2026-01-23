// lib/features/onboarding/presentation/onboarding_flow_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/local/isar_service.dart';
import '../../../data/local/entities/user_profile.dart';
import '../../../services/auth_service.dart';
import '../../dashboard/presentation/main_navigation_screen.dart';

class OnboardingFlowScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<OnboardingFlowScreen> createState() =>
      _OnboardingFlowScreenState();
}

class _OnboardingFlowScreenState extends ConsumerState<OnboardingFlowScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  // Controllers
  final _nameController = TextEditingController();
  final _ageController = TextEditingController(text: '25');
  final _currentWeightController = TextEditingController(text: '70');
  final _targetWeightController = TextEditingController(text: '70');
  final _heightController = TextEditingController(text: '170');

  String selectedGender = 'male';
  String selectedGoal = 'maintain';
  String selectedActivityLevel = 'moderate';
  String selectedExerciseGoal = 'moderate';
  List<String> selectedHealthConditions = [];

  bool isSaving = false;

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
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _currentWeightController.dispose();
    _targetWeightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  bool _validateCurrentPage() {
    if (_currentPage == 0) {
      return _nameController.text.trim().isNotEmpty;
    }
    if (_currentPage == 1) {
      return _currentWeightController.text.trim().isNotEmpty &&
          _targetWeightController.text.trim().isNotEmpty &&
          _heightController.text.trim().isNotEmpty &&
          _ageController.text.trim().isNotEmpty;
    }
    return true;
  }

  Future<void> _saveAndContinue() async {
    if (!_validateCurrentPage()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_currentPage < 2) {
      // Go to next page
      setState(() => _currentPage += 1);
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      return;
    }

    // Last page -> Save profile
    await _saveProfile();
  }

  Future<void> _saveProfile() async {
    setState(() => isSaving = true);

    try {
      final currentUser = AuthService.getCurrentUser();
      if (currentUser == null) {
        throw Exception('User not logged in');
      }

      final isarService = ref.read(isarProvider);

      final profile = UserProfile()
        ..userId = currentUser.id
        ..email = currentUser.email ?? ''
        ..name = _nameController.text.trim()
        ..age = int.tryParse(_ageController.text.trim()) ?? 25
        ..gender = selectedGender
        ..currentWeight =
            double.tryParse(_currentWeightController.text.trim()) ?? 70.0
        ..targetWeight =
            double.tryParse(_targetWeightController.text.trim()) ?? 70.0
        ..height = double.tryParse(_heightController.text.trim()) ?? 170.0
        ..goal = selectedGoal
        ..activityLevel = selectedActivityLevel
        ..exerciseGoal = selectedExerciseGoal
        ..healthConditions = selectedHealthConditions.isEmpty
            ? ['none']
            : selectedHealthConditions
        ..exerciseMinutesPerWeek = 0;

      await isarService.saveUserProfile(profile);

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => MainNavigationScreen()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving profile: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  Widget _buildHeader() {
    return Column(
      children: [
        SizedBox(height: 24),
        Text(
          'Aahar AI',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E7D32),
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Your AI Nutrition Companion',
          style: TextStyle(color: Colors.grey[600]),
        ),
        SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            3,
            (index) => Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              width: _currentPage == index ? 18 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? Color(0xFF2E7D32)
                    : Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPage1() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Let\'s get to know you',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'This helps Aahar AI personalize your diet plan',
            style: TextStyle(color: Colors.grey[600]),
          ),
          SizedBox(height: 32),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Your Name',
              hintText: 'Enter your name',
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
                  items: const [
                    DropdownMenuItem(value: 'male', child: Text('Male')),
                    DropdownMenuItem(value: 'female', child: Text('Female')),
                  ],
                  onChanged: (value) {
                    setState(() => selectedGender = value ?? 'male');
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPage2() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Body details',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Used to calculate your daily calorie and macro targets',
            style: TextStyle(color: Colors.grey[600]),
          ),
          SizedBox(height: 24),
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
        ],
      ),
    );
  }

  Widget _buildPage3() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Goals & health',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Aahar AI uses this to suggest meals for your goal',
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 24),
            DropdownButtonFormField<String>(
              value: selectedGoal,
              decoration: InputDecoration(
                labelText: 'Goal',
                prefixIcon: Icon(Icons.flag),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: const [
                DropdownMenuItem(
                    value: 'weight_loss', child: Text('Weight Loss')),
                DropdownMenuItem(
                    value: 'weight_gain', child: Text('Weight Gain')),
                DropdownMenuItem(
                    value: 'maintain', child: Text('Maintain Weight')),
                DropdownMenuItem(
                    value: 'muscle_gain', child: Text('Muscle Gain')),
              ],
              onChanged: (value) {
                setState(() => selectedGoal = value ?? 'maintain');
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
              items: const [
                DropdownMenuItem(
                    value: 'sedentary',
                    child: Text('Sedentary (Little/No Exercise)')),
                DropdownMenuItem(
                    value: 'light', child: Text('Light (1-2 days/week)')),
                DropdownMenuItem(
                    value: 'moderate',
                    child: Text('Moderate (3-5 days/week)')),
                DropdownMenuItem(
                    value: 'active', child: Text('Active (6-7 days/week)')),
                DropdownMenuItem(
                    value: 'very_active',
                    child: Text('Very Active (Intense)')),
              ],
              onChanged: (value) {
                setState(() => selectedActivityLevel = value ?? 'moderate');
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
              items: const [
                DropdownMenuItem(value: 'none', child: Text('None')),
                DropdownMenuItem(value: 'light', child: Text('Light')),
                DropdownMenuItem(
                    value: 'moderate', child: Text('Moderate')),
                DropdownMenuItem(value: 'intense', child: Text('Intense')),
              ],
              onChanged: (value) {
                setState(() => selectedExerciseGoal = value ?? 'moderate');
              },
            ),
            SizedBox(height: 24),
            Text(
              'Current health conditions',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: healthConditionOptions.map((condition) {
                final key = condition.toLowerCase();
                final isSelected = selectedHealthConditions.contains(key);
                return FilterChip(
                  label: Text(condition),
                  selected: isSelected,
                  selectedColor: Color(0xFF2E7D32).withOpacity(0.25),
                  checkmarkColor: Color(0xFF2E7D32),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        if (key == 'none') {
                          selectedHealthConditions.clear();
                        }
                        selectedHealthConditions.add(key);
                      } else {
                        selectedHealthConditions.remove(key);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildPage1(),
      _buildPage2(),
      _buildPage3(),
    ];

    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: NeverScrollableScrollPhysics(),
                children: pages,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: isSaving ? null : _saveAndContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2E7D32),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: isSaving
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          _currentPage < 2 ? 'Continue' : 'Finish',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
