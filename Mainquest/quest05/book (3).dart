// book.dart
class Book {
  final String title;
  final String author;
  final String? publisher; // publisher 속성 추가 (nullable)

  Book({required this.title, required this.author, this.publisher});

  @override
  String toString() {
    return 'Book{title: $title, author: $author, publisher: ${publisher ?? 'N/A'}}';
  }
}

List<Book> parseBooksFromXml(String xmlString) {
  List<Book> books = [];
  try {
    // XML 파싱 로직 (예시)
    final start = xmlString.indexOf('<books>');
    final end = xmlString.indexOf('</books>');
    if (start == -1 || end == -1) {
      print('Error: <books> tag not found in XML data.');
      return books;
    }

    final xmlContent = xmlString.substring(start + 7, end); // Remove <books> tags

    final bookTags = xmlContent.split('</book>');
    for (var bookTag in bookTags) {
      if (bookTag.trim().isEmpty) continue;
      final bookStartIndex = bookTag.indexOf('<book>');

      final trimmedBookTag = bookTag.substring(bookStartIndex + 6);
      final titleStartIndex = trimmedBookTag.indexOf('<title>');
      final titleEndIndex = trimmedBookTag.indexOf('</title>');
      final authorStartIndex = trimmedBookTag.indexOf('<author>');
      final authorEndIndex = trimmedBookTag.indexOf('</author>');
      final publisherStartIndex = trimmedBookTag.indexOf('<publisher>');
      final publisherEndIndex = trimmedBookTag.indexOf('</publisher>');

      if (titleStartIndex != -1 && titleEndIndex != -1 &&
          authorStartIndex != -1 && authorEndIndex != -1) {
        final title = trimmedBookTag.substring(titleStartIndex + 7, titleEndIndex).trim();
        final author = trimmedBookTag.substring(authorStartIndex + 8, authorEndIndex).trim();
        String? publisher;

        if (publisherStartIndex != -1 && publisherEndIndex != -1) {
          publisher = trimmedBookTag.substring(publisherStartIndex + 11, publisherEndIndex).trim();
        } else {
          publisher = null; // publisher 속성이 없는 경우
        }

        books.add(Book(title: title, author: author, publisher: publisher));
      }
    }
  } catch (e) {
    print('Error parsing XML: $e');
  }
  return books;
}