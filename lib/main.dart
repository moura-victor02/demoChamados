// ignore_for_file: depend_on_referenced_packages, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:your_project_name/PageLogin/loginpage.dart';
import 'package:your_project_name/pageAdmin.dart';
import 'package:your_project_name/pagUser/pageUser.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyDLVVQarC01Cm1KFESqRRsMFuBMbr9XNe8",
        authDomain: "fir-gns.firebaseapp.com",
        projectId: "fir-gns",
        storageBucket: "fir-gns.appspot.com",
        messagingSenderId: "376417530582",
        appId: "1:376417530582:web:074d2b27cd88899480cf77"),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minha aplicação',
      initialRoute: '/',
      theme: ThemeData(
        primarySwatch: MaterialColor(0xFF1E293B, {
          50: Color(0xFF1E293B),
          100: Color(0xFF1E293B),
          200: Color(0xFF1E293B),
          300: Color(0xFF1E293B),
          400: Color(0xFF1E293B),
          500: Color(0xFF1E293B),
          600: Color(0xFF1E293B),
          700: Color(0xFF1E293B),
          800: Color(0xFF1E293B),
          900: Color(0xFF1E293B),
        }),
      ),
      onGenerateRoute: _generateRoute,
    );
  }

  Route<dynamic> _generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        //   return MaterialPageRoute(builder: (context) => LoginPage());
        return MaterialPageRoute(builder: (context) => PageUser());

      // ... adicione outros casos para outras rotas

      default:
        throw Exception('Rota não definida');
    }
  }
}
