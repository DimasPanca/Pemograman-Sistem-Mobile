import 'package:firebase_core/firebase_core.dart';

// Nilai ini hanya untuk pengujian dengan Firebase Emulator (project demo).
// Untuk project Firebase asli, jalankan "flutterfire configure" dan berkas
// ini akan ditimpa otomatis dengan konfigurasi project tersebut.
class DefaultFirebaseOptions {
  static const FirebaseOptions currentPlatform = FirebaseOptions(
    apiKey: 'demo-api-key',
    appId: '1:1234567890:web:tokokita',
    messagingSenderId: '1234567890',
    projectId: 'demo-tokokita',
    authDomain: 'demo-tokokita.firebaseapp.com',
    storageBucket: 'demo-tokokita.appspot.com',
  );
}
