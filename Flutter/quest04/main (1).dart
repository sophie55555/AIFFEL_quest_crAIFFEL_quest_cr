import 'package:flutter/material.dart';
import 'home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/main1.png',  // 배경 이미지
            fit: BoxFit.cover,
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                // 👉 버튼 클릭 시 바로 HomeScreen으로 이동
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
              child: Image.asset(
                'assets/images/main2.png',  // 중앙 버튼 이미지
                width: 80,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
