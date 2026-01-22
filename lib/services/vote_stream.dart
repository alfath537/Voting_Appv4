import 'dart:async';

class VoteStream {
  static final _controller = StreamController<Map<String, int>>.broadcast();
  static Stream<Map<String, int>> get stream => _controller.stream;

  static final Map<String, int> _votes = {};

  static void refresh() {
    _controller.add(Map.from(_votes));
  }

  static void addVote(String movie) {
    if (_votes.containsKey(movie)) {
      _votes[movie] = _votes[movie]! + 1;
    } else {
      _votes[movie] = 1;
    }
    print('Votes now: $_votes');
    _controller.add(Map.from(_votes));
  }
}
