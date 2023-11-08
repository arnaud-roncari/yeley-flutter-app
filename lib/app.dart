import 'package:flutter/material.dart';
import 'package:yeley_frontend/pages/address_form.dart';
import 'package:yeley_frontend/pages/home.dart';
import 'package:yeley_frontend/pages/login.dart';
import 'package:yeley_frontend/pages/privacy_policy.dart';
import 'package:yeley_frontend/pages/signup.dart';
import 'package:yeley_frontend/pages/terms_of_use.dart';

class YeleyApp extends StatelessWidget {
  final bool isSession;
  const YeleyApp({super.key, required this.isSession});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Yeley',
      initialRoute: isSession ? "/home" : "/signup",
      routes: {
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(),
        '/home': (context) => const HomePage(),
        '/terms-of-use': (context) => const TermsOfUsePage(),
        '/privacy-policy': (context) => const PrivacyPolicyPage(),
        '/address-form': (context) => const AddressFormPage(),
      },
    );
  }
}
