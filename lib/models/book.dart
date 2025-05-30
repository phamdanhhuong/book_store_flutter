class Book {
  final int id;
  final String title;
  final String author;
  final String category;
  final String publisher;
  final DateTime publicationDate;
  final String summary;
  final String coverUrl;
  final int price;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.category,
    required this.publisher,
    required this.publicationDate,
    required this.summary,
    required this.coverUrl,
    required this.price,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json["id"],
      title: json["title"],
      author: json["author"],
      category: json["category"],
      publisher: json["publisher"],
      publicationDate: DateTime.parse(json["publication_date"]),
      summary: json["summary"],
      coverUrl: json["cover_url"],
      price: json["price"],
    );
  }
}
