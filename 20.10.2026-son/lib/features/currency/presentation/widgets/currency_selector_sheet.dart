import 'package:flutter/material.dart';
import '../../domain/entities/currency.dart';
import '../controllers/currency_controller.dart';

/// Modal bottom sheet allowing users to query live exchange rates and switch currency.
class CurrencySelectorSheet extends StatelessWidget {
  const CurrencySelectorSheet({required this.controller, super.key});

  final CurrencyController controller;

  static Future<void> show(BuildContext context, CurrencyController controller) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => CurrencySelectorSheet(controller: controller),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colors.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Para Birimi & Canlı Kur',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        'Tüm araç ve kiralama fiyatlarını anlık çevirir',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  IconButton.filledTonal(
                    onPressed: controller.isLoading ? null : () => controller.refreshLiveRates(),
                    icon: controller.isLoading
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.refresh, size: 20),
                    tooltip: 'Canlı Kurları Yenile',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              for (final currency in Currency.values) ...[
                _CurrencyTile(
                  currency: currency,
                  rate: controller.rates[currency],
                  isSelected: controller.selected == currency,
                  onTap: () {
                    controller.selectCurrency(currency);
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(height: 8),
              ],
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerHighest.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.flash_on, color: Colors.amber, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Son kur sorgulama: ${controller.lastQueried != null ? "${controller.lastQueried!.hour.toString().padLeft(2, '0')}:${controller.lastQueried!.minute.toString().padLeft(2, '0')}:${controller.lastQueried!.second.toString().padLeft(2, '0')}" : "Canlı"} · Merkez Bankası simülasyonu',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CurrencyTile extends StatelessWidget {
  const _CurrencyTile({
    required this.currency,
    required this.rate,
    required this.isSelected,
    required this.onTap,
  });

  final Currency currency;
  final dynamic rate;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Material(
      color: isSelected
          ? colors.primaryContainer.withValues(alpha: 0.6)
          : colors.surfaceContainerLow,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: isSelected ? colors.primary : colors.surfaceContainerHighest,
                foregroundColor: isSelected ? colors.onPrimary : colors.onSurface,
                child: Text(
                  currency.symbol,
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          currency.code,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          currency.displayName,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    if (currency != Currency.tryCurrency && rate != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        '1 ${currency.code} = ₺${rate.rateAgainstTry}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (isSelected)
                Icon(Icons.check_circle, color: colors.primary, size: 22),
            ],
          ),
        ),
      ),
    );
  }
}
