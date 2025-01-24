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

class CatScreen extends StatefulWidget {
  @override
  _CatScreenState createState() => _CatScreenState();
}

class _CatScreenState extends State<CatScreen>{
  bool? is_cat;

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
              onPressed: () async {
                is_cat = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DogScreen(is_cat: false))
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
                    if (is_cat == null){
                      is_cat=true;
                    }
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
  final bool is_cat;
  DogScreen({required this.is_cat});
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
                Navigator.pop(context, true);
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

//회고
//고명지:Navigator.push와 Navigator.pop을 사용해 화면 전환 구현을 해보아 의미있었음.
// 다만, is_cat 변수에 대한 이해는 좀 더 시간이 필요함.
//ClipRRect를 사용하여 사진의 라운드값을 넣는법을 배웠음. pop에서 데이터를 받는 방법에 대해 이해했다.