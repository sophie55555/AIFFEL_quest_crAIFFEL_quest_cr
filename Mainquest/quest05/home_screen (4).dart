import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'book.dart';
import 'review_screen.dart';
import 'mylibrary_screen.dart';
import 'library_analysis_screen.dart'; // 분석 화면 import

class ImageAssets {
  static const String homeScreenBackground = 'assets/images/home_screen_1.png';
  static const String homeIcon = 'assets/icons/home.png';
  static const String libraryIcon = 'assets/icons/library.png';
  static const String reviewIcon = 'assets/icons/review.png';
  static const String messageIcon = 'assets/icons/message.png';
  static const String myLibraryIcon = 'assets/icons/mylibrary.png';
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const BookClubScreen(title: 'REVIEW'),
    const CategoryScreen(title: 'LIBRARY'),
    const ReviewScreen(title: 'MYREVIEW'),
    const CategoryScreen(title: 'MESSAGE'),
    const MyLibraryScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              ImageAssets.homeScreenBackground,
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(child: _pages[_selectedIndex]),
          Positioned(
            left: 0,
            right: 0,
            bottom: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Image.asset(ImageAssets.homeIcon, width: 24, height: 24),
                  onPressed: () => _onItemTapped(0),
                  color: _selectedIndex == 0 ? Colors.redAccent : Colors.white,
                ),
                IconButton(
                  icon: Image.asset(ImageAssets.libraryIcon, width: 24, height: 24),
                  onPressed: () => _onItemTapped(1),
                  color: _selectedIndex == 1 ? Colors.redAccent : Colors.white,
                ),
                IconButton(
                  icon: Image.asset(ImageAssets.reviewIcon, width: 24, height: 24),
                  onPressed: () => _onItemTapped(2),
                  color: _selectedIndex == 2 ? Colors.redAccent : Colors.white,
                ),
                IconButton(
                  icon: Image.asset(ImageAssets.messageIcon, width: 24, height: 24),
                  onPressed: () => _onItemTapped(3),
                  color: _selectedIndex == 3 ? Colors.redAccent : Colors.white,
                ),
                IconButton(
                  icon: Image.asset(ImageAssets.myLibraryIcon, width: 24, height: 24),
                  onPressed: () => _onItemTapped(4),
                  color: _selectedIndex == 4 ? Colors.redAccent : Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryScreen extends StatelessWidget {
  final String title;
  const CategoryScreen({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}

class BookClubScreen extends StatefulWidget {
  final String title;
  const BookClubScreen({Key? key, required this.title}) : super(key: key);

  @override
  _BookClubScreenState createState() => _BookClubScreenState();
}

class _BookClubScreenState extends State<BookClubScreen> {
  List<Book> _books = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _fetchBooks();
  }

  Future<void> _fetchBooks() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    const String apiUrl = 'https://www.nl.go.kr/NL/search/openApi/search.do?key=&kwd=%ED%86%A0%EC%A7%80';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final books = parseBooksFromXml(response.body);
        setState(() {
          _books = books;
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = '데이터를 불러오지 못했습니다 (HTTP ${response.statusCode})';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = '오류가 발생했습니다: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search, color: Colors.white),
                    onPressed: () {
                      // TODO: 검색 기능 구현
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _error.isNotEmpty
                  ? Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _error,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              )
                  : ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: _books.length,
                itemBuilder: (context, index) {
                  final book = _books[index];
                  return Card(
                    color: Colors.white.withOpacity(0.1),
                    elevation: 0,
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  book.title,
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  book.publisher ?? 'Unknown',
                                  style: TextStyle(color: Colors.white.withOpacity(0.7)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}