import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../providers/medicine_provider.dart';
import '../providers/settings_provider.dart';
import '../theme/app_theme.dart';
import '../utils/connectivity_service.dart';
import '../widgets/medicine_card.dart';
import '../widgets/no_internet_widget.dart';
import 'medicine_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _ctrl = TextEditingController();
  final _focus = FocusNode();
  bool _hasInternet = true;

  @override
  void initState() {
    super.initState();
    _checkInternet();
    ConnectivityService.onConnectivityChanged.listen((result) {
      setState(() => _hasInternet =
          result.any((r) => r != ConnectivityResult.none));
    });
  }

  Future<void> _checkInternet() async {
    final connected = await ConnectivityService.isConnected();
    setState(() => _hasInternet = connected);
  }

  void _search(String query) {
    if (query.trim().isEmpty) return;
    _focus.unfocus();
    context.read<MedicineProvider>().search(query.trim());
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MedicineProvider>();
    final settings = context.watch<SettingsProvider>();
    final isDark = settings.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.background,
      body: !_hasInternet
          ? NoInternetWidget(onRetry: _checkInternet)
          : CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 16,
                      left: 20, right: 20, bottom: 24,
                    ),
                    decoration: const BoxDecoration(
                      gradient: AppColors.gradientLight,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('RxFinder 💊',
                                    style: TextStyle(color: Colors.white,
                                        fontSize: 22, fontWeight: FontWeight.bold)),
                                SizedBox(height: 4),
                                Text('ابحث عن أي دواء بسهولة',
                                    style: TextStyle(color: Colors.white70, fontSize: 13)),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () => context.read<SettingsProvider>().toggleDarkMode(),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                                color: Colors.white, size: 22,
                              ),
                            ),
                          ),
                        ]),
                        const SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20, offset: const Offset(0, 4))],
                          ),
                          child: Row(children: [
                            const SizedBox(width: 16),
                            const Icon(Icons.search_rounded,
                                color: AppColors.primary, size: 24),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: _ctrl,
                                focusNode: _focus,
                                style: const TextStyle(
                                    color: AppColors.textPrimary, fontSize: 15),
                                decoration: const InputDecoration(
                                  hintText: 'ابحث عن الدواء الذي تحتاجه...',
                                  hintStyle: TextStyle(
                                      color: AppColors.textSecondary, fontSize: 14),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(vertical: 16),
                                ),
                                onSubmitted: _search,
                                textInputAction: TextInputAction.search,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _search(_ctrl.text),
                              child: Container(
                                margin: const EdgeInsets.all(6),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [AppColors.primary, AppColors.secondary],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text('بحث',
                                    style: TextStyle(color: Colors.white,
                                        fontWeight: FontWeight.bold, fontSize: 13)),
                              ),
                            ),
                          ]),
                        ),
                      ],
                    ),
                  ),
                ),

                if (provider.state == SearchState.idle &&
                    provider.recentSearches.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                      child: Row(children: [
                        const Icon(Icons.history_rounded,
                            size: 18, color: AppColors.textSecondary),
                        const SizedBox(width: 6),
                        const Text('البحث الأخير',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        const Spacer(),
                        GestureDetector(
                          onTap: provider.clearRecentSearches,
                          child: const Text('مسح الكل',
                              style: TextStyle(fontSize: 12, color: AppColors.primary)),
                        ),
                      ]),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 44,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: provider.recentSearches.length,
                        itemBuilder: (_, i) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () {
                              _ctrl.text = provider.recentSearches[i];
                              _search(provider.recentSearches[i]);
                            },
                            child: Chip(
                              label: Text(provider.recentSearches[i],
                                  style: const TextStyle(fontSize: 12)),
                              backgroundColor: isDark ? AppColors.darkCard : Colors.white,
                              deleteIcon: const Icon(Icons.close, size: 14),
                              onDeleted: () =>
                                  provider.removeRecentSearch(provider.recentSearches[i]),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],

                if (provider.state == SearchState.loading)
                  const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(AppColors.primary))),
                  ),

                if (provider.state == SearchState.error)
                  SliverFillRemaining(
                    child: Center(
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        const Icon(Icons.error_outline_rounded,
                            size: 60, color: AppColors.error),
                        const SizedBox(height: 12),
                        Text(provider.errorMessage,
                            style: const TextStyle(color: AppColors.error),
                            textAlign: TextAlign.center),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => _search(_ctrl.text),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary),
                          child: const Text('إعادة المحاولة',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ]),
                    ),
                  ),

                if (provider.state == SearchState.success && provider.results.isEmpty)
                  SliverFillRemaining(
                    child: Center(
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Icon(Icons.medication_outlined, size: 70,
                            color: AppColors.primary.withOpacity(0.3)),
                        const SizedBox(height: 16),
                        const Text('لم يتم العثور على نتائج',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
                                color: AppColors.textSecondary)),
                        const SizedBox(height: 8),
                        const Text('جرب كلمة بحث مختلفة',
                            style: TextStyle(color: AppColors.textSecondary)),
                      ]),
                    ),
                  ),

                if (provider.state == SearchState.success && provider.results.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                      child: Text('${provider.results.length} نتيجة',
                          style: const TextStyle(fontWeight: FontWeight.bold,
                              fontSize: 14, color: AppColors.textSecondary)),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (ctx, i) => MedicineCard(
                        medicine: provider.results[i],
                        index: i,
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) =>
                                MedicineDetailScreen(medicine: provider.results[i]))),
                      ),
                      childCount: provider.results.length,
                    ),
                  ),
                ],

                if (provider.state == SearchState.idle && provider.recentSearches.isEmpty)
                  SliverFillRemaining(
                    child: Center(
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Icon(Icons.local_pharmacy_rounded, size: 80,
                            color: AppColors.primary.withOpacity(0.2)),
                        const SizedBox(height: 16),
                        const Text('ابحث عن أي دواء',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
                                color: AppColors.textSecondary)),
                        const SizedBox(height: 8),
                        const Text('اكتب اسم الدواء في خانة البحث',
                            style: TextStyle(color: AppColors.textSecondary)),
                      ]),
                    ),
                  ),

                const SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            ),
    );
  }
}
