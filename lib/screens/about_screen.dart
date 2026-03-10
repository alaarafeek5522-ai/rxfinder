import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<void> _openTelegram() async {
    final uri = Uri.parse('https://t.me/+4hMAHAP_vnE2ODlk');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.background,
      appBar: AppBar(
        title: const Text('حول التطبيق',
            style: TextStyle(fontWeight: FontWeight.bold)),
        flexibleSpace: Container(
            decoration: const BoxDecoration(gradient: AppColors.gradientLight)),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          // بطاقة التطبيق
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: const BoxDecoration(
              gradient: AppColors.gradientLight,
              borderRadius: BorderRadius.all(Radius.circular(24)),
            ),
            child: Column(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset('assets/images/icon.png',
                    width: 90, height: 90, fit: BoxFit.cover),
              ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),
              const SizedBox(height: 16),
              const Text('RxFinder',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              const Text('الإصدار 1.0.0',
                  style: TextStyle(color: Colors.white70, fontSize: 13)),
              const SizedBox(height: 4),
              const Text('ابحث عن أي دواء بسهولة وسرعة',
                  style: TextStyle(color: Colors.white60, fontSize: 13)),
            ]),
          ),

          const SizedBox(height: 20),

          // المطورون
          _card(isDark, Column(children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Row(children: [
                Icon(Icons.code_rounded, color: AppColors.primary),
                SizedBox(width: 10),
                Text('فريق التطوير',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ]),
            ),
            const Divider(height: 1),
            _devTile('Alaa', 'مطور Flutter & Android', Icons.android_rounded),
            _devTile('Ali', 'مطور Flutter & Backend', Icons.developer_mode_rounded),
          ])),

          const SizedBox(height: 16),

          // الدعم
          _card(isDark, Column(children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Row(children: [
                Icon(Icons.support_agent_rounded, color: AppColors.secondary),
                SizedBox(width: 10),
                Text('الدعم والتواصل',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ]),
            ),
            const Divider(height: 1),
            ListTile(
              leading: Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF0088CC).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.telegram, color: Color(0xFF0088CC)),
              ),
              title: const Text('Telegram Support',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: const Text('تواصل مع فريق الدعم مباشرة'),
              trailing: const Icon(Icons.arrow_forward_ios_rounded,
                  size: 14, color: AppColors.textSecondary),
              onTap: _openTelegram,
            ),
          ])),

          const SizedBox(height: 16),

          // الأمان
          _card(isDark, Column(children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Row(children: [
                Icon(Icons.security_rounded, color: AppColors.success),
                SizedBox(width: 10),
                Text('الأمان والخصوصية',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ]),
            ),
            const Divider(height: 1),
            const ListTile(
              leading: Icon(Icons.lock_rounded, color: AppColors.primary),
              title: Text('بيانات مشفرة',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              subtitle: Text('جميع بياناتك محمية ومشفرة'),
              dense: true,
            ),
            const ListTile(
              leading: Icon(Icons.verified_user_rounded, color: AppColors.success),
              title: Text('حماية Root',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              subtitle: Text('التطبيق محمي من الأجهزة المخترقة'),
              dense: true,
            ),
            const ListTile(
              leading: Icon(Icons.privacy_tip_rounded, color: AppColors.secondary),
              title: Text('لا مشاركة للبيانات',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              subtitle: Text('بياناتك لا تُشارك مع أي جهة'),
              dense: true,
            ),
          ])),

          const SizedBox(height: 20),

          Text('© 2025 RxFinder — Alaa & Ali',
              style: TextStyle(
                  color: AppColors.textSecondary.withOpacity(0.6),
                  fontSize: 12)),
          const SizedBox(height: 20),
        ]),
      ),
    );
  }

  Widget _card(bool isDark, Widget child) => Container(
    width: double.infinity,
    decoration: BoxDecoration(
      color: isDark ? AppColors.darkCard : Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
    ),
    child: child,
  );

  static Widget _devTile(String name, String role, IconData icon) => ListTile(
    leading: Container(
      width: 40, height: 40,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.secondary]),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    ),
    title: Text(name,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
    subtitle: Text(role,
        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
  );
}
