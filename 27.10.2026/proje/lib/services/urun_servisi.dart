import '../models/kategori.dart';
import '../models/urun.dart';


  abstract class UrunServisi{
    Future< List<Urun> > tumUrunleriGetir();

    Future< List<Urun> > kategoriyeGoreGetir(Kategori kategori);

    Future< List<Urun> > adaGoreArama(String aramaMetni);
  
  }