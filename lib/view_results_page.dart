import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/vote_stream.dart';

class ViewResultsPage extends StatefulWidget {
  const ViewResultsPage({super.key});

  @override
  State<ViewResultsPage> createState() => _ViewResultsPageState();
}

class _ViewResultsPageState extends State<ViewResultsPage> {
  final List<Color> barColors = [
    Colors.deepPurple,
    Colors.blue,
    Colors.orange,
    Colors.green,
    Colors.red,
  ];

  @override
  void initState() {
    super.initState();
    VoteStream.refresh(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Voting Results')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder<Map<String, int>>(
          stream: VoteStream.stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No votes yet'));
            }

            final votesMap = snapshot.data!;
            final movies = votesMap.keys.toList();
            final votes = votesMap.values.toList();
            final maxVotes = votes.isEmpty ? 1 : votes.reduce((a, b) => a > b ? a : b);

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: movies.length * 80.0,
                height: 300,
                child: BarChart(
                  BarChartData(
                    maxY: (maxVotes + 1).toDouble(),
                    barGroups: List.generate(movies.length, (i) {
                      return BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            toY: votes[i].toDouble(),
                            width: 30,
                            color: barColors[i % barColors.length],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                        showingTooltipIndicators: [0],
                      );
                    }),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index < movies.length) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  movies[index],
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            }
                            return const Text('');
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            return Text(value.toInt().toString());
                          },
                        ),
                      ),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                        tooltipPadding: const EdgeInsets.all(8),
                        tooltipMargin: 8,
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          final movie = movies[group.x.toInt()];
                          final count = votes[group.x.toInt()];
                          return BarTooltipItem(
                            '$movie\n$count votes',
                            const TextStyle(color: Colors.white),
                          );
                        },
                      ),
                    ),
                    gridData: FlGridData(show: true),
                    borderData: FlBorderData(show: false),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
