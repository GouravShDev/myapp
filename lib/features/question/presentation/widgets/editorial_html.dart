import 'package:codersgym/features/question/presentation/widgets/leetcode_playground.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class EditorialHtml extends StatelessWidget {
  const EditorialHtml({super.key, required this.solutionContent});
  final String solutionContent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return HtmlWidget(
      solutionContent,
      renderMode: RenderMode.sliverList,
      enableCaching: true,
      onLoadingBuilder: (context, element, loadingProgress) {
        return const Center(child: CircularProgressIndicator());
      },
      customWidgetBuilder: (element) {
        if (element.className == 'video-container') {
          // Show not supported in mobile app open website button add button
          // top open browser
          return Column(
            children: [
              const Text("Playing video is not available yet in mobile app"),
              ElevatedButton(
                  onPressed: () {}, child: const Text("Open in browser")),
            ],
          );
        }
        if (element.localName == 'iframe') {
          return Column(
            children: [
              Text(
                "Try writing code yourself before seeing the code",
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return LeetcodePlayground(
                          playgroundUrl: element.attributes['src'] ?? '',
                        );
                      },
                    );
                  },
                  icon: const Icon(
                    Icons.open_in_new,
                  ),
                  label: const Text(
                    "Show Code",
                  )),
            ],
          );
        }
        return null;
      },
      textStyle: const TextStyle(fontSize: 14),
    );
  }
}
