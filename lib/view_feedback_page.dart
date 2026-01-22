import 'package:flutter/material.dart';
import '../services/vote_db.dart';
import '../models/feedback_model.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Feedback')),
      body: StreamBuilder<List<FeedbackModel>>(
        stream: VoteDB.feedbackStream(), 
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final feedbacks = snapshot.data!;
          if (feedbacks.isEmpty) {
            return const Center(child: Text('No feedback yet'));
          }

          return ListView.builder(
            itemCount: feedbacks.length,
            itemBuilder: (context, index) {
              final f = feedbacks[index];
              final date = f.timestamp; 
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text(f.movieTitle),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(f.feedback),
                      const SizedBox(height: 4),
                      Text('Rating: ${f.rating} ⭐ • $date'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
