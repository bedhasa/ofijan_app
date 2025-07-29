import 'package:flutter/material.dart';
import 'package:ofijan_app/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<double> _logoScale;

  int _currentLetterIndex = -1;
  final String _appName = "Ofijan";
  bool _showSlogan = false;

  @override
  void initState() {
    super.initState();

    // Logo animation
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeInOut),
    );

    _logoController.forward();

    // Start text animation sequence
    _startNameAnimation();

    // Navigate to Home after total 15 seconds
    Future.delayed(const Duration(seconds: 15), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    });
  }

  void _startNameAnimation() async {
    for (int i = 0; i < _appName.length; i++) {
      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted) {
        setState(() {
          _currentLetterIndex = i;
        });
      }
    }

    // Show slogan after name completes
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() {
        _showSlogan = true;
      });
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF2563EB), // blue-700
              Color(0xFF5B21B6), // purple-900
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _logoScale,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  child: const Icon(
                    Icons.school,
                    size: 80,
                    color: Colors.white,
                  ), // Replace with your logo widget if available
                ),
              ),

              // Animated Name: Ofijan
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_appName.length, (index) {
                  return AnimatedOpacity(
                    opacity: index <= _currentLetterIndex ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      _appName[index],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 20),

              // Slogan fade-in
              AnimatedOpacity(
                opacity: _showSlogan ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 600),
                child: const Text(
                  'Learn, Study & Test Your Limits with Ofijan',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              const SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white54),
                  strokeWidth: 4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
