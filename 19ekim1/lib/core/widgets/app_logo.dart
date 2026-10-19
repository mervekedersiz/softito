import 'package:flutter/material.dart';
import 'package:susadim/core/constants/app_colors.dart';

/// Uygulama Logosu Bileşeni
///
/// Neon cam efekti ve parlama detaylarıyla tasarlanmış
/// hem görsel hem de vektör destekli logo bileşeni.
class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size = 36.0,
    this.showText = false,
  });

  const AppLogo.small({
    super.key,
    this.showText = false,
  }) : size = 32.0;

  const AppLogo.medium({
    super.key,
    this.showText = true,
  }) : size = 48.0;

  const AppLogo.large({
    super.key,
    this.showText = true,
  }) : size = 84.0;

  final double size;
  final bool showText;

  @override
  Widget build(BuildContext context) {
    final logoBadge = _LogoBadge(size: size);

    if (!showText) {
      return logoBadge;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        logoBadge,
        const SizedBox(width: 10),
        _LogoTitle(fontSize: size * 0.45),
      ],
    );
  }
}

class _LogoBadge extends StatelessWidget {
  const _LogoBadge({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(size * 0.28),
        border: Border.all(
          color: AppColors.neonCyan.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.neonCyan.withValues(alpha: 0.2),
            blurRadius: size * 0.3,
            spreadRadius: 1,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        'assets/images/logo.png',
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _FallbackLogo(size: size),
      ),
    );
  }
}

class _LogoTitle extends StatelessWidget {
  const _LogoTitle({required this.fontSize});

  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
          color: AppColors.textPrimary,
        ),
        children: const [
          TextSpan(text: 'SUSA'),
          TextSpan(
            text: 'DIM',
            style: TextStyle(color: AppColors.neonCyan),
          ),
        ],
      ),
    );
  }
}

class _FallbackLogo extends StatelessWidget {
  const _FallbackLogo({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(
        Icons.water_drop_rounded,
        size: size * 0.58,
        color: AppColors.neonCyan,
      ),
    );
  }
}
