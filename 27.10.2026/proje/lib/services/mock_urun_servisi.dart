import '../models/urun.dart';
import 'urun_servisi.dart';
import '../models/kategori.dart';

class MockUrunServisi implements UrunServisi {
  final List<Urun> _urunler = const [
    Urun(
      id: '1',
      baslik: 'iphone',
      aciklama: 'Harika bir telefon',
      fiyat: 1000,
      resimUrl: 'https://fastly.picsum.photos/id/243/400/400.jpg?hmac=0jazqohYiaNEjBwrK4OpZWvSP6csG0AmdPb9wnfgVzU',
      kategori: Kategori.elektronik,
      stokAdedi: 10,
      favoriMi: false,
    ),
    Urun(
      id: '2',
      baslik: 'iphone',
      aciklama: 'Harika bir telefon',
      fiyat: 149.999,
      resimUrl: 'https://fastly.picsum.photos/id/243/400/400.jpg?hmac=0jazqohYiaNEjBwrK4OpZWvSP6csG0AmdPb9wnfgVzU',
      kategori: Kategori.giyim,
      stokAdedi: 10,
      favoriMi: false,
    ),
    Urun(
      id: '3',
      baslik: 'iphone',
      aciklama: 'Hzzarika! bir telefon',
      fiyat: 149.999,
      resimUrl: 'https://fastly.picsum.photos/id/243/400/400.jpg?hmac=0jazqohYiaNEjBwrK4OpZWvSP6csG0AmdPb9wnfgVzU',
      kategori: Kategori.evYasam,
      stokAdedi: 10,
      favoriMi: false,
    ),
    Urun(
      id: '4',
      baslik: 'fondoten ',
      aciklama: 'Harika bir telefon',
      fiyat: 149.999,
      resimUrl: 'https://fastly.picsum.photos/id/243/400/400.jpg?hmac=0jazqohYiaNEjBwrK4OpZWvSP6csG0AmdPb9wnfgVzU',
      kategori: Kategori.kozmetik,
      stokAdedi: 10,
      favoriMi: false,
    ),
    Urun(
      id: '5',
      baslik: 'Halısaha ayakkabısı',
      aciklama: 'Harika bir telefon',
      fiyat: 149.999,
      resimUrl: 'https://fastly.picsum.photos/id/243/400/400.jpg?hmac=0jazqohYiaNEjBwrK4OpZWvSP6csG0AmdPb9wnfgVzU',
      kategori: Kategori.spor,
      stokAdedi: 10,
      favoriMi: false,
    ),
    Urun(
      id: '6',
      baslik: 'lego',
      aciklama: 'Harika bir leg',
      fiyat: 149.999,
      resimUrl: 'https://fastly.picsum.photos/id/243/400/400.jpg?hmac=0jazqohYiaNEjBwrK4OpZWvSP6csG0AmdPb9wnfgVzU',
      kategori: Kategori.oyuncak,
      stokAdedi: 10,
      favoriMi: false,
    ),
    Urun(
      id: '7',
      baslik: 'Koltuk',
      aciklama: 'Harika bir koltuk',
      fiyat: 149.999,
      resimUrl: 'https://fastly.picsum.photos/id/243/400/400.jpg?hmac=0jazqohYiaNEjBwrK4OpZWvSP6csG0AmdPb9wnfgVzU',
      kategori: Kategori.evYasam,
      stokAdedi: 10,
      favoriMi: false,
    ),
    Urun(
      id: '8',
      baslik: 'ruj',
      aciklama: 'Harika bir ruj',
      fiyat: 149.999,
      resimUrl: 'https://fastly.picsum.photos/id/243/400/400.jpg?hmac=0jazqohYiaNEjBwrK4OpZWvSP6csG0AmdPb9wnfgVzU',
      kategori: Kategori.kozmetik,
      stokAdedi: 10,
      favoriMi: false,
    ),
    Urun(
      id: '9',
      baslik: 'basketbol topu',
      aciklama: 'Harika bir top',
      fiyat: 149.999,
      resimUrl: 'https://fastly.picsum.photos/id/243/400/400.jpg?hmac=0jazqohYiaNEjBwrK4OpZWvSP6csG0AmdPb9wnfgVzU',
      kategori: Kategori.spor,
      stokAdedi: 10,
      favoriMi: false,
    ),
  ];

  @override
  Future<List<Urun>> tumUrunleriGetir() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_urunler);
  }

  @override
  Future<List<Urun>> kategoriyeGoreGetir(Kategori kategori) async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (kategori == Kategori.hepsi) {
      return List.from(_urunler);
    }
    return _urunler.where((urun) => urun.kategori == kategori).toList();
  }

  @override
  Future<List<Urun>> adaGoreArama(String aramaMetni) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (aramaMetni.trim().isEmpty) {
      return List.from(_urunler);
    }
    return _urunler.where((urun) {
      final baslikKucuk = urun.baslik.toLowerCase();
      final arananKucuk = aramaMetni.toLowerCase();
      return baslikKucuk.contains(arananKucuk);
    }).toList();
  }
}
