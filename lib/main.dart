import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyCIUtgBdfWiZnvkl6Cir-i0Xrvh3-Gchxo',
      authDomain: 'ashitfood-edd09.firebaseapp.com',
      projectId: 'ashitfood-edd09',
      storageBucket: 'ashitfood-edd09.appspot.com',
      messagingSenderId: '555716538397',
      appId: '1:555716538397:android:f4d3bc92ceaca116f116f4',
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Donation App',
      home: MySplashScreen(), // Use the MySplashScreen widget here
    );
  }
}
