// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'firebase_options.dart';

// Ubah menjadi false setelah firebase_options.dart dibuat oleh flutterfire configure.
const bool kPakaiEmulator = true;

Future<void> initFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (kPakaiEmulator) {
    final host = kIsWeb ? 'localhost' : '10.0.2.2';
    await FirebaseAuth.instance.useAuthEmulator(host, 9099);
    FirebaseFirestore.instance.useFirestoreEmulator(host, 8080);
    print('Firebase terhubung ke emulator di $host');
  }
  print('Firebase siap, project ${Firebase.app().options.projectId}');
}
