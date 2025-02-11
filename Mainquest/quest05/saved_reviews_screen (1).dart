import 'package:flutter/material.dart';
import 'review_model.dart';
import 'review_screen.dart';

class SavedReviewsScreen extends StatefulWidget {
  const SavedReviewsScreen({Key? key}) : super(key: key);

  @override
  _SavedReviewsScreenState createState() => _SavedReviewsScreenState();
}

class _SavedReviewsScreenState extends State<SavedReviewsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("저장된 리뷰"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              // review_screen.dart로 이동하여 새 리뷰 작성
              final Review? newReview = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ReviewScreen(title: "REVIEW")),
              ) as Review?;

              // 새 리뷰 추가 후 목록 갱신
              if (newReview != null) {
                setState(() {
                  savedReviews.add(newReview);
                });
              }
            },
          ),
        ],
      ),
      backgroundColor: Colors.transparent,
      body: savedReviews.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.sentiment_dissatisfied, color: Colors.white, size: 50),
            SizedBox(height: 10),
            Text(
              "저장된 리뷰가 없습니다.",
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 5),
            Text(
              "새 리뷰를 작성하려면 오른쪽 상단의 편집 버튼을 누르세요.",
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      )
          : ListView.builder(
        itemCount: savedReviews.length,
        itemBuilder: (context, index) {
          final review = savedReviews[index];
          return Card(
            color: Colors.white.withOpacity(0.1),
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: ListTile(
              leading: Image.file(
                review.image,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              title: Text(review.text, style: const TextStyle(color: Colors.white)),
            ),
          );
        },
      ),
    );
  }
}