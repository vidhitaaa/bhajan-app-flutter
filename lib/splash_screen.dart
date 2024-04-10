import 'dart:async';
import 'package:flutter/material.dart';
import 'package:bhajan_app_flutter/Contentspage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Contentspage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    HexColor("#390000"),
                    Colors.black
                  ], // Define your gradient colors here
                ),
              ),
            ),
          ),
          // First Layer: Background Image
          Positioned.fill(
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(0.25), BlendMode.dstATop),
              child: Image.asset(
                'images/bg.png', // Replace with the actual path to your background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Second Layer: Centered Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image on top of the background
                ClipRRect(
                  borderRadius: BorderRadius.circular(0),
                  child: Image.asset(
                    'images/gfg.png', // Replace with your image path
                    width: 350, // Set your desired width
                    height: 350, // Set your desired height
                  ),
                ),
                const SizedBox(height: 20),
                // Text on top of the image
                Text(
                  'Sant Kavi \nPahlajram \nBhajanmala',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: HexColor('#FFEDCB'),
                    fontFamily: 'Ribeye',
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
