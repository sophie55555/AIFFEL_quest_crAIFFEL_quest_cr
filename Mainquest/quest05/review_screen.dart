import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'review_model.dart';
import 'package:http/http.dart' as http;

// 전역 변수 (상태 관리 라이브러리 사용을 권장)
List<Review> savedReviews = [];

class ReviewScreen extends StatefulWidget {
  final String title;
  const ReviewScreen({Key? key, required this.title}) : super(key: key);

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  File? _image;
  final FocusNode _textFieldFocusNode = FocusNode();
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Future.delayed 를 사용하여 Focus 를 주는 방식 (대안)
    Future.delayed(Duration.zero, () {
      FocusScope.of(context).requestFocus(_textFieldFocusNode);
    });
  }

  @override
  void dispose() {
    _textFieldFocusNode.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  Future<bool> _requestPhotosPermission() async {
    var status = await Permission.photos.status;
    if (!status.isGranted) {
      status = await Permission.photos.request();
    }
    return status.isGranted;
  }

  Future<void> _pickImage(ImageSource source) async {
    if (await _requestPhotosPermission()) {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedImage = await picker.pickImage(
        source: source,
        maxWidth: 800, // 최대 너비
        maxHeight: 600, // 최대 높이
      );
      setState(() {
        if (pickedImage != null) {
          _image = File(pickedImage.path);
        } else {
          print('이미지가 선택되지 않았습니다.');
        }
      });
    } else {
      print('사진 접근 권한이 거부되었습니다.');
      // 사용자에게 권한 설정 방법을 안내하는 다이얼로그 표시
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('사진 접근 권한 필요'),
            content: const Text('사진을 선택하려면 사진 접근 권한이 필요합니다. 설정에서 권한을 허용해주세요.'),
            actions: [
              TextButton(
                child: const Text('설정으로 이동'),
                onPressed: () {
                  openAppSettings(); // 설정 앱 열기
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('취소'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  // 예시: Gemini API를 사용하여 텍스트 분석
  Future<Map<String, dynamic>> analyzeTextWithGemini(String text) async {
    // 1. API 키 설정 (안전한 방법으로 관리)
    const apiKey = 'YOUR_GEMINI_API_KEY'; // 여기에 실제 API 키를 넣으세요.

    // 2. Gemini API 엔드포인트 설정
    final url = Uri.parse('https://generative-ai.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$apiKey');

    // 3. API 요청 헤더 설정
    final headers = {'Content-Type': 'application/json'};

    // 4. API 요청 바디 설정 (분석할 텍스트 전달)
    final body = jsonEncode({
      'contents': [
        {'parts': [
          {'text': 'Analyze the sentiment and categorize this text: $text'}
        ]}
      ]
    });

    // 5. API 호출
    try {
      final response = await http.post(url, headers: headers, body: body);

      // 6. API 응답 확인
      if (response.statusCode == 200) {
        // 7. API 응답 JSON 파싱
        final jsonResponse = jsonDecode(response.body);

        // 8. 분석 결과 반환
        // 이 부분은 실제 Gemini API 응답 구조에 따라 달라집니다.
        // 아래는 가상의 응답 구조를 가정한 예시입니다.
        return {
          'sentiment': 'Positive', // Replace with actual sentiment from API
          'category': 'Fiction', // Replace with actual category from API
          'authors': ['Unknown'] // Replace with actual authors from API
        };
      } else {
        // 9. API 오류 처리
        print('Gemini API Error: ${response.statusCode}, ${response.body}');
        return {'error': 'Gemini API 호출 실패'};
      }
    } catch (e) {
      // 예외 발생 시 처리
      print('Exception during Gemini API call: $e');
      return {'error': 'Gemini API 호출 중 예외 발생'};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 20),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    _pickImage(ImageSource.camera);
                  },
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('사진 촬영'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    _pickImage(ImageSource.gallery);
                  },
                  icon: const Icon(Icons.photo_library),
                  label: const Text('갤러리에서 선택'),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                _pickImage(ImageSource.gallery); // 이미지 선택 다이얼로그 표시
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 16.0),
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _image != null
                    ? Image.file(
                  _image!,
                  fit: BoxFit.cover,
                )
                    : Center(
                  child: Text(
                    '이미지를 선택해주세요.',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ),
              ),
            ),
            TextField(
              controller: _textEditingController,
              focusNode: _textFieldFocusNode,
              decoration: InputDecoration(
                hintText: '서평을 작성해주세요.',
                border: const OutlineInputBorder(),
                hintStyle: TextStyle(color: Colors.grey.shade500),
              ),
              maxLines: 5,
              onChanged: (text) {
                setState(() {});
              },
            ),
            ElevatedButton(
              onPressed: () async {
                if (_image != null && _textEditingController.text.isNotEmpty) {
                  // 1. Gemini API를 사용하여 서평 분석
                  final analysisResult = await analyzeTextWithGemini(_textEditingController.text);

                  if (analysisResult.containsKey('error')) {
                    // 에러 처리 (예: 사용자에게 메시지 표시)
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('서평 분석에 실패했습니다: ${analysisResult['error']}')),
                    );
                    return;
                  }

                  // 2. Review 객체 생성 및 분석 결과 저장
                  final newReview = Review(
                    image: _image!,
                    text: _textEditingController.text,
                    sentiment: analysisResult['sentiment'],
                    category: analysisResult['category'],
                    authors: (analysisResult['authors'] as List<dynamic>).cast<String>(),
                  );

                  // 3. 전역 변수에 리뷰 추가 (상태 관리 라이브러리 사용 권장)
                  savedReviews.add(newReview);

                  // 4. 리뷰 저장 후 이전 화면으로 돌아감
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('이미지와 서평을 모두 입력해주세요.')),
                  );
                }
              },
              child: const Text('저장'),
            ),
          ],
        ),
      ),
    );
  }
}