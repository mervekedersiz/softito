/*
  abstract class AutREPO {
    Future<void>login(String email, String password);
    Future<void>logout();
    bool get isAuth;

  }
  class FirebaseAuthrepo implements AutREPO{
    @override
    Future<void> login(String email, String password) async {
      return"firebase_token_xyz_123";

  }
@override 
 Future<void>logout() async{
    
  }
  @override
  bool get isAuth => true;
  }
  //test ve offline simülasyon
  class MockAuthRepo implements AutREPO{
    @override
    Future<void> login(String email, String password) async {
      await Future.delayed(Duration(seconds:2));
      return "mock_token_abc_789";
  

  }
  @override
  Future<void>logout() async{
    
  }
  @override
  bool get isAuth => true;
  }
  //implemts extends farkı nedir
  //implemts kodu alamaz extends ise kodu da alır verileri alır 
  //mixin ve with farkı nedir
  //mixle fonksiyonu açıyorz
  //with ise mixin ile birlikte kullanıyoruz

    mixin Logger{
    void log(String msg)=> print("Log:$msg");
  }
    mixin Analytics{
    void log(String msg)=> print("Analytics:$msg");
  }
    mixin PaymentService with Logger, Analytics{
    void pay(){
      log("Payment processed");
    }
    }abstract class BaseWidget{
    //SADECEbasewidget ve altsınıflarda kullanılan-bilir
    mixin Lifelogger on BaseWidget{
      void LogInıt()=>print("Widget initialized");
    }
  }



  extension StringExtension on String{
    bool get isValidEmail{
      final emailRegex=RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      return emailRegex.hasMatch(this);
    }
    String ToCapitalize(){
    if(isEmpty) return this;
    return this[0].toUpperCase()+substring(1);
  }  }
  //kullanımı 
 void main(){
  String email=("blabla@fmail.com"  );
  if(email.isValidEmail){
    print("Email is valid");
  }else{
      print("Email is not valid");
     }}
    

  abstract class Identifiable {
  String get id;
}
// T tipi Mutlafa Identifiable arayüzübü uygulamak ZORUNDADIR
class GenericCache<T extends Identifiable> {
  final Map<String, T> _storage = {};

  void save(T item) {
    _storage[item.id] = item;
    print("ID:${item.id} önbelleğe alındı");
  }

  T? getById(String id) => _storage[id];
}
void save(T item) {
    _storage[item.id] = item;
    print("ID:${item.id} önbelleğe alındı");
  }

  T? getById(String id) => _storage[id]
  */

import 'dart:async';

void main() {
  print("1.Senkron başladı");
  scheduleMicrotask(() {
    print("2.Task Oluştu(Vip Kuyruk)");
  });
  Future(() {
    print("3.Standart Event Kuyruğu");
  });
  Future.microtask(() {
    print("4.Future.microtask çalıştı");
  });

  print("5.Senkron kod tamamlandı");
}
// future veri tipinden bağımdız çalışır. Future mikrotask ve standart event kuyruğu olmak üzere ikiye ayrılır. Mikrotask kuyruğu, standart event kuyruğundan daha yüksek önceliğe sahiptir. Bu nedenle, mikrotask kuyruğundaki görevler, standart event kuyruğundaki görevlerden önce çalıştırılır.
