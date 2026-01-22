class FeedbackModel {
  final String id;
  final String movieTitle;
  final String feedback;
  final double rating;
  final String timestamp;

  FeedbackModel({
    required this.id,
    required this.movieTitle,
    required this.feedback,
    required this.rating,
    required this.timestamp,
  });

  factory FeedbackModel.fromMap(Map<String, dynamic> map) {
    return FeedbackModel(
      id: map['id'],
      movieTitle: map['movieTitle'],
      feedback: map['feedback'],
      rating: (map['rating'] ?? 0).toDouble(),
      timestamp: map['timestamp'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'movieTitle': movieTitle,
      'feedback': feedback,
      'rating': rating,
      'timestamp': timestamp,
    };
  }
}
