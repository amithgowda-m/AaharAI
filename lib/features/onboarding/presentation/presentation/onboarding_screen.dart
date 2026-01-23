// lib/features/onboarding/presentation/onboarding_screen.dart
class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  final List<OnboardingPage> pages = [
    OnboardingPage(
      title: 'Track Your Food Instantly',
      description: 'Just snap a photo and our AI identifies everything on your plate',
      icon: Icons.camera_alt,
      color: Color(0xFF2E7D32),
    ),
    OnboardingPage(
      title: 'Get Personalized Insights',
      description: 'Nutira learns your habits and suggests healthier choices',
      icon: Icons.auto_awesome,
      color: Color(0xFFFF6F00),
    ),
    OnboardingPage(
      title: 'Achieve Your Goals',
      description: 'Build streaks, earn badges, and transform your nutrition journey',
      icon: Icons.emoji_events,
      color: Color(0xFF1976D2),
    ),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemCount: pages.length,
            itemBuilder: (context, index) {
              return OnboardingPageWidget(page: pages[index]);
            },
          ),
          
          // Page indicators
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(pages.length, (index) {
                return AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index ? Color(0xFF2E7D32) : Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
          ),
          
          // Skip/Next buttons
          Positioned(
            bottom: 32,
            left: 24,
            right: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  child: Text('Skip'),
                  onPressed: () => _completeOnboarding(),
                ),
                ElevatedButton(
                  child: Text(_currentPage == pages.length - 1 ? 'Get Started' : 'Next'),
                  onPressed: () {
                    if (_currentPage == pages.length - 1) {
                      _completeOnboarding();
                    } else {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  void _completeOnboarding() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => GoalSetupScreen()),
    );
  }
}
