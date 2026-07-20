import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform => web;

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBpATRLy_E4njlbWhCHLHTU7Kc-SAaZXak',
    appId: '1:358072415764:web:3161dbaa604704cd63d901',
    messagingSenderId: '358072415764',
    projectId: 'angoracaferes',
    authDomain: 'angoracaferes.firebaseapp.com',
    storageBucket: 'angoracaferes.firebasestorage.app',
  );
}
