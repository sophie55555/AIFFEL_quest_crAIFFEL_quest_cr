import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home_screen.dart';

class ImageAssets {
  static const String mainBackground = 'assets/images/main.png';
  static const String mainButton = 'assets/images/main2.png';
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupSystemUI();
  runApp(const MyApp());
}

void setupSystemUI() {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Book List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // 배경을 투명하게 설정
      body: Stack(
        children: [
          // 전체 화면을 채우는 배경 이미지 (main.png)
          Positioned.fill(
            child: Image.asset(
              ImageAssets.mainBackground,
              fit: BoxFit.cover,
            ),
          ),
          // 중앙에 배치된 버튼 (main2.png)
          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.5, // 최대 너비 제한
                maxHeight: MediaQuery.of(context).size.height * 0.3, // 최대 높이 제한
              ),
              child: ElevatedButton(
                onPressed: () {
                  // MainScreen을 스택에서 제거하고 HomeScreen으로 이동
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent, // 버튼 배경을 투명하게
                  shadowColor: Colors.transparent, // 그림자 제거
                ),
                child: Image.asset(
                  ImageAssets.mainButton,
                  width: MediaQuery.of(context).size.width * 0.2, // 반응형 크기
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}