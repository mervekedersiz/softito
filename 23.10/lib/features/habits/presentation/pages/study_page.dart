import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/app_providers.dart';
import '../../../../app/router/route_paths.dart';
import '../../../../core/widgets/action_feedback.dart';
import '../../../../core/widgets/kendime_soz_app_bar.dart';
import '../../../../core/widgets/stamp_badge.dart';
import '../../domain/entities/habit.dart';
import '../controllers/habit_list_controller.dart';
import '../widgets/habit_form_sheet.dart';

class StudyPage extends ConsumerStatefulWidget {
  const StudyPage({super.key});

  @override
  ConsumerState<StudyPage> createState() => _StudyPageState();
}

class _StudyPageState extends ConsumerState<StudyPage> {
  // Focus timer display seconds (e.g. 21m 40s = 1300 seconds)
  int _timerSeconds = 21 * 60 + 40;
  final int _totalSeconds = 25 * 60;
  bool _isTimerRunning = false;
  Timer? _ticker;

  // Habit card states
  bool _codingCompleted = false;
  bool _bookReadCompleted = true;
  bool _githubCompleted = false;

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  void _toggleTimer() {
    if (_isTimerRunning) {
      _ticker?.cancel();
      setState(() => _isTimerRunning = false);
    } else {
      setState(() => _isTimerRunning = true);
      _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_timerSeconds > 0) {
          setState(() => _timerSeconds--);
        } else {
          _ticker?.cancel();
          setState(() => _isTimerRunning = false);
          ActionFeedback.showSuccess(
            context,
            'Odaklanma oturumu tamamlandı! "Müze Gezisi" biletine +1 adım eklendi! 🎟️',
          );
        }
      });
    }
  }

  void _finishAndSaveTimer() {
    _ticker?.cancel();
    setState(() {
      _isTimerRunning = false;
      _codingCompleted = true;
    });
    ActionFeedback.showSuccess(
      context,
      'Oturum başarıyla kaydedildi! Müze Gezisi biletine +1 adım işlendi. 🌟',
    );
  }

  String _formatTimer(int sec) {
    final m = sec ~/ 60;
    final s = sec % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  void _openAddSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => HabitFormSheet(
        defaultCategory: HabitCategory.study,
        onSave: (habit, plan) async {
          final repo = ref.read(habitRepositoryProvider);
          final res = await repo.createHabit(habit: habit, plan: plan);
          res.when(
            onSuccess: (_) {
              if (context.mounted) {
                ActionFeedback.showSuccess(
                  context,
                  'Ders ve gelişim hedefi eklendi! 📚',
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

  void _showAllHabitsSheet(BuildContext context) {
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
                const Icon(Icons.menu_book_rounded, color: Color(0xFF4E3D73), size: 22),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Bugünün Ders & Gelişim Sözleri',
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
              'Bugün için planladığın tüm gelişim ve çalışma hedefleri',
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
                  _buildHabitSummaryTile(
                    emoji: '💻',
                    title: '25 dk Kodlama / Proje',
                    progressText: '2 / 2 Tamamlandı • Mühürlendi',
                    isDone: true,
                  ),
                  const SizedBox(height: 10),
                  _buildHabitSummaryTile(
                    emoji: '📖',
                    title: '20 Sayfa Teknik Kitap Oku',
                    progressText: '20 / 20 Sayfa • Mühürlendi',
                    isDone: true,
                  ),
                  const SizedBox(height: 10),
                  _buildHabitSummaryTile(
                    emoji: '🇬🇧',
                    title: '15 dk İngilizce Teknik Makale',
                    progressText: 'Kalan: 15 dk • Devam Ediyor',
                    isDone: false,
                  ),
                  const SizedBox(height: 10),
                  _buildHabitSummaryTile(
                    emoji: '🧮',
                    title: '5 Algoritma Problemi Çöz',
                    progressText: '1 / 5 Çözüldü • Devam Ediyor',
                    isDone: false,
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
                  'Yeni Gelişim Sözü Ekle',
                  style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF634F8E)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHabitSummaryTile({
    required String emoji,
    required String title,
    required String progressText,
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
                  progressText,
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

  @override
  Widget build(BuildContext context) {
    final timerRatio = _timerSeconds / _totalSeconds;

    return Scaffold(
      backgroundColor: const Color(0xFFFAF7FD),
      appBar: const KendimeSozAppBar(subtitle: 'Ders Ve Gelişim'),
      body: RefreshIndicator(
        onRefresh: () async => ref.refresh(
          habitsWithCheckInsProvider(HabitCategory.study),
        ),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            // 1. Gelişim Seviyesi Header Card
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
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFECE5F9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.verified_outlined,
                          color: Color(0xFF634F8E),
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Gelişim Seviyesi',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1E192B),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDE8E1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Seri: 5 Gün',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFC75139),
                              ),
                            ),
                            SizedBox(width: 3),
                            Text('🔥', style: TextStyle(fontSize: 11)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Bugün 4 hedeften 2'si tamamlandı",
                          style: TextStyle(
                            fontSize: 12.5,
                            color: Color(0xFF6E6779),
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        '%50',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF255734),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: 0.5,
                      minHeight: 7,
                      backgroundColor: const Color(0xFFECE5F9),
                      valueColor: const AlwaysStoppedAnimation(Color(0xFF255734)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // 2. Focus Timer Section (Circular Pomodoro Gauge)
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF634F8E).withValues(alpha: 0.06),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Top Chips
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3ECFA),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.bedtime_outlined, size: 14, color: Color(0xFF634F8E)),
                            SizedBox(width: 4),
                            Text(
                              'Odaklanma Modu',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF634F8E),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3ECFA),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.tune_rounded, size: 14, color: Color(0xFF634F8E)),
                            SizedBox(width: 4),
                            Text(
                              '25 dk Oturum',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF634F8E),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Tag chip: Algoritma & Veri Yapıları
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3ECFA),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.code_rounded, size: 14, color: Color(0xFF634F8E)),
                        SizedBox(width: 6),
                        Text(
                          'Algoritma & Veri Yapıları',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF634F8E),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Circular Timer Progress Ring
                  SizedBox(
                    width: 170,
                    height: 170,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 160,
                          height: 160,
                          child: CircularProgressIndicator(
                            value: timerRatio,
                            strokeWidth: 10,
                            strokeCap: StrokeCap.round,
                            backgroundColor: const Color(0xFFECE5F9),
                            valueColor: const AlwaysStoppedAnimation(Color(0xFF4E3D73)),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _formatTimer(_timerSeconds),
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.5,
                                color: Color(0xFF1F1A24),
                              ),
                            ),
                            const Text(
                              '/ 25:00',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF7E768A),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Action Buttons Row (Durdur & Bitir/Kaydet)
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _toggleTimer,
                          style: OutlinedButton.styleFrom(
                            backgroundColor: const Color(0xFFF3ECFA),
                            side: BorderSide.none,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _isTimerRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                size: 18,
                                color: const Color(0xFF4E3D73),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                _isTimerRunning ? 'Durdur' : 'Sürdür',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF4E3D73),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          onPressed: _finishAndSaveTimer,
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF4E3D73),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.flag_outlined, size: 18, color: Colors.white),
                              SizedBox(width: 6),
                              Text(
                                'Bitir & Kaydet',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Reward step hint banner
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFCF7FD),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFECE5F9)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.confirmation_number_outlined, size: 16, color: Color(0xFFD67D3E)),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Oturum bittiğinde "Müze Gezisi" biletine +1 adım eklenecek!',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: Color(0xFF4C4459),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 3. Section Header: Bugünün Sözleri (4 Hedef)
            Row(
              children: [
                const Text(
                  'Bugünün Sözleri',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1F1A24),
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () => _showAllHabitsSheet(context),
                  borderRadius: BorderRadius.circular(8),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Tümünü Gör (4)',
                          style: TextStyle(
                            fontSize: 12,
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
            const SizedBox(height: 12),

            // Item 1: 25 dk Kodlama / Proje
            _buildHabitCard(
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
                        child: const Icon(Icons.code_rounded, color: Color(0xFF634F8E), size: 18),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '25 dk Kodlama / Proje',
                              style: TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1E192B),
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              '• Sayaca bağlı • Devam ediyor (%80)',
                              style: TextStyle(fontSize: 11.5, color: Color(0xFF6E6779)),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDE8E1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('🎟️', style: TextStyle(fontSize: 10)),
                            SizedBox(width: 4),
                            Text(
                              'Ödül Bileti',
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFC75139),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: const LinearProgressIndicator(
                            value: 0.8,
                            minHeight: 6,
                            backgroundColor: Color(0xFFECE5F9),
                            valueColor: AlwaysStoppedAnimation(Color(0xFF4E3D73)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      InkWell(
                        onTap: () {
                          setState(() => _codingCompleted = !_codingCompleted);
                          ActionFeedback.showSuccess(context, 'Hedef tamamlandı olarak işaretlendi! 💻');
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _codingCompleted ? const Color(0xFFD6F3DF) : const Color(0xFFF3ECFA),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_rounded,
                                size: 14,
                                color: _codingCompleted ? const Color(0xFF255734) : const Color(0xFF634F8E),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Tamamla',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                  color: _codingCompleted ? const Color(0xFF255734) : const Color(0xFF634F8E),
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

            // Item 2: 30 Soru Matematik / ...
            _buildHabitCard(
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Color(0xFF2E5339),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.edit_outlined, color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '30 Soru Matematik / ...',
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1E192B),
                          ),
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.check, size: 13, color: Color(0xFF2E5339)),
                            SizedBox(width: 4),
                            Text(
                              '30 / 30 Çözüldü',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2E5339),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const StampBadge(
                    text: 'MÜHÜRLENDİ',
                    type: StampType.green,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Item 3: 15 Sayfa Kitap Oku
            _buildHabitCard(
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Color(0xFFECE5F9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.menu_book_rounded, color: Color(0xFF634F8E), size: 18),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '15 Sayfa Kitap Oku',
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1E192B),
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Psikoloji & Odaklanma',
                          style: TextStyle(fontSize: 11.5, color: Color(0xFF6E6779)),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => _bookReadCompleted = !_bookReadCompleted),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: _bookReadCompleted ? const Color(0xFFECE5F9) : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.check_rounded,
                        size: 20,
                        color: _bookReadCompleted ? const Color(0xFF634F8E) : Colors.grey.shade400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Item 4: GitHub Öz Bildirim
            _buildHabitCard(
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Color(0xFFECE5F9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.terminal_rounded, color: Color(0xFF634F8E), size: 18),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'GitHub Öz Bildirim',
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1E192B),
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          '1 Commit / PR bekleniyor',
                          style: TextStyle(fontSize: 11.5, color: Color(0xFF6E6779)),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() => _githubCompleted = !_githubCompleted);
                      ActionFeedback.showSuccess(context, 'GitHub öz bildirimi kaydedildi! 🚀');
                    },
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: _githubCompleted ? const Color(0xFFD6F3DF) : const Color(0xFFF3ECFA),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _githubCompleted ? Icons.check : Icons.edit_outlined,
                            size: 14,
                            color: _githubCompleted ? const Color(0xFF255734) : const Color(0xFF634F8E),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _githubCompleted ? 'Kaydedildi' : 'Kaydet',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: _githubCompleted ? const Color(0xFF255734) : const Color(0xFF634F8E),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 4. Action Button: Yeni Hedef Ekle
            SizedBox(
              width: double.infinity,
              height: 48,
              child: TextButton(
                onPressed: () => _openAddSheet(context),
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFFECE5F9),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_circle_outline_rounded, color: Color(0xFF634F8E), size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Yeni Hedef Ekle',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF634F8E),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 5. Active Reward Mini-Card (Müze & Özel Kahve)
            GestureDetector(
              onTap: () => context.go(RoutePaths.rewards),
              child: Container(
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text('🎟️', style: TextStyle(fontSize: 14)),
                            SizedBox(width: 6),
                            Text(
                              'AKTİF ÖDÜL BİLETİ',
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.6,
                                color: Color(0xFFD67D3E),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Son 2 Adım!',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFFC75139),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Müze & Özel Kahve',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E192B),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // 8-step indicator bars
                    Row(
                      children: List.generate(8, (index) {
                        final isFilled = index < 6;
                        return Expanded(
                          child: Container(
                            height: 6,
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            decoration: BoxDecoration(
                              color: isFilled
                                  ? const Color(0xFF2E5339)
                                  : const Color(0xFFECE5F9),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '6/8 Adım Tamamlandı',
                          style: TextStyle(fontSize: 11, color: Color(0xFF6E6779)),
                        ),
                        Text(
                          'Hedefe %75 Yakın',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2E5339),
                          ),
                        ),
                      ],
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

  Widget _buildHabitCard({required Widget child}) {
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
