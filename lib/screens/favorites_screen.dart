import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../providers/medicine_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/medicine_card.dart';
import 'medicine_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MedicineProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.background,
      appBar: AppBar(
        title: const Text('المفضلة ❤️',
            style: TextStyle(fontWeight: FontWeight.bold)),
        flexibleSpace: Container(
            decoration: const BoxDecoration(gradient: AppColors.gradientLight)),
        foregroundColor: Colors.white,
      ),
      body: provider.favorites.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border_rounded,
                      size: 80,
                      color: AppColors.primary.withOpacity(0.2)),
                  const SizedBox(height: 16),
                  const Text('لا توجد أدوية في المفضلة',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textSecondary)),
                  const SizedBox(height: 8),
                  const Text('أضف أدويتك المفضلة من نتائج البحث',
                      style: TextStyle(color: AppColors.textSecondary)),
                ],
              ),
            )
          : ListView.builder(
              itemCount: provider.favorites.length,
              itemBuilder: (ctx, i) => Slidable(
                endActionPane: ActionPane(
                  motion: const DrawerMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (_) =>
                          provider.toggleFavorite(provider.favorites[i]),
                      backgroundColor: AppColors.error,
                      foregroundColor: Colors.white,
                      icon: Icons.delete_rounded,
                      label: 'حذف',
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                  ],
                ),
                child: MedicineCard(
                  medicine: provider.favorites[i],
                  index: i,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MedicineDetailScreen(
                          medicine: provider.favorites[i]),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
