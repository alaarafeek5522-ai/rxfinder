import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/settings_provider.dart';
import '../services/security_service.dart';
import '../theme/app_theme.dart';
import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await context.read<SettingsProvider>().load();
    await Future.delayed(const Duration(milliseconds: 2800));

    final security = await SecurityService.getSecurityStatus();
    if (!mounted) return;

    if (security.isRooted) {
      _showRootedDialog();
      return;
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const MainScreen(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  void _showRootedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('تحذير أمني ⚠️'),
        content: const Text(
            'تم اكتشاف أن جهازك يحتوي على صلاحيات Root.\nلا يمكن تشغيل التطبيق على أجهزة Rooted لأسباب أمنية.'),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('حسناً', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.gradientLight),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset('assets/images/icon.png', fit: BoxFit.cover),
                ),
              )
                  .animate()
                  .scale(duration: 600.ms, curve: Curves.elasticOut)
                  .fadeIn(duration: 400.ms),
              const SizedBox(height: 28),
              const Text(
                'RxFinder',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5),
              )
                  .animate()
                  .fadeIn(delay: 400.ms, duration: 500.ms)
                  .slideY(begin: 0.3, end: 0),
              const SizedBox(height: 8),
              const Text(
                'ابحث عن دوائك بسهولة',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              )
                  .animate()
                  .fadeIn(delay: 600.ms, duration: 500.ms),
              const SizedBox(height: 6),
              const Text(
                'تطوير: Alaa & Ali',
                style: TextStyle(color: Colors.white54, fontSize: 12),
              )
                  .animate()
                  .fadeIn(delay: 800.ms, duration: 500.ms),
              const SizedBox(height: 60),
              CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation(Colors.white.withOpacity(0.7)),
                strokeWidth: 2,
              ).animate().fadeIn(delay: 1000.ms),
            ],
          ),
        ),
      ),
    );
  }
}
