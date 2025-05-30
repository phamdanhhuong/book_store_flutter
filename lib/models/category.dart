class Category {
  final int id;
  final String name;
  final String cover_url;
  Category({required this.id, required this.name, required this.cover_url});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json["id"],
      name: json["name"],
      cover_url: json["cover_url"],
    );
  }
}
