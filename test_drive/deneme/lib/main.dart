import 'package:flutter/material.dart';

void main() {
  runApp(const BenimUygulamam());
}

// 1. Uygulamanın Ana Çerçevesi (Stateless)
class BenimUygulamam extends StatelessWidget {
  const BenimUygulamam({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SayacSayfasi(), // Ana ekrana Sayaç Sayfamızı koyuyoruz
    );
  }
}

// 2. Sayaç Ekrani (Değişken veri tutacağı için StatefulWidget)
class SayacSayfasi extends StatefulWidget {
  const SayacSayfasi({super.key});

  @override
  State<SayacSayfasi> createState() => _SayacSayfasiState();
}

class _SayacSayfasiState extends State<SayacSayfasi> {
  // A) DEĞİŞKENİ TANIMLIYORUZ (Sayıyı hafızada tutan yer)
  int sayac = 0;

  // B) SAYAÇ ARTIRMA FONKSİYONU
  void artir() {
    setState(() {
      sayac++; // Ekrana yansıması için setState ŞART!
    });
  }

  // C) SAYAÇ SIFIRLAMA FONKSİYONU
  void sifirla() {
    setState(() {
      sayac = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sayaç Uygulaması'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Dikeyde ortala
          children: [
            const Text(
              'Butona kaç kez bastın:',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10), // Araya boşluk koyar
            Text(
              '$sayac', // Ekranda değişkenin değerini gösteriyoruz
              style: const TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 20),
            // Sıfırlama Butonu
            ElevatedButton.icon(
              onPressed: sifirla,
              icon: const Icon(Icons.refresh),
              label: const Text('Sıfırla'),
            ),
          ],
        ),
      ),
      // Sağ alttaki Artırma Butonu (+ ikonu)
      floatingActionButton: FloatingActionButton(
        onPressed: artir,
        child: const Icon(Icons.add),
      ),
    );
  }
}
