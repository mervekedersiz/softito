import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/bootstrap/app_bootstrap_controller.dart';
import '../../../../app/di/app_providers.dart';
import '../../../../app/router/route_paths.dart';
import '../../../../core/time/local_date.dart';
import '../../../../core/widgets/stamp_badge.dart';
import '../../../../core/widgets/ticket_cutter_clipper.dart';
import '../../habits/domain/entities/habit.dart';
import '../../habits/domain/entities/habit_plan.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  bool _isLoading = false;

  final List<Map<String, dynamic>> _starterTemplates = [
    {
      'title': '25 dk Kodlama / Proje',
      'emoji': '💻',
      'category': HabitCategory.study,
      'subcategory': 'Kodlama',
      'targetType': HabitTargetType.duration,
      'targetValue': 25,
      'unit': 'dk',
      'rewardEligible': true,
    },
    {
      'title': '30 Soru Matematik / ...',
      'emoji': '✍️',
      'category': HabitCategory.study,
      'subcategory': 'Soru',
      'targetType': HabitTargetType.count,
      'targetValue': 30,
      'unit': 'soru',
      'rewardEligible': true,
    },
    {
      'title': '15 Sayfa Kitap Oku',
      'emoji': '📖',
      'category': HabitCategory.study,
      'subcategory': 'Kitap',
      'targetType': HabitTargetType.count,
      'targetValue': 15,
      'unit': 'sayfa',
      'rewardEligible': true,
    },
    {
      'title': 'GitHub Öz Bildirim',
      'emoji': '💻',
      'category': HabitCategory.study,
      'subcategory': 'Gelişim',
      'targetType': HabitTargetType.check,
      'targetValue': 1,
      'unit': 'kez',
      'rewardEligible': false,
    },
    {
      'title': 'Askıda Ekmek / Küçük Yardım',
      'emoji': '🥐',
      'category': HabitCategory.spiritual,
      'subcategory': 'İyilik',
      'targetType': HabitTargetType.check,
      'targetValue': 1,
      'unit': 'kez',
      'rewardEligible': false,
    },
    {
      'title': 'Günlük Namaz & Vakit Takibi',
      'emoji': '⏰',
      'category': HabitCategory.spiritual,
      'subcategory': 'İbadet',
      'targetType': HabitTargetType.count,
      'targetValue': 5,
      'unit': 'vakit',
      'rewardEligible': false,
    },
    {
      'title': '10 Dk Meal & Tefekkür Okuması',
      'emoji': '📖',
      'category': HabitCategory.spiritual,
      'subcategory': 'Tefekkür',
      'targetType': HabitTargetType.duration,
      'targetValue': 10,
      'unit': 'dk',
      'rewardEligible': false,
    },
    {
      'title': 'Bir Canlıyı Besle / Kuşlara Su Koy',
      'emoji': '🕊️',
      'category': HabitCategory.spiritual,
      'subcategory': 'Şefkat',
      'targetType': HabitTargetType.check,
      'targetValue': 1,
      'unit': 'kez',
      'rewardEligible': false,
    },
  ];

  Future<void> _completeOnboarding() async {
    setState(() => _isLoading = true);
    final repo = ref.read(habitRepositoryProvider);
    final now = DateTime.now().toUtc();
    final today = LocalDate.fromDateTime(DateTime.now());

    // Populate starter templates for seamless first-run experience
    for (int idx = 0; idx < _starterTemplates.length; idx++) {
      final t = _starterTemplates[idx];
      final habitId = 'init_hab_${idx}_${now.millisecondsSinceEpoch}';
      final planId = 'init_plan_${idx}_${now.millisecondsSinceEpoch}';

      final habit = Habit(
        id: habitId,
        title: t['title'] as String,
        emoji: t['emoji'] as String,
        category: t['category'] as HabitCategory,
        subcategory: t['subcategory'] as String,
        createdAtUtc: now,
      );

      final plan = HabitPlan(
        id: planId,
        habitId: habitId,
        effectiveFromDate: today,
        weekdays: const [1, 2, 3, 4, 5, 6, 7],
        targetType: t['targetType'] as HabitTargetType,
        targetValue: t['targetValue'] as int,
        unit: t['unit'] as String,
        rewardEligible: t['rewardEligible'] as bool,
      );

      await repo.createHabit(habit: habit, plan: plan);
    }

    await ref.read(bootstrapControllerProvider.notifier).completeOnboarding();
    final prefs = ref.read(preferencesStoreProvider);

    if (mounted) {
      setState(() => _isLoading = false);
      final defaultSec = prefs.defaultSection;
      context.go(defaultSec == 'spiritual' ? RoutePaths.spiritual : RoutePaths.study);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFFAF7FD),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF201A18)),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            }
          },
        ),
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform.rotate(
              angle: -0.4,
              child: const Icon(
                Icons.confirmation_number_outlined,
                color: Color(0xFF634F8E),
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
            const Flexible(
              child: Text(
                'Adım Adım Keşfet',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF201A18),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: Color(0xFF634F8E), size: 30),
            onPressed: () => context.push(RoutePaths.login),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Interactive Hero Section with Floating Pills & Ticket
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFCF4FA), Color(0xFFF7F0FE)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    // Top floating pills row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Maneviyat pill
                        Flexible(
                          child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(5),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFD6F3DF),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.eco_rounded,
                                  size: 14,
                                  color: Color(0xFF255734),
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Maneviyat & Huzur',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF201A18),
                                    ),
                                  ),
                                  Text(
                                    'Şükür & tefekkür',
                                    style: TextStyle(
                                      fontSize: 9.5,
                                      color: Color(0xFF6B6575),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Ders & Gelişim pill
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(5),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFECE5F9),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.menu_book_rounded,
                                  size: 14,
                                  color: Color(0xFF634F8E),
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Ders & Gelişim',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF201A18),
                                    ),
                                  ),
                                  Text(
                                    'Mikro hedefler',
                                    style: TextStyle(
                                      fontSize: 9.5,
                                      color: Color(0xFF6B6575),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                    const SizedBox(height: 14),

                    // Center Ticket Card
                    ClipPath(
                      clipper: const TicketClipper(
                        cutoutRadius: 8,
                        cutoutPositionFraction: 0.64,
                        borderRadius: 16,
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF634F8E).withValues(alpha: 0.08),
                              blurRadius: 14,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFDE8E1),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Icon(
                                        Icons.confirmation_number_rounded,
                                        size: 13,
                                        color: Color(0xFFD67D3E),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    const Text(
                                      'SÖZ BİLETİ',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.6,
                                        color: Color(0xFF28114E),
                                      ),
                                    ),
                                  ],
                                ),
                                const Text(
                                  '#001',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF7E768A),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Yarım Saat Sessizlik & Kahve',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1E192B),
                              ),
                            ),
                            const SizedBox(height: 3),
                            const Text(
                              'Bugün kendine verdiğin sözü onurlandır.',
                              style: TextStyle(
                                fontSize: 11.5,
                                color: Color(0xFF6B6575),
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Dashed Divider
                            const CustomPaint(
                              painter: DashedLinePainter(
                                color: Color(0xFFE4DFEC),
                                dashWidth: 4,
                                dashSpace: 4,
                              ),
                              size: Size(double.infinity, 2),
                            ),
                            const SizedBox(height: 12),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.eco_outlined, size: 14, color: Color(0xFF2E5339)),
                                    SizedBox(width: 4),
                                    Text(
                                      'Öz Değer',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF2E5339),
                                      ),
                                    ),
                                  ],
                                ),
                                StampBadge(
                                  text: 'MÜHÜRLENDİ',
                                  type: StampType.green,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Bottom floating pill: Kendime Zaman
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                color: Color(0xFFFDE8E1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.wb_sunny_outlined,
                                size: 14,
                                color: Color(0xFFD67D3E),
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Kendime Zaman',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF201A18),
                                  ),
                                ),
                                Text(
                                  'Kişisel biletler',
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    color: Color(0xFF6B6575),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Carousel indicator dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 28,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xFF634F8E),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    width: 6,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDDD5E8),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    width: 6,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDDD5E8),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Title with styled text
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1E192B),
                    height: 1.25,
                    letterSpacing: -0.4,
                  ),
                  children: [
                    TextSpan(text: 'Kendine verdiğin sözleri\n'),
                    TextSpan(
                      text: 'somut hatıralara',
                      style: TextStyle(
                        color: Color(0xFF634F8E),
                        decoration: TextDecoration.underline,
                        decorationColor: Color(0xFFF2B6A0),
                        decorationThickness: 2.5,
                      ),
                    ),
                    TextSpan(text: ' dönüştür.'),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // Subtitle
              const Text(
                'İç dünyana iyi gel, geleceğine yatırım yap, emeklerini kişisel deneyim biletleriyle kutla.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF5E576A),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 18),

              // 3 Feature Cards
              _buildFeatureCard(
                icon: Icons.block_rounded,
                iconBg: const Color(0xFFF0EBF8),
                iconColor: const Color(0xFF634F8E),
                title: 'Reklamsız ve tamamen çevrimdışı',
                subtitle: 'Zihnini dağıtacak hiçbir gürültü yok',
              ),
              const SizedBox(height: 8),
              _buildFeatureCard(
                icon: Icons.favorite_border_rounded,
                iconBg: const Color(0xFFD6F3DF),
                iconColor: const Color(0xFF255734),
                title: 'Puan veya yarış yok, senin ritmin',
                subtitle: 'Kıyaslamadan uzak, şefkatli adımlar',
              ),
              const SizedBox(height: 8),
              _buildFeatureCard(
                icon: Icons.confirmation_number_outlined,
                iconBg: const Color(0xFFFDE8E1),
                iconColor: const Color(0xFFD67D3E),
                title: 'Kişisel deneyim ödülleri',
                subtitle: 'Kendi belirlediğin özel anlarla kutlama',
              ),
              const SizedBox(height: 22),

              // Action Buttons
              // Primary button: Adım Adım Başla ->
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: _isLoading ? null : _completeOnboarding,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF634F8E),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Adım Adım Başla',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward_rounded, size: 18),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 10),

              // Secondary button: Zaten hesabım var / Giriş Yap
              SizedBox(
                width: double.infinity,
                height: 48,
                child: TextButton(
                  onPressed: () => context.push(RoutePaths.login),
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFFF3ECFA),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text(
                    'Zaten hesabım var / Giriş Yap',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF634F8E),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),

              // Skip button: Şimdilik Atla
              TextButton(
                onPressed: _completeOnboarding,
                child: Text(
                  'Şimdilik Atla',
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F3FC),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF221C2B),
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: Color(0xFF6E6779),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
