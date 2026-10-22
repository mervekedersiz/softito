import 'dart:math';
import 'package:flutter/material.dart';
import '../../domain/entities/credit_card.dart';

/// 3D Flip interactive credit card widget with metallic gradient, chip, and brand logos.
class CreditCardWidget extends StatelessWidget {
  const CreditCardWidget({
    required this.card,
    required this.showBack,
    super.key,
  });

  final CreditCardModel card;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
      tween: Tween<double>(begin: 0.0, end: showBack ? 180.0 : 0.0),
      builder: (context, value, _) {
        final isUnder = value > 90.0;
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(value * pi / 180),
          child: isUnder
              ? Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()..rotateY(pi),
                  child: _CardBack(card: card),
                )
              : _CardFront(card: card),
        );
      },
    );
  }
}

class _CardFront extends StatelessWidget {
  const _CardFront({required this.card});

  final CreditCardModel card;

  @override
  Widget build(BuildContext context) {
    final brand = card.brand;

    return Container(
      width: double.infinity,
      height: 210,
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F2027).withValues(alpha: 0.4),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Subtle circular background glow
          Positioned(
            right: -30,
            top: -30,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      // Gold Chip
                      Container(
                        width: 44,
                        height: 32,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFFDF00), Color(0xFFD4AF37), Color(0xFFAA771C)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned(left: 12, top: 0, bottom: 0, width: 1, child: Container(color: Colors.black26)),
                            Positioned(right: 12, top: 0, bottom: 0, width: 1, child: Container(color: Colors.black26)),
                            Positioned(top: 15, left: 0, right: 0, height: 1, child: Container(color: Colors.black26)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.wifi, color: Colors.white70, size: 24),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      brand.displayName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
              // Card Number
              Text(
                card.formattedNumber,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 3,
                ),
              ),
              // Bottom Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'KART SAHİBİ',
                        style: TextStyle(color: Colors.white54, fontSize: 9, letterSpacing: 1.5, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        card.holderName.isEmpty ? 'AD SOYAD' : card.holderName.toUpperCase(),
                        style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700, letterSpacing: 0.5),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'SON KULLANMA',
                        style: TextStyle(color: Colors.white54, fontSize: 9, letterSpacing: 1.5, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        card.expiryDate.isEmpty ? 'AA/YY' : card.expiryDate,
                        style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CardBack extends StatelessWidget {
  const _CardBack({required this.card});

  final CreditCardModel card;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 210,
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [Color(0xFF2C5364), Color(0xFF203A43), Color(0xFF0F2027)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F2027).withValues(alpha: 0.4),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 22),
          // Magnetic Strip
          Container(
            width: double.infinity,
            height: 44,
            color: const Color(0xFF111111),
          ),
          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    height: 38,
                    color: Colors.white.withValues(alpha: 0.85),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 12),
                    child: const Text('Authorized Signature', style: TextStyle(color: Colors.black45, fontSize: 10, fontStyle: FontStyle.italic)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 38,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      card.cvv.isEmpty ? '•••' : card.cvv,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 0, 22, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '256-Bit Güvenli SSL Ödeme Sistemi',
                  style: TextStyle(color: Colors.white54, fontSize: 10),
                ),
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const RadialGradient(
                      colors: [Colors.cyanAccent, Colors.purpleAccent, Colors.transparent],
                    ),
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
