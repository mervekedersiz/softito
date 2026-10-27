import 'package:flutter/material.dart';

class StokRozeti extends StatelessWidget {
  final int stokAdedi;
  const StokRozeti({super.key, required this.stokAdedi});

  @override
  Widget build(BuildContext context) {
    final tukendiMi = stokAdedi == 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: tukendiMi ? Colors.red.shade100 : Colors.green.shade100,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: tukendiMi ? Colors.red.shade100 : Colors.green.shade100,
          width: 0.6,
        ),
      ),
      child: Text(
        tukendiMi ? "Tükendi" : "Stokta",
        style: TextStyle(
          color: tukendiMi ? Colors.red.shade900 : Colors.green.shade900,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}