// lib/features/dashboard/presentation/home_screen.dart - CREATE THIS FILE 📝

// lib/features/dashboard/presentation/home_screen.dart - ADD THIS LINE
import 'package:flutter/material.dart';
import 'widgets/calorie_ring.dart';
import 'widgets/macro_bars.dart';
import '../../scanner/presentation/camera_screen.dart'; // ADD THIS LINE


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double caloriesConsumed = 425.0;
  double caloriesTarget = 2100.0;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good Evening',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                      Text(
                        'Amith',
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Color(0xFF2E7D32),
                    child: Text('A', style: TextStyle(color: Colors.white, fontSize: 20)),
                  ),
                ],
              ),
              
              SizedBox(height: 32),
              
              // Calorie Ring
              Center(
                child: CalorieRing(
                  consumed: caloriesConsumed,
                  target: caloriesTarget,
                ),
              ),
              
              SizedBox(height: 32),
              
              // Quick Action Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to scanner
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CameraScreen()),
                    );
                  },
                  icon: Icon(Icons.camera_alt),
                  label: Text('Scan Food', style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2E7D32),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              
              SizedBox(height: 32),
              
              // Macros Section
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Today\'s Macros',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    MacroProgressBar(
                      name: 'Protein',
                      consumed: 18.0,
                      target: 105.0,
                      color: Colors.red,
                    ),
                    SizedBox(height: 12),
                    MacroProgressBar(
                      name: 'Carbs',
                      consumed: 68.0,
                      target: 260.0,
                      color: Colors.orange,
                    ),
                    SizedBox(height: 12),
                    MacroProgressBar(
                      name: 'Fat',
                      consumed: 9.0,
                      target: 70.0,
                      color: Colors.blue,
                    ),
                    SizedBox(height: 12),
                    MacroProgressBar(
                      name: 'Fiber',
                      consumed: 12.0,
                      target: 30.0,
                      color: Colors.purple,
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 24),
              
              // Recent Meals
              Text(
                'Recent Meals',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              _buildRecentMealCard(
                mealType: 'Evening Snack',
                foodName: 'Cadbury Fuse Chocolate Bar',
                calories: 132,
                time: '05:05 PM',
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildRecentMealCard({
    required String mealType,
    required String foodName,
    required int calories,
    required String time,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.orange[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.fastfood, color: Colors.orange),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mealType,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  foodName,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$calories Cal',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                time,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
