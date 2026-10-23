import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/app_providers.dart';
import '../../../../core/widgets/action_feedback.dart';
import '../../../../core/widgets/kendime_soz_app_bar.dart';
import '../../../../core/widgets/stamp_badge.dart';
import '../../../../core/widgets/ticket_cutter_clipper.dart';
import '../../../habits/domain/entities/habit.dart';
import '../controllers/reward_controller.dart';
import '../widgets/reward_form_sheet.dart';

class RewardsPage extends ConsumerStatefulWidget {
  const RewardsPage({super.key});

  @override
  ConsumerState<RewardsPage> createState() => _RewardsPageState();
}

class _RewardsPageState extends ConsumerState<RewardsPage> {
  DateTime? _plannedDate;

  void _openCreateSheet(BuildContext context, List<Habit> availableHabits) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => RewardFormSheet(
        availableHabits: availableHabits,
        onSave: ({
          required title,
          required emoji,
          required description,
          required targetSteps,
          required habitIds,
        }) async {
          final notifier = ref.read(rewardControllerProvider.notifier);
          final ok = await notifier.createReward(
            title: title,
            emoji: emoji,
            description: description,
            targetSteps: targetSteps,
            habitIds: habitIds,
          );
          if (ok && context.mounted) {
            ActionFeedback.showSuccess(
              context,
              'Yeni ödül bileti oluşturuldu! 🎟️',
            );
          }
        },
      ),
    );
  }

  void _pickPlanDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 2)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (picked != null) {
      setState(() => _plannedDate = picked);
      if (context.mounted) {
        ActionFeedback.showSuccess(
          context,
          'Müze gezisi randevusu takvime işlendi! 🏛️✨',
        );
      }
    }
  }

  void _showAllUsedTickets(BuildContext context) {
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
                const Icon(Icons.style_outlined, color: Color(0xFF2E5339), size: 22),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Kullanılan Biletler Hatıra Defteri',
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
              'Emeklerinle kazandığın ve mühürleyerek kutladığın anlar',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.6,
              ),
              child: ListView(
                shrinkWrap: true,
                children: [
                  _buildUsedTicketItem(
                    title: '☕ Sakin Kitapçıda 2 Saat Kahve Molası',
                    dateLoc: '18 Ekim 2026 • Kadıköy',
                    reflection: '“Telefonsuz geçen, sadece roman ve lezzetli filtre kahveyle dolu dingin bir pazar öğleden sonrası.”',
                    stampDate: '18 EKİM 2026',
                    category: 'Kendime Zaman',
                  ),
                  const SizedBox(height: 12),
                  _buildUsedTicketItem(
                    title: '🎬 Gece Sineması & Patlamış Mısır',
                    dateLoc: '12 Ekim 2026 • Beşiktaş',
                    reflection: '“Hafta içi yoğunluğunun ardından tek başıma izlediğim harika bir festival filmi molası.”',
                    stampDate: '12 EKİM 2026',
                    category: 'Kültür & Sanat',
                  ),
                  const SizedBox(height: 12),
                  _buildUsedTicketItem(
                    title: '🚲 Boğaz Boyu Bisiklet Turu',
                    dateLoc: '5 Ekim 2026 • Emirgan',
                    reflection: '“Sabah serinliğinde deniz kenarında pedal çevirip zihnimi sıfırladığım unutulmaz bir deneyim.”',
                    stampDate: '5 EYLÜL 2026',
                    category: 'Spor & Doğa',
                  ),
                  const SizedBox(height: 12),
                  _buildUsedTicketItem(
                    title: '🍰 Nostaljik Tatlıcıda Ödül Saati',
                    dateLoc: '28 Eylül 2026 • Moda',
                    reflection: '“İlk tamamlanan biletin şerefine kendime verdiğim en tatlı sözdü.”',
                    stampDate: '28 EYLÜL 2026',
                    category: 'Küçük Zevkler',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAllDrafts(BuildContext context, List<Habit> availableHabits) {
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
                const Icon(Icons.bookmark_border_rounded, color: Color(0xFF634F8E), size: 22),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Sıradaki Bilet Hayalleri (Taslaklar)',
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
              'Aktif biletin bittikten sonra sıraya alabileceğin hediye anlar',
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
                  _buildDraftCard(
                    emojiIcon: Icons.pedal_bike_rounded,
                    iconBg: const Color(0xFFFDE8E1),
                    iconColor: const Color(0xFFD67D3E),
                    badgeLabel: 'Sırada',
                    badgeBg: const Color(0xFFFDE8E1),
                    badgeColor: const Color(0xFFD67D3E),
                    targetText: 'Hedef: 6 Adım',
                    title: 'Sahilde Gün Batımı Bisiklet Turu',
                    subtext: 'Deniz kokusu eşliğinde 1 saat müziksiz sürüş ve dinginlik.',
                  ),
                  const SizedBox(height: 10),
                  _buildDraftCard(
                    emojiIcon: Icons.movie_creation_outlined,
                    iconBg: const Color(0xFFECE5F9),
                    iconColor: const Color(0xFF634F8E),
                    badgeLabel: 'Taslak',
                    badgeBg: const Color(0xFFF3ECFA),
                    badgeColor: const Color(0xFF634F8E),
                    targetText: 'Hedef: 8 Adım',
                    title: 'Sinemada Yeni Vizyon Filmi',
                    subtext: 'Sezonun ödüllü festival yapımı için tek kişilik sinema seansı.',
                  ),
                  const SizedBox(height: 10),
                  _buildDraftCard(
                    emojiIcon: Icons.forest_outlined,
                    iconBg: const Color(0xFFD6F3DF),
                    iconColor: const Color(0xFF255734),
                    badgeLabel: 'Taslak',
                    badgeBg: const Color(0xFFD6F3DF),
                    badgeColor: const Color(0xFF255734),
                    targetText: 'Hedef: 10 Adım',
                    title: 'Orman Yürüyüşü & Termos Çayı',
                    subtext: 'Pazar sabahı doğada sessiz yürüyüş ve temiz hava hediyesi.',
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
                  _openCreateSheet(context, availableHabits);
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  side: const BorderSide(color: Color(0xFF634F8E)),
                ),
                icon: const Icon(Icons.add_rounded, color: Color(0xFF634F8E)),
                label: const Text(
                  'Yeni Taslak Bilet Ekle',
                  style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF634F8E)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final habitRepo = ref.watch(habitRepositoryProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFAF7FD),
      appBar: const KendimeSozAppBar(subtitle: 'Kendime Zaman'),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        children: [
          // 1. Header Section: ÖDÜL & MOLA CÜZDANI
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Color(0xFFFDE8E1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_outline_rounded,
                  size: 13,
                  color: Color(0xFFD67D3E),
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                'ÖDÜL & MOLA CÜZDANI',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.6,
                  color: Color(0xFF9E4B28),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Emeklerimi güzel bir\ndeneyimle kutluyorum.',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1E192B),
              height: 1.2,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Kazandığın her damga, kendine verdiğin değeri somutlaştıran bir hatıraya dönüşüyor.',
            style: TextStyle(
              fontSize: 12.5,
              color: Color(0xFF6E6779),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 14),

          // 2. Ambient Experience Photo Card
          Container(
            height: 130,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: const DecorationImage(
                image: AssetImage('assets/images/museum_cafe.jpg'),
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
              padding: const EdgeInsets.all(12),
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.museum_outlined, color: Colors.white, size: 14),
                    SizedBox(width: 6),
                    Text(
                      'Sıradaki Deneyim: Şehir ve Sanat Keşfi',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),

          // 3. Section Header: Kazanılmakta Olan • Aktif Bilet
          Row(
            children: [
              const Flexible(
                child: Text(
                  'Kazanılmakta Olan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E192B),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Color(0xFFD67D3E),
                  shape: BoxShape.circle,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFECE5F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Text('🎟️', style: TextStyle(fontSize: 10)),
                    SizedBox(width: 4),
                    Text(
                      'Aktif Bilet',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF634F8E),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 4. Special Ticket Card (Scalloped Edges & Stamp Grid)
          ClipPath(
            clipper: const TicketClipper(
              cutoutRadius: 10,
              cutoutPositionFraction: 0.74,
              borderRadius: 20,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF634F8E).withValues(alpha: 0.08),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Coupon Header
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.confirmation_number_outlined, size: 14, color: Color(0xFF2E5339)),
                                SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    'ÖZEL DENEYİM KUPONU',
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.6,
                                      color: Color(0xFF2E5339),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'No: #KZ-2026-08',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF7E768A),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Title & Subtitle
                        const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('🏛️', style: TextStyle(fontSize: 20)),
                            SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Hafta Sonu Müze Gezisi & Özel\nKahve',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF1E192B),
                                      height: 1.2,
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    '8 planlı adımın karşılığı kişisel mola hediyesi',
                                    style: TextStyle(fontSize: 12, color: Color(0xFF6E6779)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // Stamp Card Header
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Damga Kartı',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF634F8E),
                              ),
                            ),
                            Text(
                              '6 / 8 Adım (%75)',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF28114E),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // 2x4 Grid of Stamps
                        // Row 1: 18 Eki, 19 Eki, 20 Eki, 21 Eki
                        Row(
                          children: [
                            _buildStampSlot(label: '18 Eki', icon: Icons.star_rounded, isGreen: true),
                            _buildStampSlot(label: '19 Eki', icon: Icons.star_rounded, isGreen: true),
                            _buildStampSlot(label: '20 Eki', icon: Icons.confirmation_number_rounded, isPeach: true),
                            _buildStampSlot(label: '21 Eki', icon: Icons.star_rounded, isGreen: true),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Row 2: 22 Eki, Dün, Bugün, Final
                        Row(
                          children: [
                            _buildStampSlot(label: '22 Eki', icon: Icons.star_rounded, isGreen: true),
                            _buildStampSlot(label: 'Dün', icon: Icons.stars_rounded, isPeach: true),
                            _buildStampSlot(label: 'Bugün', icon: Icons.circle_outlined, isPurple: true),
                            _buildStampSlot(label: 'Final', icon: Icons.lock_outline_rounded, isLocked: true),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Progress bar: Son 2 adım kaldı!
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: const LinearProgressIndicator(
                                value: 0.75,
                                minHeight: 6,
                                backgroundColor: Color(0xFFECE5F9),
                                valueColor: AlwaysStoppedAnimation(Color(0xFFF2B6A0)),
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Son 2 adım kaldı!',
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFC75139),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Scissors Dashed Cut Line
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      const CustomPaint(
                        painter: DashedLinePainter(
                          color: Color(0xFFE4DFEC),
                          dashWidth: 4,
                          dashSpace: 4,
                        ),
                        size: Size(double.infinity, 2),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        color: Colors.white,
                        child: const Text('✂', style: TextStyle(fontSize: 12, color: Color(0xFF7E768A))),
                      ),
                    ],
                  ),

                  // Bottom Ticket Actions
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          'Tavsiye Edilen Zaman:',
                          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                        ),
                        Text(
                          _plannedDate != null
                              ? '${_plannedDate!.day}.${_plannedDate!.month}.${_plannedDate!.year} • 14:00 Sergisi'
                              : 'Cumartesi • 14:00 Sergisi',
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF28114E),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: FilledButton(
                                onPressed: () => _pickPlanDate(context),
                                style: FilledButton.styleFrom(
                                  backgroundColor: const Color(0xFF4E3D73),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  padding: const EdgeInsets.symmetric(vertical: 13),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Planla', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                    SizedBox(width: 6),
                                    Text('🗓️', style: TextStyle(fontSize: 13)),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            IconButton(
                              onPressed: () => _pickPlanDate(context),
                              style: IconButton.styleFrom(
                                backgroundColor: const Color(0xFFF3ECFA),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              ),
                              icon: const Icon(Icons.edit_outlined, color: Color(0xFF4E3D73), size: 20),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 5. How to earn stamp info card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F2FC),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline_rounded, color: Color(0xFF634F8E), size: 18),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nasıl Damga Kazanılır?',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF28114E),
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Ders & Gelişim veya seçili Maneviyat hedeflerini tamamladığında her gün en fazla 1 adım damgalanır. Amaç telaş değil, dingin bir sürdürülebilirliktir.',
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

          // 6. Section: Sıradaki Bilet Hayalleri (2 Taslak)
          Row(
            children: [
              const Text(
                'Sıradaki Bilet Hayalleri',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E192B),
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () async {
                  final res = await habitRepo.getHabits();
                  final habits = res.dataOrNull ?? [];
                  if (context.mounted) {
                    _showAllDrafts(context, habits);
                  }
                },
                borderRadius: BorderRadius.circular(8),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Tümünü Gör (2)',
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
          const SizedBox(height: 10),

          // Item 1: Sahilde Gün Batımı Bisiklet
          _buildDraftCard(
            emojiIcon: Icons.pedal_bike_rounded,
            iconBg: const Color(0xFFFDE8E1),
            iconColor: const Color(0xFFD67D3E),
            badgeLabel: 'Sırada',
            badgeBg: const Color(0xFFFDE8E1),
            badgeColor: const Color(0xFFD67D3E),
            targetText: 'Hedef: 6 Adım',
            title: 'Sahilde Gün Batımı Bisikl...',
            subtext: 'Deniz kokusu eşliğinde 1 saat müziksiz s...',
          ),
          const SizedBox(height: 10),

          // Item 2: Sinemada Yeni Vizyon Filmi
          _buildDraftCard(
            emojiIcon: Icons.movie_creation_outlined,
            iconBg: const Color(0xFFECE5F9),
            iconColor: const Color(0xFF634F8E),
            badgeLabel: 'Taslak',
            badgeBg: const Color(0xFFF3ECFA),
            badgeColor: const Color(0xFF634F8E),
            targetText: 'Hedef: 8 Adım',
            title: 'Sinemada Yeni Vizyon Fil...',
            subtext: 'Sezonun ödüllü festival yapımı için tek k...',
          ),
          const SizedBox(height: 20),

          // 7. Section: Kullanılan Biletler Hatıra Defteri
          Row(
            children: [
              const Icon(Icons.style_outlined, color: Color(0xFF2E5339), size: 18),
              const SizedBox(width: 8),
              const Text(
                'Kullanılan Biletler Hatıra Defteri',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E192B),
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () => _showAllUsedTickets(context),
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
                          color: Color(0xFF634F8E),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Icon(Icons.chevron_right_rounded, size: 16, color: Color(0xFF634F8E)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Memory Defter Card
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.calendar_today_rounded, size: 13, color: Color(0xFF7E768A)),
                        SizedBox(width: 4),
                        Text(
                          'Kullanım Tarihi: 18 Ekim 2026 • Kadıköy',
                          style: TextStyle(fontSize: 11, color: Color(0xFF7E768A)),
                        ),
                      ],
                    ),
                    const StampBadge(
                      text: 'MÜHÜRLENDİ\n18 EKİM 2026',
                      type: StampType.pink,
                      angle: -0.06,
                      showIcon: false,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  '☕ Sakin Kitapçıda 2 Saat\nKahve Molası',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1E192B),
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  '“Telefonsuz geçen, sadece roman ve lezzetli filtre kahveyle dolu dingin bir pazar öğleden sonrası.”',
                  style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: Color(0xFF5E576A),
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
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
                            'Tamamlandı',
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF255734),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2F6EA),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        children: [
                          Text('🌱', style: TextStyle(fontSize: 10)),
                          SizedBox(width: 4),
                          Text(
                            'Ruhuna Çok İyi Geldi',
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF255734),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // 8. Action Button: Yeni Ödül Bileti Tanımla
          SizedBox(
            width: double.infinity,
            height: 48,
            child: TextButton(
              onPressed: () async {
                final res = await habitRepo.getHabits();
                final habits = res.dataOrNull ?? [];
                if (context.mounted) {
                  _openCreateSheet(context, habits);
                }
              },
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
                    'Yeni Ödül Bileti Tanımla',
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
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildStampSlot({
    required String label,
    required IconData icon,
    bool isGreen = false,
    bool isPeach = false,
    bool isPurple = false,
    bool isLocked = false,
  }) {
    Color bg = const Color(0xFFF3ECFA);
    Color fg = const Color(0xFF7E768A);

    if (isGreen) {
      bg = const Color(0xFFD6F3DF);
      fg = const Color(0xFF255734);
    } else if (isPeach) {
      bg = const Color(0xFFFDE8E1);
      fg = const Color(0xFFD67D3E);
    } else if (isPurple) {
      bg = const Color(0xFFECE5F9);
      fg = const Color(0xFF634F8E);
    }

    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 3),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 18, color: fg),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: fg,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDraftCard({
    required IconData emojiIcon,
    required Color iconBg,
    required Color iconColor,
    required String badgeLabel,
    required Color badgeBg,
    required Color badgeColor,
    required String targetText,
    required String title,
    required String subtext,
  }) {
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(emojiIcon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: badgeBg,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        badgeLabel,
                        style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, color: badgeColor),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      targetText,
                      style: const TextStyle(fontSize: 11, color: Color(0xFF7E768A), fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E192B),
                  ),
                ),
                Text(
                  subtext,
                  style: const TextStyle(fontSize: 11.5, color: Color(0xFF6E6779)),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFF7E768A)),
        ],
      ),
    );
  }

  Widget _buildUsedTicketItem({
    required String title,
    required String dateLoc,
    required String reflection,
    required String stampDate,
    required String category,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF7FD),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEFE8F6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.calendar_today_rounded, size: 12, color: Color(0xFF7E768A)),
                  const SizedBox(width: 4),
                  Text(
                    dateLoc,
                    style: const TextStyle(fontSize: 11, color: Color(0xFF7E768A)),
                  ),
                ],
              ),
              StampBadge(
                text: 'MÜHÜRLENDİ\n$stampDate',
                type: StampType.pink,
                angle: -0.05,
                showIcon: false,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E192B),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            reflection,
            style: const TextStyle(
              fontSize: 12,
              fontStyle: FontStyle.italic,
              color: Color(0xFF5E576A),
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFD6F3DF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '✓ Tamamlandı • $category',
              style: const TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                color: Color(0xFF255734),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
