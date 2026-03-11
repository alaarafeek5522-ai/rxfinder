import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/medicine_model.dart';
import '../providers/medicine_provider.dart';
import '../theme/app_theme.dart';

class MedicineDetailScreen extends StatefulWidget {
  final Medicine medicine;
  const MedicineDetailScreen({super.key, required this.medicine});
  @override
  State<MedicineDetailScreen> createState() => _MedicineDetailScreenState();
}

class _MedicineDetailScreenState extends State<MedicineDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MedicineProvider>().loadMedicineInfo(widget.medicine);
    });
  }

  void _share(Medicine med) {
    Share.share('💊 ${med.name}\n${med.description ?? ""}\n\nتم البحث عنه في تطبيق RxFinder');
  }

  Future<void> _openTelegram() async {
    final uri = Uri.parse('https://t.me/+4hMAHAP_vnE2ODlk');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MedicineProvider>();
    final medicine = provider.selectedMedicine ?? widget.medicine;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isFav = provider.isFavorite(medicine.id);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(gradient: AppColors.gradientLight),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),
                    Container(
                      width: 90, height: 90,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: widget.medicine.imageUrl != null &&
                              widget.medicine.imageUrl!.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(22),
                              child: Image.network(
                                widget.medicine.imageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Icon(
                                    Icons.medication_rounded,
                                    color: Colors.white, size: 44),
                              ),
                            )
                          : const Icon(Icons.medication_rounded,
                              color: Colors.white, size: 44),
                    ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        medicine.name,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 18,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    key: ValueKey(isFav),
                    color: isFav ? Colors.red : Colors.white,
                  ),
                ),
                onPressed: () =>
                    context.read<MedicineProvider>().toggleFavorite(medicine),
              ),
              IconButton(
                icon: const Icon(Icons.share_rounded, color: Colors.white),
                onPressed: () => _share(medicine),
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                // معلومات أساسية
                _infoCard(isDark, [
                  if (widget.medicine.price != null)
                    _infoRow(Icons.attach_money_rounded, 'السعر',
                        '${widget.medicine.price} ج.م'),
                  if (widget.medicine.category != null)
                    _infoRow(Icons.category_rounded, 'الفئة',
                        widget.medicine.category!),
                  if (widget.medicine.manufacturer != null)
                    _infoRow(Icons.business_rounded, 'الشركة',
                        widget.medicine.manufacturer!),
                  if (widget.medicine.activeIngredient != null)
                    _infoRow(Icons.science_rounded, 'المادة الفعالة',
                        widget.medicine.activeIngredient!),
                ]),

                const SizedBox(height: 12),

                // الوصف
                if (provider.isLoadingInfo)
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCard : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Column(children: [
                        CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(AppColors.primary)),
                        SizedBox(height: 12),
                        Text('جارٍ تحميل التفاصيل...',
                            style: TextStyle(color: AppColors.textSecondary)),
                      ]),
                    ),
                  )
                else if (medicine.description != null &&
                    medicine.description!.isNotEmpty)
                  _sectionCard(isDark, 'معلومات الدواء 💊',
                      medicine.description!, AppColors.primary),

                const SizedBox(height: 20),

                // أزرار
                Row(children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _share(medicine),
                      icon: const Icon(Icons.share_rounded),
                      label: const Text('مشاركة'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _openTelegram,
                      icon: const Icon(Icons.support_agent_rounded),
                      label: const Text('الدعم'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0088CC),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                ]),
                const SizedBox(height: 30),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard(bool isDark, List<Widget> children) {
    if (children.isEmpty) return const SizedBox.shrink();
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) => ListTile(
        leading: Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 18),
        ),
        title: Text(label,
            style: const TextStyle(
                fontSize: 12, color: AppColors.textSecondary)),
        subtitle: Text(value,
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600)),
        dense: true,
      );

  Widget _sectionCard(bool isDark, String title, String content, Color color) =>
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)
          ],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 15, color: color)),
          const SizedBox(height: 10),
          Text(content,
              style: const TextStyle(
                  fontSize: 14, height: 1.6, color: AppColors.textSecondary)),
        ]),
      ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0);
}
