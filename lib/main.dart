// main.dart - Konfigurasi sederhana untuk testing
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Konfigurasi Firebase untuk Android
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyAuYiRFiPL-X9S2IzC89kuqTiVe4nlDcGI',
      appId: '1:306379046290:android:78f28b3ef750dd6d5b154b',
      messagingSenderId: '123456789',
      projectId: 'remidialpember',
      databaseURL: 'https://remidialpember-default-rtdb.firebaseio.com',
      storageBucket: 'remidialpember.appspot.com',
    ),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kegiatan Mahasiswa',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}