import 'dart:async'; // 비동기 작업 및 Timer를 사용하기 위해 import
import 'package:flutter/material.dart'; // Flutter의 UI 컴포넌트를 사용하기 위해 import

void main() {
  runApp(const MyApp()); // Flutter 앱 실행의 시작점
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // 디버그 배너 숨김
      home: const PomodoroTimer(), // 홈 화면으로 PomodoroTimer 위젯 설정
    );
  }
}

class PomodoroTimer extends StatefulWidget {
  const PomodoroTimer({super.key});

  @override
  State<PomodoroTimer> createState() => _PomodoroTimerState(); // State 클래스 생성
}

class _PomodoroTimerState extends State<PomodoroTimer> {
  // 초기값 설정
  int workTime = 25; // 작업 시간 (분)
  int shortBreakTime = 5; // 짧은 휴식 시간 (분)
  int longBreakTime = 15; // 긴 휴식 시간 (분)
  int cycle = 0; // 현재 단계 인덱스 (몇 번째 작업인지)
  int remainingTime = 25 * 60; // 현재 단계의 남은 시간 (초 단위)
  bool isRunning = false; // 타이머가 실행 중인지 확인
  Timer? timer; // Timer 객체 (주기적인 동작을 위한 객체)

  // Pomodoro 타이머의 전체 사이클 정의
  final List<Map<String, dynamic>> cycles = [
    {'label': 'Cycle 1: Work', 'duration': 25 * 60}, // 1회차 작업
    {'label': 'Cycle 1: Short Break', 'duration': 5 * 60}, // 1회차 짧은 휴식
    {'label': 'Cycle 2: Work', 'duration': 25 * 60}, // 2회차 작업
    {'label': 'Cycle 2: Short Break', 'duration': 5 * 60}, // 2회차 짧은 휴식
    {'label': 'Cycle 3: Work', 'duration': 25 * 60}, // 3회차 작업
    {'label': 'Cycle 3: Short Break', 'duration': 5 * 60}, // 3회차 짧은 휴식
    {'label': 'Cycle 4: Work', 'duration': 25 * 60}, // 4회차 작업
    {'label': 'Cycle 4: Last 15 min Break', 'duration': 15 * 60}, // 4회차 긴 휴식
  ];

  // 타이머 시작
  void startTimer() {
    if (isRunning) return; // 이미 실행 중이면 중복 실행 방지
    setState(() {
      isRunning = true; // 타이머 실행 상태로 변경
      remainingTime = cycles[cycle]['duration']; // 현재 사이클의 남은 시간 초기화
    });

    // Timer.periodic: 1초마다 실행
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        remainingTime--; // 남은 시간 1초 감소

        if (remainingTime <= 0) {
          cycle++; // 다음 단계로 이동
          if (cycle >= cycles.length) {
            // 모든 사이클 완료 시 초기화
            timer.cancel();
            isRunning = false;
            cycle = 0; // 사이클을 처음으로 초기화
            return;
          }
          remainingTime = cycles[cycle]['duration']; // 다음 단계의 남은 시간 설정
        }
      });
    });
  }

  // 타이머 초기화
  void resetTimer() {
    timer?.cancel(); // 타이머 멈춤
    setState(() {
      isRunning = false; // 실행 상태 초기화
      cycle = 0; // 첫 번째 사이클로 초기화
      remainingTime = cycles[cycle]['duration']; // 남은 시간 초기화
    });
  }

  // 초 단위를 "분:초" 형식으로 변환
  String formatTime(int seconds) {
    final minutes = seconds ~/ 60; // 분 계산
    final remainingSeconds = seconds % 60; // 초 계산
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    timer?.cancel(); // 위젯 종료 시 타이머 정리
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '포모도로 타이머', // 앱의 제목
          style: TextStyle(
            fontWeight: FontWeight.bold, // 글씨를 볼드체로 설정
          ),
        ),
        centerTitle: true, // 타이틀 가운데 정렬
        backgroundColor: Colors.black, // 앱바 배경색을 검정색으로 설정
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 수직으로 공간 균등 배치
        children: [
          // 현재 상태 및 남은 시간 표시
          Column(
            children: [
              Text(
                cycles[cycle]['label'], // 현재 단계 라벨 표시
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                formatTime(remainingTime), // 남은 시간 표시
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
            ],
          ),

          // 전체 사이클을 리스트로 표시
          Expanded(
            child: ListView.builder(
              itemCount: cycles.length, // 사이클 개수만큼 생성
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(
                    cycles[index]['label'].contains('Work') ? Icons.work : Icons.coffee, // 작업과 휴식에 따라 아이콘 변경
                    color: index == cycle
                        ? (cycles[index]['label'].contains('Work') ? Colors.red : Colors.green)
                        : Colors.grey, // 현재 단계 강조 색상
                  ),
                  title: Text(
                    cycles[index]['label'], // 단계 이름
                    style: TextStyle(
                      fontSize: 18,
                      color: index == cycle ? Colors.black : Colors.grey, // 현재 단계 강조
                      fontWeight: index == cycle ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  trailing: index == cycle
                      ? const Icon(Icons.arrow_forward, color: Colors.blue) // 현재 단계 화살표 아이콘 추가
                      : null,
                );
              },
            ),
          ),

          // 타이머 컨트롤 버튼
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 버튼 균등 배치
            children: [
              ElevatedButton(
                onPressed: startTimer, // 타이머 시작
                child: const Text('Start'),
              ),
              ElevatedButton(
                onPressed: resetTimer, // 타이머 초기화
                child: const Text('Reset'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}