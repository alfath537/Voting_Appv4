import 'package:flutter/material.dart';
import '../widgets/movie_card.dart';
import 'movie_detail_page.dart';
import 'view_results_page.dart';
import 'feedback_page.dart';

class MovieVotePage extends StatelessWidget {
  const MovieVotePage({super.key});

  @override
  Widget build(BuildContext context) {
    final movies = [
      {'title': 'Mean Girls', 'image': 'assets/images/mean_girls.jpg'},
      {'title': 'Dune: Part Two', 'image': 'assets/images/dune.jpg'},
      {'title': 'Inside Out 2', 'image': 'assets/images/inside_out2.jpg'},
      {'title': 'IF', 'image': 'assets/images/IF.jpg'},
      {'title': 'Marmalade', 'image': 'assets/images/marmalade.jpg'},
      {'title': 'Argyle', 'image': 'assets/images/argyle.jpg'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Best Movie 2023'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ViewResultsPage()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.feedback),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FeedbackPage()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Vote for your favorite movie.',
              style: TextStyle(fontSize: 16),
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(8),
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              children: movies.map((movie) {
                return MovieCard(
                  title: movie['title']!,
                  imagePath: movie['image']!,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MovieDetailPage(
                        title: movie['title']!,
                        imagePath: movie['image']!,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
