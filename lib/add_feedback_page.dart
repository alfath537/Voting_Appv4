import 'package:flutter/material.dart';
import '../services/vote_db.dart';
import '../models/feedback_model.dart';
import 'package:uuid/uuid.dart';

class AddFeedbackPage extends StatefulWidget {
  final String movieTitle;
  const AddFeedbackPage({super.key, required this.movieTitle});

  @override
  State<AddFeedbackPage> createState() => _AddFeedbackPageState();
}

class _AddFeedbackPageState extends State<AddFeedbackPage> {
  final controller = TextEditingController();
  double rating = 3;

  Future<void> submit() async {
    if (controller.text.isEmpty) return;

    final feedback = FeedbackModel(
      id: const Uuid().v4(),
      movieTitle: widget.movieTitle,
      feedback: controller.text,
      rating: rating,
      timestamp: DateTime.now().toIso8601String(),
    );

    await VoteDB.insertFeedback(feedback);
    controller.clear();
    setState(() => rating = 3);

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Feedback submitted!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Feedback - ${widget.movieTitle}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Movie: ${widget.movieTitle}'),
            Slider(
              value: rating,
              min: 1,
              max: 5,
              divisions: 4,
              label: rating.toString(),
              onChanged: (v) => setState(() => rating = v),
            ),
            TextField(
              controller: controller,
              decoration: const InputDecoration(labelText: 'Your feedback'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: submit, child: const Text('Submit')),
          ],
        ),
      ),
    );
  }
}
