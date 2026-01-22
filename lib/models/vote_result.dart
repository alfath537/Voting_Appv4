class VoteResult {
  final String title;
  final int totalVotes;

  VoteResult({required this.title, required this.totalVotes});

  factory VoteResult.fromMap(Map<String, dynamic> map) {
    return VoteResult(
      title: map['title'] ?? '',
      totalVotes: map['totalVotes'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {'title': title, 'totalVotes': totalVotes};
  }
}
