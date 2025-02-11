// library_analysis_screen.dart
import 'dart:io'; // File 클래스를 사용하기 위해 import
import 'package:flutter/services.dart'; // rootBundle 사용하기 위해 import
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:path_provider/path_provider.dart';
// ReviewData 클래스 (가정)
class ReviewData {
  final String bookTitle;
  final String author;
  final String genre;
  final DateTime reviewDate;
  final String reviewContent;

  ReviewData({
    required this.bookTitle,
    required this.author,
    required this.genre,
    required this.reviewDate,
    required this.reviewContent,
  });
}

class LibraryAnalysisScreen extends StatefulWidget {
  const LibraryAnalysisScreen({Key? key}) : super(key: key);

  @override
  State<LibraryAnalysisScreen> createState() => _LibraryAnalysisScreenState();
}

class _LibraryAnalysisScreenState extends State<LibraryAnalysisScreen> {
  String _analysisResult = '';
  bool _isLoading = false;
  String _geminiError = '';

  // assets/books 폴더의 이미지 파일 목록 (수정 필요)
  List<String> _bookImagePaths = [
    'assets/books/1.png',
    'assets/books/2.png',
    'assets/books/3.png',
    'assets/books/4.png',
    'assets/books/5.png',
  ];

  List<ReviewData> _reviewData = [
    ReviewData(bookTitle: '토지', author: '박경리', genre: '소설', reviewDate: DateTime(2024, 5, 10), reviewContent: '감동적인 소설'),
    ReviewData(bookTitle: '자기계발서1', author: '김작가', genre: '자기계발', reviewDate: DateTime(2024, 5, 15), reviewContent: '동기부여가 되는 책'),
    ReviewData(bookTitle: '에세이1', author: '이작가', genre: '에세이', reviewDate: DateTime(2024, 6, 1), reviewContent: '마음이 따뜻해지는 에세이'),
    ReviewData(bookTitle: '토지2', author: '박경리', genre: '소설', reviewDate: DateTime(2024, 6, 20), reviewContent: '역사소설의 최고봉'),
    ReviewData(bookTitle: '경영학원론', author: '최교수', genre: '경영', reviewDate: DateTime(2024, 7, 5), reviewContent: '경영학 입문서'),
    ReviewData(bookTitle: '미움받을 용기', author: '아들러', genre: '자기계발', reviewDate: DateTime(2024, 7, 12), reviewContent: '인생에 대한 새로운 시각'),
  ];

  @override
  void initState() {
    super.initState();
    _loadBookImagesAndAnalyze();
  }

  Future<void> _loadBookImagesAndAnalyze() async {
    setState(() {
      _isLoading = true;
      _geminiError = '';
      _analysisResult = '';
    });

    // 각 이미지 파일에 대해 OCR 및 Gemini API 호출
    List<String> extractedGenres = [];
    for (String imagePath in _bookImagePaths) {
      // 1. 이미지에서 텍스트 추출 (OCR)
      String extractedText = await _extractTextFromImage(imagePath);
      print('Extracted text from $imagePath: $extractedText');

      // 2. Gemini API에 텍스트 전달하여 장르 정보 추출
      String genre = await _getGenreFromGemini(extractedText);
      print('Genre from Gemini API: $genre');

      extractedGenres.add(genre);
    }

    // 3. 추출된 장르 정보로 분석 수행
    await _analyzeLibraryWithGemini(extractedGenres);

    setState(() {
      _isLoading = false;
    });
  }

  // Google ML Kit Text Recognition 사용
  Future<String> _extractTextFromImage(String imagePath) async {
    try {
      // Assets에서 이미지 파일을 읽어오기
      final ByteData data = await rootBundle.load(imagePath);
      final List<int> bytes = data.buffer.asUint8List();

      // 임시 파일 생성
      final tempDir = await getTemporaryDirectory();
      File imageFile = File('${tempDir.path}/temp_image.png');
      await imageFile.writeAsBytes(bytes);

      final inputImage = InputImage.fromFile(imageFile);
      final textRecognizer = TextRecognizer(script: TextRecognitionScript.korean);
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      String text = recognizedText.text;
      textRecognizer.close();

      // 임시 파일 삭제
      imageFile.delete();
      return text;
    } catch (e) {
      print('OCR 오류: $e');
      return '';
    }
  }


