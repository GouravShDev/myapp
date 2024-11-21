import 'package:codersgym/features/common/widgets/app_webview.dart';
import 'package:flutter/material.dart';

class LeetcodePlayground extends StatelessWidget {
  const LeetcodePlayground({super.key, required this.playgroundUrl});
  final String playgroundUrl;

  @override
  Widget build(BuildContext context) {
    return AppWebview(
      appBarTitle: Text("Code Solution"),
      url: playgroundUrl,
    );
  }
}
