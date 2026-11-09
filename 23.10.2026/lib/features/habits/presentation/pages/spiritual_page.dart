import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/app_providers.dart';
import '../../../../core/widgets/action_feedback.dart';
import '../../../../core/widgets/kendime_soz_app_bar.dart';
import '../../../../core/widgets/stamp_badge.dart';
import '../../domain/entities/habit.dart';
import '../controllers/habit_list_controller.dart';
import '../widgets/habit_form_sheet.dart';

class SpiritualPage extends ConsumerStatefulWidget {
  const SpiritualPage({super.key});

  @override
  ConsumerState<SpiritualPage> createState() => _SpiritualPageState();
}

class _SpiritualPageState extends ConsumerState<SpiritualPage> {
  // Prayer check-in states (Sabah, Öğle, İkindi, Akşam, Yatsı)
  final Set<String> _checkedPrayers = {'Sabah', 'Öğle', 'İkindi'};
  // Sample card toggles
  bool _breadDonationCompleted = true;
  bool _birdFeedingCompleted = true;
  String _reflectionNote = 'Sabah serinliğinde yürürken derin bir nefes aldım ve sağlığım için şükrettim.';

  void _openAddSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => HabitFormSheet(
        defaultCategory: HabitCategory.spiritual,
        onSave: (habit, plan) async {
          final repo = ref.read(habitRepositoryProvider);
          final res = await repo.createHabit(habit: habit, plan: plan);
          res.when(
            onSuccess: (_) {
              if (context.mounted) {
                ActionFeedback.showSuccess(
                  context,
                  'Maneviyat ve iyilik hedefi eklendi! 🤲',
                );
              }
            },
            onFailure: (f) {
              if (context.mounted) {
                ActionFeedback.showError(context, f.message);
              }
            },
          );
        },
      ),
    );
  }

  void _showAllSpiritualHabitsSheet(BuildContext context) {
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
                const Icon(Icons.volunteer_activism_outlined, color: Color(0xFF634F8E), size: 22),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Bugünün Maneviyat & İyilik Sözleri',
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
              'Ruhuna iyi gelen ve huzur veren tüm manevi adımların',
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
                  _buildSpiritualSummaryTile(
                    emoji: '🥖',
                    title: 'Askıda Ekmek / Küçük Bir İyilik',
                    statusText: "11:30'da mühürlendi • Kalbe şifa",
                    isDone: _breadDonationCompleted,
                  ),
                  const SizedBox(height: 10),
                  _buildSpiritualSummaryTile(
                    emoji: '🕌',
                    title: '5 Vakit Namaz Farkındalığı',
                    statusText: '3 / 5 Vakit Tamamlandı',
                    isDone: false,
                  ),
                  const SizedBox(height: 10),
                  _buildSpiritualSummaryTile(
                    emoji: '📖',
                    title: '10 Dk Meal & Tefekkür',
                    statusText: 'Kalan: 10 Dk • Devam Ediyor',
                    isDone: false,
                  ),
                  const SizedBox(height: 10),
                  _buildSpiritualSummaryTile(
                    emoji: '🤲',
                    title: 'Günlük Şükür ve Duygu Notum',
                    statusText: 'Akşam notu mühürlendi',
                    isDone: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                  _openAddSheet(context);
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  side: const BorderSide(color: Color(0xFF634F8E)),
                ),
                icon: const Icon(Icons.add_rounded, color: Color(0xFF634F8E)),
                label: const Text(
                  'Yeni İyilik Sözü Ekle',
                  style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF634F8E)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpiritualSummaryTile({
    required String emoji,
    required String title,
    required String statusText,
    required bool isDone,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDone ? const Color(0xFFF7FDF9) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDone ? const Color(0xFFD6F3DF) : const Color(0xFFECE5F9),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDone ? const Color(0xFFD6F3DF) : const Color(0xFFF3ECFA),
              shape: BoxShape.circle,
            ),
            child: Text(emoji, style: const TextStyle(fontSize: 16)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E192B),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 11.5,
                    color: isDone ? const Color(0xFF255734) : const Color(0xFF7E768A),
                    fontWeight: isDone ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          if (isDone)
            const StampBadge(
              text: 'MÜHÜRLENDİ',
              type: StampType.green,
              angle: -0.06,
            )
          else
            const Icon(Icons.radio_button_unchecked_rounded, color: Color(0xFF7E768A), size: 20),
        ],
      ),
    );
  }

  void _openReflectionEditor(BuildContext context) {
    final controller = TextEditingController(text: _reflectionNote);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          left: 20,
          right: 20,
          top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.wb_sunny_outlined, color: Color(0xFFD67D3E), size: 22),
                SizedBox(width: 8),
                Text(
                  'Bugün kalbime iyi gelen ne oldu?',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Şükür ve duygu notunu buraya yaz...',
                filled: true,
                fillColor: const Color(0xFFFAF7FD),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                onPressed: () {
                  setState(() => _reflectionNote = controller.text.trim());
                  Navigator.pop(ctx);
                  ActionFeedback.showSuccess(context, 'İç huzur notu kaydedildi! ✨');
                },
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF634F8E),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Notu Güncelle', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7FD),
      appBar: const KendimeSozAppBar(subtitle: 'Maneviyat Ve İyilik'),
      body: RefreshIndicator(
        onRefresh: () async => ref.refresh(
          habitsWithCheckInsProvider(HabitCategory.spiritual),
        ),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            // 1. Günün İyilik Niyeti Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F2FC),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFE4DFEC),
                  width: 1,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Color(0xFF3B6447),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.eco_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            const Text(
                              'GÜNÜN İYİLİK NİYETİ',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.6,
                                color: Color(0xFF28114E),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              width: 4,
                              height: 4,
                              decoration: const BoxDecoration(
                                color: Color(0xFF7E768A),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              'Sakin Farkındalık',
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF6B6575),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          '“Bugün bir komşuya veya arkadaşa içten hatır sor.”',
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1F1A24),
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'İç dünyama iyi geliyorum, bir tebessüm paylaşıyorum.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6E6779),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 2. Section Header: Bugünün Maneviyat & İyilik Sözleri
            Row(
              children: [
                const Icon(
                  Icons.volunteer_activism_outlined,
                  size: 20,
                  color: Color(0xFF634F8E),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Bugünün Maneviyat & İyilik\nSözleri',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1F1A24),
                      height: 1.2,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () => _showAllSpiritualHabitsSheet(context),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD6F3DF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Tümünü Gör (4)',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF255734),
                          ),
                        ),
                        SizedBox(width: 2),
                        Icon(Icons.chevron_right_rounded, size: 14, color: Color(0xFF255734)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Card 1: Askıda Ekmek / Küçük Yardım
            _buildHabitContainer(
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: Color(0xFFD6F3DF),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.bakery_dining_rounded,
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
                              'Askıda Ekmek /\nKüçük Yardım',
                              style: TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1E192B),
                                height: 1.2,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Bugün fırında 2 askıda ekmek bırakıldı',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF6E6779),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_breadDonationCompleted)
                        GestureDetector(
                          onTap: () => setState(() => _breadDonationCompleted = !_breadDonationCompleted),
                          child: const StampBadge(
                            text: 'MÜHÜRLENDİ',
                            type: StampType.green,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(color: Color(0xFFF1EDF8), height: 1),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 14, color: Color(0xFF6E6779)),
                      const SizedBox(width: 4),
                      const Text(
                        "11:30'da mühürlendi",
                        style: TextStyle(fontSize: 11.5, color: Color(0xFF6E6779)),
                      ),
                      const Spacer(),
                      const Icon(Icons.favorite_border_rounded, size: 14, color: Color(0xFF634F8E)),
                      const SizedBox(width: 4),
                      const Text(
                        'Kalbe şifa',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF634F8E),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Card 2: Günlük Namaz & Vakit Takibi
            _buildHabitContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: Color(0xFFECE5F9),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.access_time_rounded,
                          color: Color(0xFF634F8E),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Günlük Namaz & Vakit Takibi',
                              style: TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1E192B),
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Huzur molası, kendine ve yaradana yöneliş',
                              style: TextStyle(fontSize: 12, color: Color(0xFF6E6779)),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFECE5F9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${_checkedPrayers.length} / 5 Vakit',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF634F8E),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // 5 Prayer Pills Row
                  Row(
                    children: ['Sabah', 'Öğle', 'İkindi', 'Akşam', 'Yatsı'].map((prayer) {
                      final isChecked = _checkedPrayers.contains(prayer);
                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isChecked) {
                                _checkedPrayers.remove(prayer);
                              } else {
                                _checkedPrayers.add(prayer);
                              }
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2.5),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: isChecked
                                  ? const Color(0xFFD6F3DF)
                                  : const Color(0xFFF3ECFA),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isChecked
                                    ? const Color(0xFFBFE7CA)
                                    : const Color(0xFFE4DFEC),
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  prayer,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: isChecked
                                        ? const Color(0xFF255734)
                                        : const Color(0xFF4C4459),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Icon(
                                  isChecked
                                      ? Icons.check_circle_outline_rounded
                                      : Icons.radio_button_unchecked_rounded,
                                  size: 16,
                                  color: isChecked
                                      ? const Color(0xFF255734)
                                      : const Color(0xFF7E768A),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  const Divider(color: Color(0xFFF1EDF8), height: 1),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.directions_walk_rounded, size: 14, color: Color(0xFF6E6779)),
                      const SizedBox(width: 4),
                      const Flexible(
                        child: Text(
                          'Kendi ritminde',
                          style: TextStyle(fontSize: 11.5, color: Color(0xFF6E6779)),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Spacer(),
                      const Flexible(
                        child: Text(
                          'Yarışma yok • Huzur var',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF6E6779),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Card 3: 10 Dk Meal & Tefekkür Okuması
            _buildHabitContainer(
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: Color(0xFFFDE8E1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.menu_book_rounded,
                          color: Color(0xFFD67D3E),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '10 Dk Meal & Tefekkür\nOkuması',
                              style: TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1E192B),
                                height: 1.2,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Zihni yavaşlatma, anlam arayışı',
                              style: TextStyle(fontSize: 12, color: Color(0xFF6E6779)),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5EFFB),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Bekliyor',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF7E768A),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(color: Color(0xFFF1EDF8), height: 1),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.timer_outlined, size: 14, color: Color(0xFF6E6779)),
                      const SizedBox(width: 4),
                      const Text(
                        '10 Dakika Odaklanma',
                        style: TextStyle(fontSize: 11.5, color: Color(0xFF6E6779)),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          ActionFeedback.showSuccess(
                            context,
                            '10 Dakikalık tefekkür oturumu başlatıldı! 🌿',
                          );
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4E3D73),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.play_arrow_rounded, color: Colors.white, size: 16),
                              SizedBox(width: 4),
                              Text(
                                'Huzurla Başla',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
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
            const SizedBox(height: 10),

            // Card 4: Bir Canlıyı Besle / Kuşlara Su Koy
            _buildHabitContainer(
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Color(0xFFD6F3DF),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.pets_rounded,
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
                          'Bir Canlıyı Besle / Kuşlara Su\nKoy',
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1E192B),
                            height: 1.2,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Doğadaki emanetlere şefkat göster',
                          style: TextStyle(fontSize: 12, color: Color(0xFF6E6779)),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() => _birdFeedingCompleted = !_birdFeedingCompleted);
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _birdFeedingCompleted
                            ? const Color(0xFFECE5F9)
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.check_rounded,
                        color: _birdFeedingCompleted
                            ? const Color(0xFF634F8E)
                            : Colors.grey.shade400,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 3. Günlük Şükür ve Duygu Notum
            Row(
              children: [
                const Icon(Icons.edit_note_rounded, color: Color(0xFF634F8E), size: 22),
                const SizedBox(width: 8),
                const Text(
                  'Günlük Şükür ve Duygu Notum',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E192B),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 20, color: Color(0xFF634F8E)),
                  onPressed: () => _openReflectionEditor(context),
                ),
              ],
            ),
            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFCF7FD),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFECE5F9)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.wb_sunny_outlined, size: 16, color: Color(0xFFD67D3E)),
                      SizedBox(width: 6),
                      Text(
                        'Bugün kalbime iyi gelen ne oldu?',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFD67D3E),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '“$_reflectionNote”',
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontStyle: FontStyle.italic,
                      color: Color(0xFF2C243B),
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '08:45 • İç Huzur Notu',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF7E768A),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 4. Ambient Quote Image Card
            Container(
              height: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                  image: AssetImage('assets/images/tea_book_window.jpg'),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.65),
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(16),
                alignment: Alignment.bottomLeft,
                child: const Row(
                  children: [
                    Icon(Icons.eco_rounded, color: Colors.white, size: 16),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '“Küçük bir iyilik, kainattaki tüm dengeyi güzelleştirir.”',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            // 5. Seninle Senin Aranda Security Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F2FC),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.lock_outline_rounded, color: Color(0xFF634F8E), size: 18),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Seninle Senin Aranda',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF28114E),
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Bu alandaki niyet ve hedefler tamamen senin mahremiyetindedir. Sıralama veya yarışma içermez; sadece kendi ruhsal serüvenine eşlik eder.',
                          style: TextStyle(
                            fontSize: 11.5,
                            color: Color(0xFF6B6575),
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 6. Action Button: Yeni İyilik veya Niyet Ekle
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                onPressed: () => _openAddSheet(context),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF634F8E),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 2,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_circle_outline_rounded, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Yeni İyilik veya Niyet Ekle',
                      style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildHabitContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF634F8E).withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}
