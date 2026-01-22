import 'dart:async';

class DummyAPI {
  static final Map<String, int> _votes = {
    "Mean Girls": 70,
    "Dune: Part Two": 45,
    "Inside Out 2": 50,
    "IF": 12,
    "Marmalade": 7,
    "Argyle": 9,
  };

  static final List<Map<String, dynamic>> _feedbacks = [];

  static Future<Map<String,int>> getVotes() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return Map<String,int>.from(_votes);
  }

  static Future<bool> vote(String title) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (_votes.containsKey(title)) {
      _votes[title] = _votes[title]! + 1;
    } else {
      _votes[title] = 1;
    }
    return true;
  }

  static Future<bool> submitFeedback(String feedback, double rating, {String? userId}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _feedbacks.add({
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'feedback': feedback,
      'rating': rating,
      'userId': userId,
      'timestamp': DateTime.now().toIso8601String(),
    });
    return true;
  }

  static Future<List<Map<String, dynamic>>> getFeedbacks() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List<Map<String,dynamic>>.from(_feedbacks);
  }
}
