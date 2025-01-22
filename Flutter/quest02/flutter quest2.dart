import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // 디버그 배너 제거
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  void handleButtonClick() {
    debugPrint('버튼이 눌렸습니다.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: Icon(Icons.favorite, color: Colors.white),
        title: Text('플러터 앱 만들기'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: ElevatedButton(
                onPressed: handleButtonClick,
                child: Text('Text'),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 300,
                    height: 300,
                    color: Colors.red,
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      width: 240,
                      height: 240,
                      color: Colors.orange,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      width: 180,
                      height: 180,
                      color: Colors.yellow,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      width: 120,
                      height: 120,
                      color: Colors.green,
                     ),
                    ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                     width: 60,
                      height: 60,
                      color: Colors.blue,
                   ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 최유진: 여러 요소를 겹쳐서 표현하는 경우에 어떻게 해야하는지에 대해서 알게 되었다.
// positioned 속성에 대해서 익히고 나니 더 창의적인 UI를 만들어 보고 싶다!
// 고명지: stack의 위치를 지정할 때 Positioned를 활용하여 각 기준점을 정해주는 방법을 배웠음. 
