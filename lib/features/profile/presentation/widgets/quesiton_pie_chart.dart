import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class QuestionCountChart extends StatelessWidget {
  final int easyCount;
  final int mediumCount;
  final int hardCount;

  const QuestionCountChart({
    Key? key,
    required this.easyCount,
    required this.mediumCount,
    required this.hardCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int totalQuestions = easyCount + mediumCount + hardCount;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Questions Solved",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        CircularPercentIndicator(
          radius: 120.0,
          lineWidth: 20.0,
          animation: true,
          percent: totalQuestions == 0 ? 0 : 1.0,
          center: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "$totalQuestions",
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const Text("Total"),
            ],
          ),
          circularStrokeCap: CircularStrokeCap.round,
          backgroundColor: Colors.grey[300]!,
          progressColor: Colors.transparent, // So we can use separate indicators for each level
          footer: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLevelIndicator(context, easyCount, totalQuestions, "Easy", Colors.green),
              _buildLevelIndicator(context, mediumCount, totalQuestions, "Medium", Colors.orange),
              _buildLevelIndicator(context, hardCount, totalQuestions, "Hard", Colors.red),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLevelIndicator(BuildContext context, int count, int total, String label, Color color) {
    return CircularPercentIndicator(
      radius: 60.0,
      lineWidth: 12.0,
      percent: total == 0 ? 0 : count / total,
      center: Text(
        "$count",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
      ),
      progressColor: color,
      backgroundColor: Colors.grey[300]!,
      circularStrokeCap: CircularStrokeCap.round,
      footer: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          label,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
