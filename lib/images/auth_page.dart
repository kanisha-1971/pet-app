import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:petapp/home_page.dart';

import '../login_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return HomePage();
            }
            else{
              return LoginPage();
            }
          },
      ),

    );
  }
}