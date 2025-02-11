import 'dart:io';

class Review {
  final File image;
  final String text;
  String? sentiment;
  String? category;
  List<String>? authors;

  Review({
    required this.image,
    required this.text,
    this.sentiment,
    this.category,
    this.authors,
  });
}