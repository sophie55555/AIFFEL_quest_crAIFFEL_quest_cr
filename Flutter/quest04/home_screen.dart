import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// 메인 앱 위젯
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

// 홈 스크린 위젯
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const BookClubScreen(title: 'BOOK CLUB'),
    const CategoryScreen(title: '라이브'),
    const CategoryScreen(title: '커뮤니티'),
    const CategoryScreen(title: '내 서재'),
    const CategoryScreen(title: '내 계정'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 배경 이미지
          Positioned.fill(
            child: Image.asset(
              'assets/images/home_screen_1.png',
              fit: BoxFit.cover,
            ),
          ),
          // 메인 컨텐츠 (페이지)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 50),
              child: _pages[_selectedIndex],
            ),
          ),
          Positioned(
            // 하단 네비게이션 바를 Stack 내에 배치
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: BottomNavigationBar(
                elevation: 0, // 그림자 제거
                backgroundColor: Colors.transparent, // 배경색 투명하게 설정
                type: BottomNavigationBarType.fixed,
                items: [
                  BottomNavigationBarItem(icon: Image.asset('assets/icons/home.png', width: 24, height: 24), label: ''),
                  BottomNavigationBarItem(icon: Image.asset('assets/icons/live.png', width: 24, height: 24), label: ''),
                  BottomNavigationBarItem(icon: Image.asset('assets/icons/community.png', width: 24, height: 24), label: ''),
                  BottomNavigationBarItem(icon: Image.asset('assets/icons/library.png', width: 24, height: 24), label: ''),
                  BottomNavigationBarItem(icon: Image.asset('assets/icons/profile.png', width: 24, height: 24), label: ''),
                ],
                currentIndex: _selectedIndex,
                selectedItemColor: Colors.redAccent,
                onTap: _onItemTapped,
                showSelectedLabels: false,
                showUnselectedLabels: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 카테고리 스크린 위젯
class CategoryScreen extends StatelessWidget {
  final String title;

  const CategoryScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Text(
          title,
          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}

// 북 클럽 스크린 위젯
class BookClubScreen extends StatelessWidget {
  final String title;

  const BookClubScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.2),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text('더보기'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: SizedBox(
                                height: 60,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    const Text(
                                      'sdfsdfs',
                                      style: TextStyle(fontSize: 16, color: Colors.white),
                                    ),
                                  ],
                                )
                            )
                        );
                      }
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 30,
          // 원하는 위치 조정 (값을 줄여서 더 위로 올림)
          right: 20,
          // 원하는 위치 조정
          child: IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}