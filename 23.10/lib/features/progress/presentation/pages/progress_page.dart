import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_paths.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  int _selectedTabIndex = 0; // 0: Bu Hafta, 1: Bu Ay, 2: Tümü
  String _selectedCellInfo = '22 Ekim Çarşamba • 4/4 Hedef (%100)';
  String _selectedCellPraise = 'Harika';

  // 4 weeks of heat map data (7 days each: Pzt, Sal, Çar, Per, Cum, Cmt, Paz)
  // 0: empty/no plan, 1: low (lilac), 2: mid (purple), 3: full (dark green)
  final List<List<int>> _heatmapMatrix = [
    [0, 0, 3, 2, 3, 0, 0],
    [2, 3, 0, 3, 2, 0, 3],
    [3, 2, 0, 3, 0, 0, 2],
    [3, 2, 3, 0, 0, 0, 0],
  ];

  Color _getColorForLevel(int level) {
    switch (level) {
      case 3:
        return const Color(0xFF2E5339); // dark green
      case 2:
        return const Color(0xFF634F8E); // purple
      case 1:
        return const Color(0xFFC7B8E6); // light purple
      default:
        return const Color(0xFFF0EBF8); // empty / no plan
    }
  }

  void _showAllBadgesSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.military_tech_rounded, color: Color(0xFFD67D3E), size: 24),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Kazanılan Hatıra Rozetleri',
                    style: TextStyle(
                      fontSize: 16.5,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1E192B),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Alışkanlık ve bilet yolculuğunda açtığın tüm başarı hatıraları',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.55,
              ),
              child: ListView(
                shrinkWrap: true,
                children: [
                  _buildBadgeDetailTile(
                    emoji: '🌟',
                    title: 'İlk Adım',
                    subtitle: 'İlk sözünü tamamladın',
                    date: '10 Ekim 2026',
                    isEarned: true,
                  ),
                  const SizedBox(height: 10),
                  _buildBadgeDetailTile(
                    emoji: '⚡',
                    title: 'Ritim Buldum',
                    subtitle: '3 gün aralıksız sürdürdün',
                    date: '14 Ekim 2026',
                    isEarned: true,
                  ),
                  const SizedBox(height: 10),
                  _buildBadgeDetailTile(
                    emoji: '🎟️',
                    title: 'İlk Bilet',
                    subtitle: 'Kuponunu mühürledin',
                    date: '18 Ekim 2026',
                    isEarned: true,
                  ),
                  const SizedBox(height: 10),
                  _buildBadgeDetailTile(
                    emoji: '🌱',
                    title: 'Yeniden Başladım',
                    subtitle: 'Arayı kapatıp geri döndün',
                    date: 'Kilitli • 1 gün kaldı',
                    isEarned: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadgeDetailTile({
    required String emoji,
    required String title,
    required String subtitle,
    required String date,
    required bool isEarned,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isEarned ? const Color(0xFFFBF8FD) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isEarned ? const Color(0xFFECE5F9) : Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isEarned ? const Color(0xFFF3ECFA) : Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            child: Text(emoji, style: TextStyle(fontSize: 20, color: isEarned ? null : Colors.grey)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: isEarned ? const Color(0xFF1E192B) : Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(width: 6),
                    if (isEarned)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD6F3DF),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Kazanıldı',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF255734)),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 11.5, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
          Text(
            date,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isEarned ? const Color(0xFF634F8E) : Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7FD),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Color(0xFF201A18)),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(RoutePaths.study);
            }
          },
        ),
        title: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: const Color(0xFF634F8E),
                borderRadius: BorderRadius.circular(9),
              ),
              child: const Icon(Icons.confirmation_number_rounded, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'İlerlemem Ve Analiz',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E192B),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: const [
          CircleAvatar(
            radius: 16,
            backgroundImage: AssetImage('assets/images/avatar_profile.jpg'),
          ),
          SizedBox(width: 16),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // 1. Segmented Control / Tab Pills (Bu Hafta / Bu Ay / Tümü)
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFF3ECFA),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: ['Bu Hafta', 'Bu Ay', 'Tümü'].asMap().entries.map((entry) {
                final idx = entry.key;
                final label = entry.value;
                final isSelected = _selectedTabIndex == idx;

                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTabIndex = idx),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Text(
                        label,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                          color: isSelected ? const Color(0xFF28114E) : const Color(0xFF6E6779),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // 2. Card 1: Seri Durumu
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF634F8E).withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFDE8E1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.local_fire_department_rounded,
                        color: Color(0xFFD67D3E),
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Seri Durumu',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E192B),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD6F3DF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.check, size: 12, color: Color(0xFF255734)),
                          SizedBox(width: 4),
                          Text(
                            'Aktif Ritim',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF255734),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Dual Cards: Mevcut Seri & En Uzun Seri
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFCF7FD),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Mevcut Seri',
                              style: TextStyle(fontSize: 11, color: Color(0xFF7E768A)),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '5 Gün 🔥',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFFC75139),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFCF7FD),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'En Uzun Seri',
                              style: TextStyle(fontSize: 11, color: Color(0xFF7E768A)),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '14 Gün ⚡',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF4E3D73),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Note
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline_rounded, size: 14, color: Color(0xFF7E768A)),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Seri yalnızca planlanan günlere göre hesaplanır; boş günler seriyi kırmaz.',
                        style: TextStyle(fontSize: 11, color: Color(0xFF7E768A)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // 3. Card 2: Bu Hafta Oranları
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF634F8E).withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bu Hafta',
                  style: TextStyle(fontSize: 11, color: Color(0xFF7E768A)),
                ),
                const SizedBox(height: 4),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '18 / 22 Hedef',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1E192B),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '%82 ',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF4E3D73),
                          ),
                        ),
                        Text(
                          'Övgüye Değer',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF4E3D73),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Main progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: const LinearProgressIndicator(
                    value: 0.82,
                    minHeight: 8,
                    backgroundColor: Color(0xFFECE5F9),
                    valueColor: AlwaysStoppedAnimation(Color(0xFF4E3D73)),
                  ),
                ),
                const SizedBox(height: 14),

                // Sub-category progress cards
                Row(
                  children: [
                    // Maneviyat & İyilik
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F2FC),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.eco_outlined, size: 14, color: Color(0xFF2E5339)),
                                SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    'Maneviyat & İyilik',
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF201A18),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '%85',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF2E5339),
                                  ),
                                ),
                                Text('10/12', style: TextStyle(fontSize: 11, color: Color(0xFF7E768A))),
                              ],
                            ),
                            const SizedBox(height: 4),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(3),
                              child: const LinearProgressIndicator(
                                value: 0.85,
                                minHeight: 4,
                                backgroundColor: Color(0xFFD6F3DF),
                                valueColor: AlwaysStoppedAnimation(Color(0xFF2E5339)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Ders & Gelişim
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F2FC),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.menu_book_rounded, size: 14, color: Color(0xFF4E3D73)),
                                SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    'Ders & Gelişim',
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF201A18),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '%80',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF4E3D73),
                                  ),
                                ),
                                Text('8/10', style: TextStyle(fontSize: 11, color: Color(0xFF7E768A))),
                              ],
                            ),
                            const SizedBox(height: 4),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(3),
                              child: const LinearProgressIndicator(
                                value: 0.8,
                                minHeight: 4,
                                backgroundColor: Color(0xFFECE5F9),
                                valueColor: AlwaysStoppedAnimation(Color(0xFF4E3D73)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // 4. Card 3: Katkı & Tutarlılık (Son 4 Hafta) Heatmap Grid
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF634F8E).withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.grid_view_rounded, size: 16, color: Color(0xFF4E3D73)),
                    SizedBox(width: 6),
                    Text(
                      'Katkı & Tutarlılık',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E192B),
                      ),
                    ),
                    Spacer(),
                    Text(
                      'Son 4 Hafta',
                      style: TextStyle(fontSize: 11, color: Color(0xFF7E768A)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Selected Day Info Pill
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3ECFA),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Color(0xFF2E5339),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          _selectedCellInfo,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF28114E),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _selectedCellPraise,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF634F8E),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Days of week header (Pzt, Sal, Çar, Per, Cum, Cmt, Paz)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'].map((day) {
                    return SizedBox(
                      width: 36,
                      child: Text(
                        day,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 11, color: Color(0xFF7E768A), fontWeight: FontWeight.w500),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 6),

                // 4 Rows of Cells
                Column(
                  children: _heatmapMatrix.map((week) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: week.map((cellLevel) {
                          final color = _getColorForLevel(cellLevel);
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (cellLevel == 3) {
                                  _selectedCellInfo = '22 Ekim Çarşamba • 4/4 Hedef (%100)';
                                  _selectedCellPraise = 'Harika';
                                } else if (cellLevel == 2) {
                                  _selectedCellInfo = '21 Ekim Salı • 3/4 Hedef (%75)';
                                  _selectedCellPraise = 'Güzel İlerleme';
                                } else {
                                  _selectedCellInfo = 'Planlı gün veya dinlenme';
                                  _selectedCellPraise = 'Sakin Kal';
                                }
                              });
                            },
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),

                // Heatmap Legend
                Row(
                  children: [
                    const Text('Boş', style: TextStyle(fontSize: 10, color: Color(0xFF7E768A))),
                    const Spacer(),
                    Container(width: 12, height: 12, decoration: BoxDecoration(color: const Color(0xFFF0EBF8), borderRadius: BorderRadius.circular(3))),
                    const SizedBox(width: 4),
                    Container(width: 12, height: 12, decoration: BoxDecoration(color: const Color(0xFFC7B8E6), borderRadius: BorderRadius.circular(3))),
                    const SizedBox(width: 4),
                    Container(width: 12, height: 12, decoration: BoxDecoration(color: const Color(0xFF634F8E), borderRadius: BorderRadius.circular(3))),
                    const SizedBox(width: 4),
                    Container(width: 12, height: 12, decoration: BoxDecoration(color: const Color(0xFF2E5339), borderRadius: BorderRadius.circular(3))),
                    const SizedBox(width: 8),
                    const Text('%100', style: TextStyle(fontSize: 10, color: Color(0xFF7E768A))),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 5. Card 4: Kazanılan Hatıra Rozetleri (3 / 4 Açık)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF634F8E).withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.military_tech_rounded, size: 18, color: Color(0xFFD67D3E)),
                    const SizedBox(width: 6),
                    const Text(
                      'Kazanılan Hatıra Rozetleri',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E192B),
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () => _showAllBadgesSheet(context),
                      borderRadius: BorderRadius.circular(8),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Tümünü Gör (4)',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF634F8E),
                              ),
                            ),
                            Icon(Icons.chevron_right_rounded, size: 16, color: Color(0xFF634F8E)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // 2x2 Grid of Badges
                Row(
                  children: [
                    // Badge 1: İlk Adım
                    Expanded(
                      child: _buildBadgeCard(
                        iconEmoji: '🌟',
                        iconBg: const Color(0xFFFDE8E1),
                        tagText: 'KAZANILDI',
                        tagColor: const Color(0xFF255734),
                        tagBg: const Color(0xFFD6F3DF),
                        title: 'İlk Adım',
                        description: 'İlk tamamlanan gün kazanıldı.',
                        footerText: '12 Ekim',
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Badge 2: Ritim Buldum
                    Expanded(
                      child: _buildBadgeCard(
                        iconEmoji: '🔥',
                        iconBg: const Color(0xFFFDE8E1),
                        tagText: 'MÜHÜRLENDİ',
                        tagColor: const Color(0xFF255734),
                        tagBg: const Color(0xFFD6F3DF),
                        title: 'Ritim Buldum',
                        description: '7 planlı gün aralıksız tamamlandı.',
                        footerText: '19 Ekim',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    // Badge 3: İlk Bilet
                    Expanded(
                      child: _buildBadgeCard(
                        iconEmoji: '🎟️',
                        iconBg: const Color(0xFFECE5F9),
                        tagText: 'KULLANILDI',
                        tagColor: const Color(0xFF255734),
                        tagBg: const Color(0xFFD6F3DF),
                        title: 'İlk Bilet',
                        description: 'İlk ödül başarıyla kazanıldı ve harcandı.',
                        footerText: '21 Ekim',
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Badge 4: Yeniden Başladım
                    Expanded(
                      child: _buildBadgeCard(
                        iconEmoji: '🛡️',
                        iconBg: const Color(0xFFF5F0FB),
                        tagText: '🔒',
                        tagColor: const Color(0xFF7E768A),
                        tagBg: Colors.transparent,
                        title: 'Yeniden Başladım',
                        description: 'Ara verdikten sonra geri dönüş sözü.',
                        footerText: 'Kilitli',
                        isLocked: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // 6. Bottom Encouragement Card: Kendine Nazik Ol
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFCF7FD),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFECE5F9)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Color(0xFFD6F3DF),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.favorite_border_rounded,
                    color: Color(0xFF255734),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Kendine Nazik Ol',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1E192B),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Mükemmellik değil, samimi devamlılık esastır. Küçük adımların büyük izler bırakıyor.',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF6E6779),
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildBadgeCard({
    required String iconEmoji,
    required Color iconBg,
    required String tagText,
    required Color tagColor,
    required Color tagBg,
    required String title,
    required String description,
    required String footerText,
    bool isLocked = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isLocked ? const Color(0xFFF9F6FC) : const Color(0xFFFAF7FD),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFECE5F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
                child: Text(iconEmoji, style: const TextStyle(fontSize: 14)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: tagBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  tagText,
                  style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, color: tagColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: isLocked ? const Color(0xFF7E768A) : const Color(0xFF1E192B),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(fontSize: 10.5, color: Color(0xFF6E6779), height: 1.25),
          ),
          const SizedBox(height: 8),
          Text(
            footerText,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: isLocked ? Colors.grey : const Color(0xFF4E3D73),
            ),
          ),
        ],
      ),
    );
  }
}
