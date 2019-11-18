import 'package:firebase_messaging/firebase_messaging.dart';

 class push_noficacion_Provieder{

//iniciciar notificaciones y dar permissos
 FirebaseMessaging _firebaseMessaging=FirebaseMessaging();


 initNotificaciones(){

_firebaseMessaging.requestNotificationPermissions();
 //obtener el tocken





_firebaseMessaging.getToken().then((token){
 print(token);
});

_firebaseMessaging.configure(
 onMessage: (Map<String, dynamic> message) async {
  print('on message $message');
 },
 onResume: (Map<String, dynamic> message) async {
  print('on resume $message');
 },
 onLaunch: (Map<String, dynamic> message) async {
  print('on launch $message');
 },
);

 }}