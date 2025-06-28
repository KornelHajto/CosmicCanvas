class ApodData {
  final String title;
  final String date;
  final String explanation;
  final String url;
  final String? hdUrl;
  final String? copyright;
  final String? mediaType;


  ApodData({
    required this.title,
    required this.date,
    required this.explanation,
    required this.url,
    this.hdUrl,
    this.copyright,
    this.mediaType,
  });

  factory ApodData.fromJson(Map<String, dynamic> json) {
    return ApodData(
      title: json['title'] ?? 'No Title',
      date: json['date'] ?? 'No Date',
      explanation: json['explanation'] ?? 'No Explanation',
      url: json['url'] ?? 'No URL',
      hdUrl: json['hdurl'],
      copyright: json['copyright'],
      mediaType: json['media_type']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'date': date,
      'explanation': explanation,
      'url': url,
      'hdurl': hdUrl,
      'copyright': copyright,
      'media_type': mediaType,
    };
  }
}