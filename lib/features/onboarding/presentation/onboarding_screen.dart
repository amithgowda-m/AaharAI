import 'package:flutter/material.dart';
import '../../../data/local/entities/user_profile.dart';
import '../../../data/local/isar_service.dart';
import '../../dashboard/presentation/dashboard_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();

  String _gender = 'Male';
  String _goal = 'Maintain'; // Lose, Maintain, Gain
  bool _isLoading = false;

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // 1. Calculate BMR (Mifflin-St Jeor Equation)
    // Men: (10 × weight) + (6.25 × height) - (5 × age) + 5
    // Women: (10 × weight) + (6.25 × height) - (5 × age) - 161

    double weight = double.parse(_weightController.text);
    double height = double.parse(_heightController.text);
    int age = int.parse(_ageController.text);

    double bmr;
    if (_gender == 'Male') {
      bmr = (10 * weight) + (6.25 * height) - (5 * age) + 5;
    } else {
      bmr = (10 * weight) + (6.25 * height) - (5 * age) - 161;
    }

    // 2. Adjust for Goal (Sedentary Multiplier 1.2 assumed)
    double tdee = bmr * 1.2;
    int targetCalories = tdee.toInt();

    if (_goal == 'Lose') targetCalories -= 500;
    if (_goal == 'Gain') targetCalories += 500;

    // 3. Create Profile Object
    final profile = UserProfile()
      ..userId = "user_01" // Simple local ID for now
      ..email = "user@example.com"
      ..name = _nameController.text
      ..age = age
      ..currentWeight = weight
      ..targetWeight = weight
      ..height = height
      ..gender = _gender.toLowerCase()
      ..goal = _goal.toLowerCase()
      ..activityLevel = 'moderate'
      ..exerciseGoal = 'none'
      ..dailyCalorieGoal = targetCalories.toDouble()
      ..dailyProteinGoal = (weight * 1.5)
      ..dailyCarbsGoal = (targetCalories * 0.5) / 4
      ..dailyFatGoal = (targetCalories * 0.25) / 9
      ..dailyFiberGoal = 30.0;

    // 4. Save to Database
    final isarService = IsarService();
    await isarService.saveUserProfile(profile);

    if (!mounted) return;

    // 5. Navigate to Dashboard
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const DashboardScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Setup Profile"),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Let's personalize Aahar AI for you.",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 30),

              // Inputs
              _buildTextField("Name", _nameController),
              _buildTextField("Age", _ageController, isNumber: true),
              _buildTextField("Weight (kg)", _weightController, isNumber: true),
              _buildTextField("Height (cm)", _heightController, isNumber: true),

              const SizedBox(height: 20),
              const Text(
                "Gender",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  _buildRadio("Male", "Male"),
                  _buildRadio("Female", "Female"),
                ],
              ),

              const SizedBox(height: 20),
              const Text(
                "Goal",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              DropdownButtonFormField<String>(
                value: _goal,
                items: ['Lose', 'Maintain', 'Gain'].map((String val) {
                  return DropdownMenuItem(
                    value: val,
                    child: Text("$val Weight"),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _goal = val!),
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),

              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Complete Setup"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool isNumber = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (val) => val!.isEmpty ? "Required" : null,
      ),
    );
  }

  Widget _buildRadio(String label, String val) {
    return Row(
      children: [
        Radio(
          value: val,
          groupValue: _gender,
          onChanged: (v) => setState(() => _gender = v.toString()),
        ),
        Text(label),
        const SizedBox(width: 20),
      ],
    );
  }
}
