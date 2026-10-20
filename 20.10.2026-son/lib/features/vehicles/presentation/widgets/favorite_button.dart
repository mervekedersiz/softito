import 'package:flutter/material.dart';

import '../../../../app/app_scope.dart';

/// Heart toggle for a vehicle. With [overlay] it sits on top of an image
/// on a translucent surface-colored disc.
class FavoriteButton extends StatelessWidget {
  const FavoriteButton({
    required this.vehicleId,
    required this.vehicleName,
    this.overlay = true,
    super.key,
  });

  final String vehicleId;
  final String vehicleName;
  final bool overlay;

  @override
  Widget build(BuildContext context) {
    final favorites = AppScope.of(context).favorites;
    final colors = Theme.of(context).colorScheme;

    return ListenableBuilder(
      listenable: favorites,
      builder: (context, _) {
        final isFavorite = favorites.isFavorite(vehicleId);
        return IconButton(
          tooltip: isFavorite
              ? '$vehicleName favorilerden çıkar'
              : '$vehicleName favorilere ekle',
          style: overlay
              ? IconButton.styleFrom(
                  backgroundColor: colors.surface.withValues(alpha: .92),
                )
              : null,
          onPressed: () => favorites.toggle(vehicleId),
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? colors.error : colors.onSurfaceVariant,
          ),
        );
      },
    );
  }
}
