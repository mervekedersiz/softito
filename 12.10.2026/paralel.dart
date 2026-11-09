/*

Future<void> fetchDashboardData() async {
  try {
    final result = await Future.wait([
      fetchUserProfile(),
      fetchAccountBalance(),
      fetchNotification(),
    ], eagerError: true);

    print("Tüm veriler geldi $result");
  } catch (e) {
    print("İsteklerden Biri başarısız oldu $e");
  }
}

*/

//Future:Tek bir kere veri çekileceği zaman kullanılır ya hata yada değer dönüp bitirir
//Stream:Bir boru hattı şeklinde çalışır (pipe) , Zaman içinde 1 10 100 yada sonsuz sayida veri akılı sağlanabilir
//(Borsa fiyatları GPS konum güncelleme,Firebase canlı dinleme)

import 'dart:async';

void main() {
  //controller oluşturna
  final controller = StreamController<int>();
  //dinleyici (listenir ekleme)
  final subscription = controller.stream.listen(
    (data) => print("yeni Veri: $data"),
    onError: (err) => print("Hata Oluştu: $err"),
    onDone: () => print("Yayın Tamamlandıs"),
  );

  controller.sink.add(10);
  controller.sink.add(20);
  controller.sink.add(30);
  //aynı fonksiyon içerisinde ya tekil ya da çoklu dinleyici kullanılabilir
  //ikisi aynı anda kullanılamaz
  //
  final broadcastStream = controller.stream.asBroadcastStream();
  broadcastStream.listen((d) => print("Dinleyici 1: $d"));
  broadcastStream.listen((d) => print("Dinleyici 2: $d"));
  controller.close();
}
