import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';

class DonationGuidelinesDialog extends StatelessWidget {
  const DonationGuidelinesDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Row(
        children: [
          Icon(Icons.health_and_safety_outlined, color: AppColors.primary),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Gıda Güvenliği & Bağış Rehberi',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
      content: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Aşevleri ve mahalle dayanışma dolaplarına kabul edilen gıdalar için zorunlu standartlar:',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            SizedBox(height: 12),
            _RuleItem(
              icon: Icons.lock_outline,
              title: 'Kapalı Orijinal Ambalaj',
              desc: 'Paketi açılmış, delinmiş veya kapağı zorlanmış ürünler hijyen riski sebebiyle kabul edilmez.',
            ),
            _RuleItem(
              icon: Icons.ac_unit,
              title: 'Kesintisiz Soğuk Zincir',
              desc: 'Süt, peynir ve et ürünlerinde en az 2 gün STT payı bulunmalı ve soğuk zincir bozulmamış olmalıdır.',
            ),
            _RuleItem(
              icon: Icons.calendar_today_outlined,
              title: 'Tarih Güvencesi',
              desc: 'Son Tüketim Tarihi (STT) geçmiş hiçbir gıda listeye eklenemez.',
            ),
            _RuleItem(
              icon: Icons.shelves,
              title: 'İdeal Bağış: Kuru Gıda & Bakliyat',
              desc: 'Pirinç, bulgur, mercimek, makarna ve konserve gibi TETT ömrü uzun ürünler önceliklidir.',
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
          ),
          onPressed: () => Navigator.pop(context),
          child: const Text('Anladım'),
        ),
      ],
    );
  }
}

class _RuleItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;

  const _RuleItem({
    required this.icon,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  desc,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
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