  // Gemini API에 텍스트 전달하여 장르 정보 추출
  Future<String> _getGenreFromGemini(String text) async {
    const String apiKey = 'AIzaSyB3b3rpSK7RkwB_Vw_nVO5HQ7Xwfov3xFI'; // 여기에 API 키를 넣으세요 (안전하게 관리해야 함)
    const String apiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$apiKey';

    String prompt = '''
    다음 텍스트는 책 표지에서 추출한 텍스트입니다. 이 텍스트를 바탕으로 책의 장르를 추론해주세요.
    텍스트: $text
    ''';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": prompt}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
        final genre = jsonResponse['candidates'][0]['content']['parts'][0]['text'];
        return genre;
      } else {
        print('Gemini API 오류: ${response.statusCode}, ${response.body}');
        return 'Unknown'; // 에러 발생 시 Unknown 반환
      }
    } catch (e) {
      print('Gemini API 호출 중 오류: $e');
      return 'Unknown'; // 에러 발생 시 Unknown 반환
    }
  }

  // Gemini API를 사용하여 분석 수행
  Future<void> _analyzeLibraryWithGemini(List<String> genres) async {
    setState(() {
      _isLoading = true;
      _geminiError = '';
      _analysisResult = '';
    });

    const String apiKey = 'AIzaSyB3b3rpSK7RkwB_Vw_nVO5HQ7Xwfov3xFI'; // 여기에 API 키를 넣으세요 (안전하게 관리해야 함)
    const String apiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$apiKey';

    String prompt = '''
    다음은 사용자의 서재에 있는 책들의 장르 목록입니다. 이 목록을 분석하여 사용자가 가장 선호하는 장르와 그 이유를 간단하게 요약해주세요.
    장르 목록: ${genres.join(', ')}
    ''';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": prompt}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
        final analysis = jsonResponse['candidates'][0]['content']['parts'][0]['text'];
        setState(() {
          _analysisResult = analysis;
        });
      } else {
        setState(() {
          _geminiError = 'Gemini API 오류: ${response.statusCode}';
        });
        print('Gemini API 오류: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      setState(() {
        _geminiError = 'Gemini API 호출 중 오류: $e';
      });
      print('Gemini API 호출 중 오류: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // (기존 UI 코드 유지)
    Map<String, double> monthlyGenreData = {}; // 차트 데이터 초기화
    for (var review in _reviewData) {
      String genre = review.genre;
      if (monthlyGenreData.containsKey(genre)) {
        monthlyGenreData[genre] = monthlyGenreData[genre]! + 1;
      } else {
        monthlyGenreData[genre] = 1;
      }
    }

    Map<String, double> authorData = {}; // 저자 데이터 초기화
    _reviewData.forEach((review) {
      String author = review.author;
      if (authorData.containsKey(author)) {
        authorData[author] = authorData[author]! + 1;
      } else {
        authorData[author] = 1;
      }
    });

    List<MapEntry<String, double>> topAuthors = authorData.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    List<MapEntry<String, double>> top3Authors = topAuthors.take(3).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              // TODO: 설정 화면으로 이동
            },
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF64FFDA),
              Color(0xFF004D40),
            ],
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                "Sophie",
                style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCounterColumn("100\n서평"),
                _buildCounterColumn("100\n팔로워"),
                _buildCounterColumn("100\n팔로잉"),
                _buildCounterColumn("100\n방문자"),
              ],
            ),
            const SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "내 서재 분석",
                    style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "서재 책 수: 5권",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "카테고리별 독서 현황",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  // PieChart( // 제대로 동작하지 않아서 주석처리
                  //   dataMap: monthlyGenreData.map((key, value) => MapEntry(key, value.toDouble())),
                  //   animationDuration: const Duration(milliseconds: 800),
                  //   chartRadius: MediaQuery.of(context).size.width / 3,
                  //   initialAngleInDegree: 0,
                  //   chartType: ChartType.ring,
                  //   ringStrokeWidth: 32,
                  //   centerText: "독서 현황",
                  //   legendOptions: const LegendOptions(
                  //     showLegendsInRow: false,
                  //     legendPosition: LegendPosition.right,
                  //     showLegends: true,
                  //     legendShape: BoxShape.circle,
                  //     legendTextStyle: TextStyle(
                  //       fontWeight: FontWeight.bold,
                  //       color: Colors.white,
                  //     ),
                  //   ),
                  //   chartValuesOptions: const ChartValuesOptions(
                  //     showChartValueBackground: false,
                  //     showChartValues: false,
                  //     decimalPlaces: 0,
                  //     chartValueStyle: TextStyle(
                  //       color: Colors.white,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Gemini 분석 결과",
                    style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  if (_isLoading)
                    const Center(child: CircularProgressIndicator(color: Colors.white)),
                  if (_geminiError.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _geminiError,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  if (_analysisResult.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _analysisResult,
                        style: const TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "내 서재의 저자 순위",
                    style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "총 617권",
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    children: top3Authors.map((entry) {
                      return _buildRankingItem(entry.key, entry.value.toInt().toString(), ((entry.value / _reviewData.length) * 100).toStringAsFixed(1));
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "내 서평",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  const SizedBox(height: 5),
                  _buildListTile("100"),
                  const SizedBox(height: 10),
                  const Text(
                    "나의 팔로워 서재",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  const SizedBox(height: 5),
                  _buildListTile("100"),
                  const SizedBox(height: 10),
                  const Text(
                    "내가 팔로잉한 서재",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  const SizedBox(height: 5),
                  _buildListTile("100"),
                ],
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // TODO: 공유하기 기능 구현
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text("공유하기"),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  static Widget _buildCounterColumn(String text) {
    return Column(
      children: [
        Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  static Widget _buildRankingItem(String title, String count, String percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          Text(
            "$count 권 ($percentage%)",
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }

  static Widget _buildListTile(String count) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            count,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
        ],
      ),
    );
  }
}