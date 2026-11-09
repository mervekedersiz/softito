import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/models/enums.dart';
import '../../../../core/widgets/app_header.dart';
import '../../../../core/widgets/empty_state_view.dart';
import '../providers/inventory_providers.dart';
import '../widgets/food_card.dart';

class InventoryScreen extends ConsumerWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredFoodsAsync = ref.watch(filteredFoodsProvider);
    final filter = ref.watch(inventoryFilterProvider);
    final filterNotifier = ref.read(inventoryFilterProvider.notifier);
    final balance = ref.watch(kitchenBalanceProvider);

    return Scaffold(
      appBar: const AppHeader(subtitle: 'Envanter'),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 2,
        onPressed: () {
          context.push('/products/new');
        },
        icon: const Icon(Icons.add, size: 20),
        label: const Text(
          'Yeni Ürün Ekle',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: Column(
        children: [
          // Search & Sort bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceMuted,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      onChanged: filterNotifier.setQuery,
                      decoration: const InputDecoration(
                        hintText: 'Ürün veya kategori ara...',
                        hintStyle: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 13,
                        ),
                        prefixIcon: Icon(Icons.search,
                            size: 20, color: AppColors.textSecondary),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () {
                    // Cycle sort order
                    if (filter.sortOrder == 'expiry') {
                      filterNotifier.setSortOrder('name');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Ada göre alfabetik sıralandı.'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    } else if (filter.sortOrder == 'name') {
                      filterNotifier.setSortOrder('created');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Eklenme tarihine göre sıralandı.'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    } else {
                      filterNotifier.setSortOrder('expiry');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Son tüketim tarihine göre sıralandı.'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    }
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceMuted,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.swap_vert,
                        color: AppColors.primary, size: 22),
                  ),
                ),
              ],
            ),
          ),

          // Quick Filter chips
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // Urgent toggle
                  FilterChip(
                    label: Text('! Tarihi Yaklaşanlar (${balance.criticalCount})'),
                    selected: filter.onlyUrgent,
                    onSelected: (_) => filterNotifier.toggleOnlyUrgent(),
                    selectedColor: AppColors.warningBg,
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: filter.onlyUrgent
                          ? AppColors.warning
                          : AppColors.textPrimary,
                    ),
                    backgroundColor: AppColors.surfaceMuted,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: filter.onlyUrgent
                            ? AppColors.warning
                            : AppColors.border,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Dairy filter
                  FilterChip(
                    label: const Text('Süt & Şarküteri'),
                    selected: filter.category == FoodCategory.dairy,
                    onSelected: (_) => filterNotifier.setCategory(FoodCategory.dairy),
                    selectedColor: AppColors.primaryMint,
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: filter.category == FoodCategory.dairy
                          ? AppColors.primary
                          : AppColors.textPrimary,
                    ),
                    backgroundColor: AppColors.surfaceMuted,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: filter.category == FoodCategory.dairy
                            ? AppColors.primary
                            : AppColors.border,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Reset button
                  ActionChip(
                    avatar: const Icon(Icons.refresh, size: 14),
                    label: const Text('Sıfırla'),
                    onPressed: filterNotifier.reset,
                    backgroundColor: AppColors.surfaceMuted,
                    labelStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(color: AppColors.border),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Location Tabs
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildLocationTab(
                  label: 'Tümü',
                  count: balance.totalCount,
                  isSelected: filter.storageLocation == null,
                  onTap: () => filterNotifier.setStorageLocation(null),
                ),
                const SizedBox(width: 8),
                _buildLocationTab(
                  label: 'Buzdolabı',
                  count: balance.fridgeCount,
                  isSelected: filter.storageLocation == StorageLocation.fridge,
                  onTap: () =>
                      filterNotifier.setStorageLocation(StorageLocation.fridge),
                ),
                const SizedBox(width: 8),
                _buildLocationTab(
                  label: 'Dondurucu',
                  count: balance.freezerCount,
                  isSelected: filter.storageLocation == StorageLocation.freezer,
                  onTap: () =>
                      filterNotifier.setStorageLocation(StorageLocation.freezer),
                ),
                const SizedBox(width: 8),
                _buildLocationTab(
                  label: 'Kiler 🧺',
                  count: balance.pantryCount,
                  isSelected: filter.storageLocation == StorageLocation.pantry,
                  onTap: () =>
                      filterNotifier.setStorageLocation(StorageLocation.pantry),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.border),

          // Foods list
          Expanded(
            child: filteredFoodsAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
              error: (err, _) => Center(
                child: Text('Yükleme hatası: $err'),
              ),
              data: (foods) {
                if (foods.isEmpty) {
                  return EmptyStateView(
                    icon: Icons.kitchen_outlined,
                    title: 'Ürün Bulunamadı',
                    description: filter.query.isNotEmpty
                        ? '"${filter.query}" aramasına uygun ürün yok.'
                        : 'Bu filtre kriterinde kayıtlı ürün bulunmuyor.',
                    buttonText: 'Filtreleri Sıfırla',
                    onButtonPressed: filterNotifier.reset,
                  );
                }

                // If no specific location is selected, group them by section like in the screenshot
                if (filter.storageLocation == null && filter.query.isEmpty) {
                  final fridgeItems = foods
                      .where((f) => f.storageLocation == StorageLocation.fridge)
                      .toList();
                  final freezerItems = foods
                      .where((f) => f.storageLocation == StorageLocation.freezer)
                      .toList();
                  final pantryItems = foods
                      .where((f) => f.storageLocation == StorageLocation.pantry)
                      .toList();

                  return ListView(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, top: 12, bottom: 80),
                    children: [
                      if (fridgeItems.isNotEmpty) ...[
                        _buildSectionHeader(
                          title: 'Buzdolabı Bölmesi',
                          tag: '4°C',
                          subtitle: '2 Raf Aktif',
                          icon: Icons.kitchen,
                          color: const Color(0xFF007A4D),
                        ),
                        ...fridgeItems.map(
                          (item) => FoodCard(
                            food: item,
                            onConsume: () async {
                              await ref
                                  .read(foodsListProvider.notifier)
                                  .consumeFood(item.id);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${item.name} tüketildi.'),
                                    backgroundColor: AppColors.primary,
                                  ),
                                );
                              }
                            },
                            onWaste: () async {
                              await ref
                                  .read(foodsListProvider.notifier)
                                  .wasteFood(item.id, reason: 'Bozuldu');
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${item.name} israf olarak kaydedildi.'),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                      if (freezerItems.isNotEmpty) ...[
                        _buildSectionHeader(
                          title: 'Dondurucu Çekmecesi',
                          tag: '-18°C',
                          subtitle: '1 Çekmece',
                          icon: Icons.ac_unit,
                          color: const Color(0xFF0A84FF),
                        ),
                        ...freezerItems.map(
                          (item) => FoodCard(
                            food: item,
                            onConsume: () async {
                              await ref
                                  .read(foodsListProvider.notifier)
                                  .consumeFood(item.id);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${item.name} tüketildi.'),
                                    backgroundColor: AppColors.primary,
                                  ),
                                );
                              }
                            },
                            onWaste: () async {
                              await ref
                                  .read(foodsListProvider.notifier)
                                  .wasteFood(item.id, reason: 'Bozuldu');
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${item.name} israf olarak kaydedildi.'),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                      if (pantryItems.isNotEmpty) ...[
                        _buildSectionHeader(
                          title: 'Kiler & Kuru Gıda',
                          tag: 'Karanlık & Kuru',
                          subtitle: 'Bakliyat Rafı',
                          icon: Icons.shelves,
                          color: const Color(0xFFC86D24),
                        ),
                        ...pantryItems.map(
                          (item) => FoodCard(
                            food: item,
                            onConsume: () async {
                              await ref
                                  .read(foodsListProvider.notifier)
                                  .consumeFood(item.id);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${item.name} tüketildi.'),
                                    backgroundColor: AppColors.primary,
                                  ),
                                );
                              }
                            },
                            onWaste: () async {
                              await ref
                                  .read(foodsListProvider.notifier)
                                  .wasteFood(item.id, reason: 'Bozuldu');
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${item.name} israf olarak kaydedildi.'),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ],
                  );
                }

                // Regular flat filtered list
                return ListView.builder(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 12, bottom: 80),
                  itemCount: foods.length,
                  itemBuilder: (context, index) {
                    final item = foods[index];
                    return FoodCard(
                      food: item,
                      onConsume: () async {
                        await ref
                            .read(foodsListProvider.notifier)
                            .consumeFood(item.id);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${item.name} tüketildi.'),
                              backgroundColor: AppColors.primary,
                            ),
                          );
                        }
                      },
                      onWaste: () async {
                        await ref
                            .read(foodsListProvider.notifier)
                            .wasteFood(item.id, reason: 'Bozuldu');
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${item.name} israf olarak kaydedildi.'),
                            ),
                          );
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationTab({
    required String label,
    required int count,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : AppColors.surfaceMuted,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? AppColors.primary : AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '($count)',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? AppColors.primary : AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required String tag,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
            decoration: BoxDecoration(
              color: AppColors.surfaceMuted,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              tag,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const Spacer(),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
