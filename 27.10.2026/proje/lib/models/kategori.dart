
enum Kategori {
  hepsi('Tümü', 'H'),
  elektronik('Elektronik', 'E'),
  giyim('Giyim', 'G'),
  evYasam('Ev & Yaşam', 'EV'),
  kozmetik('Kozmetik', 'K'),
  spor('Spor', 'S'),
  oyuncak('Oyuncak', 'O');

  final String baslik;
  final String icon;

  const Kategori(this.baslik, this.icon);
}