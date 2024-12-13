import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:collection/collection.dart';

class LeetcodeRatingChart extends HookWidget {
  final List<DataPoint> dataPoints;
  final bool showAnimation;
  final bool showLeftTile;
  final bool showMaxRating;

  const LeetcodeRatingChart({
    super.key,
    required this.dataPoints,
    this.showAnimation = true,
    this.showLeftTile = true,
    this.showMaxRating = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const defaultRating = 1400;
    final averageY = dataPoints.isEmpty
        ? defaultRating.toDouble()
        : dataPoints.map((e) => e.y).average;
    final averageDataPoint = dataPoints.map(
      (e) => e.toFlSpot().copyWith(
            y: averageY,
          ),
    );
    final animationShown = useState(!showAnimation);
    final touchingGraph = useState(false);
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        animationShown.value = true;
      });

      return;
    }, []);
    final maxContestRating = dataPoints.asMap().entries.reduce(
          (value, element) => value.value.y > element.value.y ? value : element,
        );
    int maxIndex = maxContestRating.key;
    DataPoint maxPoint = maxContestRating.value;

    return AspectRatio(
      aspectRatio: 1.80,
      child: Padding(
        padding: const EdgeInsets.only(
          right: 18,
          left: 12,
          top: 24,
          bottom: 12,
        ),
        child: LineChart(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInSine,
          LineChartData(
            gridData: const FlGridData(
              show: false,
            ),
            showingTooltipIndicators: animationShown.value
                ? [
                    ShowingTooltipIndicators([
                      if (showMaxRating)
                        LineBarSpot(
                          LineChartBarData(
                            spots: dataPoints.map((e) => e.toFlSpot()).toList(),
                            isCurved: false,
                            color: Theme.of(context).primaryColor,
                            barWidth: 3,
                            isStrokeCapRound: true,
                            dotData: const FlDotData(
                              show: true,
                            ),
                            curveSmoothness: 0.5,
                            preventCurveOverShooting: true,
                          ),
                          maxIndex,
                          maxPoint.toFlSpot(),
                        ),
                    ])
                  ]
                : [],
            titlesData: FlTitlesData(
              show: true,
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: const AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: showLeftTile,
                  interval: calculateInterval(dataPoints),
                  getTitlesWidget: leftTitleWidgets,
                  maxIncluded: false,
                  minIncluded: true,
                  reservedSize: 42,
                ),
              ),
            ),
            borderData: FlBorderData(
              show: false,
            ),
            minY: dataPoints.isNotEmpty
                ? dataPoints
                    .reduce((value, element) =>
                        value.y < element.y ? value : element)
                    .y
                : null,
            maxY: dataPoints.isNotEmpty
                ? dataPoints
                    .reduce((value, element) =>
                        value.y > element.y ? value : element)
                    .y
                : null,
            lineBarsData: [
              LineChartBarData(
                spots: animationShown.value
                    ? dataPoints
                        .map(
                          (e) => e.toFlSpot(),
                        )
                        .toList()
                    : averageDataPoint.toList(),
                isCurved: true,
                color: Theme.of(context).primaryColor,
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: const FlDotData(
                  show: false,
                ),
                curveSmoothness: 0.5,
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [theme.primaryColor, Colors.transparent]
                        .map((color) => color.withOpacity(0.3))
                        .toList(),
                  ),
                ),
              ),
            ],
            lineTouchData: LineTouchData(
              enabled: touchingGraph.value,
              touchCallback: (touchEvent, response) {
                if (touchEvent is FlTapUpEvent || touchEvent is FlPanEndEvent) {
                  touchingGraph.value = false;
                } else if (touchEvent is FlTapDownEvent ||
                    touchEvent is FlPanStartEvent) {
                  touchingGraph.value = true;
                }
              },
              handleBuiltInTouches: true,
              touchTooltipData: LineTouchTooltipData(
                fitInsideHorizontally: true,
                getTooltipColor: (touchedSpot) {
                  return theme.primaryColorDark;
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    return Text(
      value.toInt().toString(),
      style: style,
    );
  }

  calculateInterval(List<DataPoint> dataPoints, {int maxTicks = 4}) {
    if (dataPoints.isEmpty || maxTicks <= 0) {
      throw ArgumentError(
          "Data points cannot be empty, and maxTicks must be positive.");
    }

    // Find the minimum and maximum y-values
    double minY = dataPoints.map((point) => point.y).reduce(min);
    double maxY = dataPoints.map((point) => point.y).reduce(max);

    // Calculate the range
    double range = maxY - minY;
    // Handle the case where minY and maxY are the same
    if (range == 0) {
      return minY == 0 ? 1 : minY / maxTicks;
    }

    // Determine a raw interval based on the desired number of ticks
    double rawInterval = range / maxTicks;

    // Calculate a "nice" rounded interval
    double magnitude =
        pow(10, (log(rawInterval) / ln10).floorToDouble()).toDouble();
    double niceInterval = (rawInterval / magnitude).round() * magnitude;
    return niceInterval;
  }
}

class DataPoint {
  final double x;
  final double y;

  const DataPoint(this.x, this.y);
}

extension DataPointExt on DataPoint {
  FlSpot toFlSpot() => FlSpot(x, y);
}
