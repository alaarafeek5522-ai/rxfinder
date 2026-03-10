import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../models/medicine_model.dart';
import '../providers/medicine_provider.dart';
import '../theme/app_theme.dart';

class MedicineCard extends StatelessWidget {
  final Medicine medicine;
  final VoidCallback onTap;
  final int index;

  const MedicineCard({
    super.key,
    required this.medicine,
    required this.onTap,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isFav = context.watch<MedicineProvider>().isFavorite(medicine.id);

    return Animate(
      effects: [
        FadeEffect(duration: 300.ms, delay: (index * 80).ms),
        SlideEffect(
          begin: const Offset(0, 0.3),
          end: Offset.zero,
          duration: 300.ms,
          delay: (index * 80).ms,
        ),
      ],
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(children: [
                  // أيقونة الدواء
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.secondary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: medicine.imageUrl != null && medicine.imageUrl!.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.network(
                              medicine.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(
                                  Icons.medication_rounded,
                                  color: Colors.white,
                                  size: 28),
                            ),
                          )
                        : const Icon(Icons.medication_rounded,
                            color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 14),
                  // معلومات الدواء
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          medicine.name,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (medicine.activeIngredient != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            medicine.activeIngredient!,
                            style: const TextStyle(
                                fontSize: 12, color: AppColors.textSecondary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        const SizedBox(height: 6),
                        Row(children: [
                          if (medicine.category != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                medicine.category!,
                                style: const TextStyle(
                                    fontSize: 10,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          const Spacer(),
                          if (medicine.price != null)
                            Text(
                              '${medicine.price} ج.م',
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.secondary,
                                  fontWeight: FontWeight.bold),
                            ),
                        ]),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // زر المفضلة
                  GestureDetector(
                    onTap: () => context
                        .read<MedicineProvider>()
                        .toggleFavorite(medicine),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Icon(
                        isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        key: ValueKey(isFav),
                        color: isFav ? Colors.red : AppColors.textSecondary,
                        size: 22,
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
