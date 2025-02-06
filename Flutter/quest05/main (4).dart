import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'package:image/image.dart' as img; // Import the image package
import 'package:flutter/services.dart'; // Import rootBundle

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jellyfish Classifier',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? _image;
  Map<String, dynamic>? _outputs;
  bool _loading = false;
  tfl.Interpreter? interpreter; // Interpreter 객체

  @override
  void initState() {
    super.initState();
    loadModel(); // 모델 로드
  }

  Future loadModel() async {
    try {
      final interpreterOptions = tfl.InterpreterOptions();

      interpreter = await tfl.Interpreter.fromAsset(
          'assets/my_model.tflite', // 모델 파일 경로
          options: interpreterOptions);
      interpreter!.allocateTensors();
      print('모델 로드 성공!');
    } catch (e) {
      print('모델 로드 실패: $e');
    }
  }

  Future pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) return;

    setState(() {
      _loading = true;
      _image = File(image.path);
      _outputs = null; // 이미지 선택 시 이전 결과 초기화
    });
    classifyImage(_image!);
  }

  Future classifyImage(File image) async {
    // 이미지 전처리
    img.Image? imageInput = img.decodeImage(image.readAsBytesSync());
    if (imageInput == null) {
      setState(() {
        _outputs = {"error": "Failed to decode image"};
        _loading = false;
      });
      return;
    }

    img.Image resizedImage = img.copyResize(imageInput, width: 224, height: 224);
    // 입력 이미지 데이터를 모델에 맞는 형태로 변환
    var input = convertImagetoArray(resizedImage, 224, 224);

    // 입력 텐서 설정
    var inputTensor = interpreter!.getInputTensor(0);
    var inputShape = inputTensor.shape;
    var outputTensor = interpreter!.getOutputTensor(0);
    var outputShape = outputTensor.shape;

    // 입력 데이터 타입 확인 및 변환
    var inputType = inputTensor.type;

    // 입력 데이터 설정 (예: Float32)
    var inputData = input;  // 적절한 형태의 입력 데이터로 대체

    // 출력 데이터
    var outputData = List<double>.filled(1000, 0).reshape([1, 1000]);  // appropriate shape

    // 모델 실행
    interpreter!.run(inputData, outputData);

    // 결과 처리
    var maxScore = outputData[0].reduce((a, b) => a > b ? a : b);  // Find max score
    var index = outputData[0].indexOf(maxScore);
    print("결과: $index, score: $maxScore");

    // 결과를 UI에 표시
    setState(() {
      _loading = false;
      _outputs = {"predicted_label": index.toString(), "prediction_score": maxScore.toString()};
    });
  }


  List<List<List<double>>> convertImagetoArray(img.Image image, int inputSize, int outputSize) {
    List<List<List<double>>> pixelData = List.generate(
      inputSize,
          (i) => List.generate(outputSize, (j) {
        final pixel = image.getPixelSafe(j, i); // getPixelSafe 사용
        return [pixel.r.toDouble(), pixel.g.toDouble(), pixel.b.toDouble()]; // r, g, b 속성 사용
      }),
    );
    return pixelData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jellyfish Classifier'),
      ),
      body: _loading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // 이미지 표시
            Container(
              width: 300,
              height: 300,
              child: Image.asset(
                'assets/images/your_image.jpg', // 이미지 경로
                fit: BoxFit.cover, // 이미지 크기 조정 방식
              ),
            ),
            SizedBox(height: 20),
            // 버튼 생성
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Prediction"),
                          content: Text(_outputs == null || _outputs!['predicted_label'] == null
                              ? "No prediction available"
                              : "Predicted Label: ${_outputs!['predicted_label']}"),
                          actions: [
                            TextButton(
                              child: Text("Close"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text('Prediction'),
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Prediction Score"),
                          content: Text(_outputs == null || _outputs!['prediction_score'] == null
                              ? "No score available"
                              : "Prediction Score: ${_outputs!['prediction_score']}"),
                          actions: [
                            TextButton(
                              child: Text("Close"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text('Score'),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: pickImage,
              child: Text('이미지 선택'),
            ),
            if (_outputs != null && _outputs!['error'] != null)
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  'Error: ${_outputs!['error']}',
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}