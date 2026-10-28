import 'package:flutter/material.dart';

import '../models/kategori.dart';
import '../models/urun.dart';
import '../services/urun_servisi.dart';
import '../services/mock_urun_servisi.dart';
import '../widget/urun_karti.dart';

class UrunListesiEkrani extends StatefulWidget {
  const UrunListesiEkrani({super.key});

  @override
  State<UrunListesiEkrani> createState() => _UrunListesiEkraniState();
}

class _UrunListesiEkraniState extends State<UrunListesiEkrani> {
  final UrunServisi _servis = MockUrunServisi();

  final TextEditingController _aramaController = TextEditingController();
  bool _yukleniyorMu = true;

  Kategori _seciliKategori = Kategori.hepsi;

  List<Urun> _tumUrunler = [];
  List<Urun> _filtrelenmisUrunler = [];
  List<Urun> _gosterilenUrunler = [];
  
  @override
  void initState() {
    super.initState();
    _urunleriYukle();
  }

  Future<void> _urunleriYukle() async {
    setState(() {
      _yukleniyorMu = true;
    });

    final urunler = await _servis.tumUrunleriGetir();
    
    if (mounted) {
      setState(() {
        _tumUrunler = urunler;
        _filtrelenmisUrunler = urunler;
        _gosterilenUrunler = urunler;
        _yukleniyorMu = false;
      });
    }
  }

  void _filtreUrunleriUygula() {
    final aramaMetni = _aramaController.text.trim().toLowerCase();
    setState(() {
      _filtrelenmisUrunler = _tumUrunler.where((urun) {
        final kategoriUygunMu = _seciliKategori == Kategori.hepsi ||
            urun.kategori == _seciliKategori;

        final aramaUygunMu = aramaMetni.isEmpty ||
            urun.baslik.toLowerCase().contains(aramaMetni) ||
            urun.aciklama.toLowerCase().contains(aramaMetni);

        return kategoriUygunMu && aramaUygunMu;
      }).toList();
      _gosterilenUrunler = _filtrelenmisUrunler;
    });
  }

  void _favoriyiDegistir(Urun urun) {
    setState(() {
      final yeniUrun = urun.copyWith(favoriMi: !urun.favoriMi);
      final index = _tumUrunler.indexWhere((u) => u.id == urun.id);
      if (index != -1) {
        _tumUrunler[index] = yeniUrun;
        _filtreUrunleriUygula();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mini Mağaza"),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Badge(
              label: Text(
                '${_tumUrunler.where((u) => u.favoriMi).length}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Icon(Icons.favorite, color: Colors.red),
            ),
          ),
        ],
      ),
      body: _yukleniyorMu
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                  child: TextField(
                    controller: _aramaController,
                    onChanged: (_) => _filtreUrunleriUygula(),
                    decoration: InputDecoration(
                      hintText: "Ürün veya marka ara...",
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _aramaController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _aramaController.clear();
                                _filtreUrunleriUygula();
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: Kategori.values.map((kategori) {
                      final seciliMi = _seciliKategori == kategori;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                        child: ChoiceChip(
                          label: Text(kategori.baslik),
                          selected: seciliMi,
                          onSelected: (secildi) {
                            if (secildi) {
                              setState(() {
                                _seciliKategori = kategori;
                                _filtreUrunleriUygula();
                              });
                            }
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _filtrelenmisUrunler.length,
                    itemBuilder: (context, index) {
                      final urun = _filtrelenmisUrunler[index];
                      return UrunKarti(
                        urun: urun,
                        onFavoriTiklandi: () => _favoriyiDegistir(urun),
                        onDetayTiklandi: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${urun.baslik} tıklandı!'),
                              duration: const Duration(milliseconds: 600),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
    