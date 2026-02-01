import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'alarm_list_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AlarmListScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.charcoalBg,
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF14161B),
                  AppTheme.charcoalBg,
                  Color(0xFF0A0B0E),
                ],
              ),
            ),
          ),

          // Background Glow (Blur)
          Positioned(
            top: MediaQuery.of(context).size.height / 3 - 64,
            left: MediaQuery.of(context).size.width / 2 - 64,
            child: Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                color: const Color(0xFF7A9E7E).withOpacity(0.05),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF7A9E7E).withOpacity(0.05),
                    blurRadius: 80,
                    spreadRadius: 20,
                  ),
                ],
              ),
            ),
          ),

          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 128,
                      height: 128,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF1A1D23).withOpacity(0.5),
                        border: Border.all(
                          color: const Color(0xFF7A9E7E).withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                const Color(0xFF7A9E7E).withOpacity(0.1),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.spa,
                              size: 48,
                              color: Color(0xFF7A9E7E),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: -4,
                      right: -4,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: const Color(0xFF7A9E7E).withOpacity(0.3),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF7A9E7E).withOpacity(0.3),
                              blurRadius: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Title
                const Text(
                  'Gentle Wake Up',
                  style: TextStyle(
                    color: Color(0xFFB0B5BD),
                    fontSize: 32,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 0.5,
                  ),
                ),

                const SizedBox(height: 12),

                // Subtitle
                Text(
                  'RISE NATURALLY',
                  style: TextStyle(
                    color: const Color(0xFFB0B5BD).withOpacity(0.7),
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 2.0,
                  ),
                ),
              ],
            ),
          ),

          // Bottom Bar
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFB0B5BD).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
