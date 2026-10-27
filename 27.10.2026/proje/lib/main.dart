import 'package:flutter/material.dart';
import 'package:proje/screens/urun-listesi_ekranı.dart';

void main() {
  runApp(const MiniMagaza());
}

class MiniMagaza extends StatelessWidget {
  const MiniMagaza({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MiniMağaza',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
      ),
      home: const UrunListesiEkrani(),
    );
  }
}