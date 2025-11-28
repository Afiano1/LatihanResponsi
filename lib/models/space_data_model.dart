
class SpaceData {
  final int id;
  final String title;
  final String imageUrl;
  final String summary;
  final String url;
  final String publishedAt;
  final String newsSite;

  SpaceData({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.summary,
    required this.url,
    required this.publishedAt,
    required this.newsSite,
  });


  factory SpaceData.fromJson(Map<String, dynamic> json) {
    return SpaceData(
      id: json['id'],
      title: json['title'] ?? '',
      imageUrl: json['image_url'] ?? '',
      summary: json['summary'] ?? '',
      url: json['url'] ?? '',
      publishedAt: json['published_at'] ?? '',
      newsSite: json['news_site'] ?? '',
    );
  }
}
