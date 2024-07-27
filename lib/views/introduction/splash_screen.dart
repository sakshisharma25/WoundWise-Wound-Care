// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:woundwise/services/storage_services.dart';
import 'package:woundwise/views/dashboard/dashboard_screen.dart';
import 'dart:async';
import 'package:woundwise/views/introduction/login_or_register_screen.dart';
import 'package:woundwise/views/introduction/intro_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _FlashScreen0State();
}

class _FlashScreen0State extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _handleLaunchNavigation();
  }

  Future<void> _handleLaunchNavigation() async {
    await Future.delayed(const Duration(seconds: 2));
    // Check if user is logged in
    final bool isUserLoggedIn = await StorageServices.isUserLoggedIn();
    final accountData = await StorageServices.getUserData();
    final accountType = accountData.accountType;
    if (isUserLoggedIn && accountType != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardScreen(accountType: accountType),
          settings: const RouteSettings(name: "DashboardScreen"),
        ),
      );
      return;
    }

    // If user is not logged in, check if it's first launch
    final bool isFirstLaunch = await StorageServices.checkIsFirstLaunch();
    if (isFirstLaunch) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const IntroScreen(),
          settings: const RouteSettings(name: "IntroScreen"),
        ),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginOrRegisterScreen(),
        settings: const RouteSettings(name: "LoginOrRegisterScreen"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/splash-background.png',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomCenter,
                colors: [
                  Colors.white.withOpacity(0.01),
                  Colors.white.withOpacity(1.00),
                ],
                stops: const [
                  0.8,
                  1.0,
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.topCenter,
            margin: const EdgeInsets.only(top: 160),
            child: Image.asset('assets/logo1.png', height: 100),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            margin: const EdgeInsets.only(bottom: 60),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 70),
              child: LinearProgressIndicator(
                color: Color(0xFF1A237E),
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
