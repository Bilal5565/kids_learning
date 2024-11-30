
class Content {
  final String id;
  final String title;
  final String? description;
  final String? imageUrl;
  

  Content({
    required this.id,
    required this.title,
    this.description,
    this.imageUrl,
  });

  factory Content.fromDocument(Map<String, dynamic> data, String id) {
    return Content(
      id: id,
      title: data['title'],
      description: data['description'],
      imageUrl: data['imageUrl'],
    );
  }
}
