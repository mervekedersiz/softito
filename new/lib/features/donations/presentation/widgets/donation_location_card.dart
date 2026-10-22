import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../domain/entities/donation_location.dart';
import '../providers/donation_location_providers.dart';

class DonationLocationCard extends ConsumerWidget {
  const DonationLocationCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locations = ref.watch(donationLocationsProvider);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Row(
            children: [
              Icon(Icons.map_outlined, color: AppColors.primary),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Konum & Teslimat',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Haritadan pin ekle veya GPS ile konumunu al.',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          locations.when(
            loading: () => const LinearProgressIndicator(),
            error: (_, __) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Kayıtlı konumlar yüklenemedi.'),
                TextButton(
                  onPressed: () => ref.invalidate(donationLocationsProvider),
                  child: const Text('Tekrar dene'),
                ),
              ],
            ),
            data: (data) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _summary(
                  'Teslimat noktası',
                  data[DonationLocationKind.destination],
                ),
                const SizedBox(height: 12),
                _summary(
                  'Kurye alım adresi',
                  data[DonationLocationKind.pickup],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              FilledButton.icon(
                onPressed: () =>
                    context.push('/donations/locations/destination'),
                icon: const Icon(Icons.place_outlined),
                label: const Text('Konuma Git'),
              ),
              OutlinedButton.icon(
                onPressed: () => context.push('/donations/locations/pickup'),
                icon: const Icon(Icons.local_shipping_outlined),
                label: const Text('Kurye Teslimi'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Kurye alım adresi cihazına kaydedilir; kurye çağrısı oluşturulmaz.',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _summary(String title, DonationLocation? location) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
      ),
      const SizedBox(height: 3),
      Text(
        location?.label ?? 'Henüz konum seçilmedi',
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      if (location != null) ...[
        Text(location.point.coordinates, style: const TextStyle(fontSize: 12)),
        if (location.address.isNotEmpty)
          Text(
            location.address,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
      ],
    ],
  );
}
