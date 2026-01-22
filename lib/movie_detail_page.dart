import 'package:flutter/material.dart';
import '../services/prefs_helper.dart';
import '../services/vote_service.dart';
import 'thank_you_page.dart';
import 'share_movie_page.dart';
import 'add_feedback_page.dart';
import 'view_results_page.dart';

class MovieDetailPage extends StatefulWidget {
  final String title;
  final String imagePath;

  const MovieDetailPage({
    super.key,
    required this.title,
    required this.imagePath,
  });

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  bool _isVoting = false;
  bool _hasVoted = false;

  @override
  void initState() {
    super.initState();
    _loadVoteStatus();
  }

  Future<void> _loadVoteStatus() async {
    _hasVoted = await PrefsHelper.hasVoted(widget.title);
    setState(() {});
  }

  Future<void> _vote() async {
    if (_hasVoted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You already voted for this movie')),
      );
      return;
    }

    setState(() => _isVoting = true);

    final success = await VoteService.submitVote(widget.title);

    if (success) {
      await PrefsHelper.setVoted(widget.title);
      setState(() => _hasVoted = true);

      // redirect ke hasil voting realtime
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ViewResultsPage()),
      );
    }

    setState(() => _isVoting = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(widget.imagePath, height: 250, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: _isVoting ? null : _vote,
                        child: Text(_hasVoted ? 'Voted' : 'Vote'),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  AddFeedbackPage(movieTitle: widget.title),
                            ),
                          );
                        },
                        child: const Text('Give Feedback'),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ShareMoviePage(),
                            ),
                          );
                        },
                        child: const Text('Share'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
