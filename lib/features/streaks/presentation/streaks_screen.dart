// lib/features/streaks/presentation/streaks_screen.dart
class StreaksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Streaks')),
      body: Column(
        children: [
          // Current streak circle
          Container(
            padding: EdgeInsets.all(32),
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 200,
                  height: 200,
                  child: CircularProgressIndicator(
                    value: 0.5,
                    strokeWidth: 16,
                    backgroundColor: Colors.red[100],
                    valueColor: AlwaysStoppedAnimation(Colors.red),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('1', style: TextStyle(fontSize: 72, fontWeight: FontWeight.bold)),
                    Text('1 down, 1 to go!'),
                    SizedBox(height: 8),
                    Text('Just 1 more day to reach your first milestone'),
                  ],
                ),
              ],
            ),
          ),
          
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 48, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            ),
            child: Text('SHARE'),
            onPressed: () {},
          ),
          
          SizedBox(height: 32),
          
          // Upcoming milestones
          StreakMilestone(day: 2, isLocked: true),
          StreakMilestone(day: 7, isLocked: true),
          StreakMilestone(day: 14, isLocked: true),
        ],
      ),
    );
  }
}
