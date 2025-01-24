import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CatScreen()
    );
  }
}

class CatScreen extends StatelessWidget{
  bool is_cat = true;
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("First Page"),
        centerTitle: true, // 타이틀을 중앙으로 정렬
        backgroundColor: Colors.blue, // AppBar 색상
        leading: Icon(FontAwesomeIcons.cat), // 왼쪽 상단 아이콘
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DogScreen())
                ); // 클릭 시 DEBUG 콘솔 출력
              },
              child: Text(
                "Next",
                style: TextStyle(fontSize: 40),
              ), // 버튼 텍스트
            ),
            SizedBox(height: 20), // 버튼과 Stack 사이 간격
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: GestureDetector(
                  onTap: (){
                    print(is_cat);
                  },
                  child: Image.asset(
                    'images/cat.jpeg',
                    width: 300,
                    height: 300,

                  )
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DogScreen extends StatelessWidget{
  bool is_cat = false;
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Page"),
        centerTitle: true, // 타이틀을 중앙으로 정렬
        backgroundColor: Colors.blue, // AppBar 색상
        leading: Icon(FontAwesomeIcons.dog), // 왼쪽 상단 아이콘
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Back",
                style: TextStyle(fontSize: 40),
              ), // 버튼 텍스트
            ),
            SizedBox(height: 20), // 버튼과 Stack 사이 간격
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: GestureDetector(
                  onTap: (){
                    print(is_cat);
                  },
                  child: Image.asset(
                    'images/dog.jpeg',
                    width: 300,
                    height: 300,
                  )
              ),
            )
          ],
        ),
      ),
    );
  }
}