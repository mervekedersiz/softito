import 'package:flutter/material.dart';

/// Local asset image with a described placeholder when the asset is missing.
/// Never shows a broken-image icon.
class AppVehicleImage extends StatelessWidget {
  const AppVehicleImage({
    required this.semanticLabel,
    this.asset,
    this.aspectRatio = 16 / 10,
    super.key,
  });

  final String? asset;
  final String semanticLabel;
  final double aspectRatio;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: asset == null
          ? _Placeholder(label: semanticLabel)
          : Image.asset(
              asset!,
              fit: BoxFit.cover,
              semanticLabel: semanticLabel,
              errorBuilder: (_, _, _) => _Placeholder(label: semanticLabel),
            ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Semantics(
      label: '$label (görsel yok)',
      image: true,
      child: ColoredBox(
        color: colors.surfaceContainerHighest,
        child: Center(
          child: Icon(
            Icons.directions_car,
            size: 48,
            color: colors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
