import 'package:codersgym/features/common/widgets/leetcode_markdown/playground_preview_widget.dart';
import 'package:codersgym/features/common/widgets/leetcode_markdown/video_unavailable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:flutter_highlight/themes/night-owl.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

// Custom ElementBuilder for iframes
class IframeElementBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    final iframeContent = element.attributes;
    final src = iframeContent['src'];
    if (src?.contains('leetcode.com/playground') ?? false) {
      return PlaygroundPreviewWidget(playgroundUrl: src!);
    }

    return null;
  }
}

class CodeElementBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    var language = '';

    if (element.attributes['class'] != null) {
      String lg = element.attributes['class'] as String;
      language = lg.substring(9);
    }
    return SizedBox(
      child: HighlightView(
        // The original code to be highlighted
        element.textContent,

        // Specify language
        // It is recommended to give it a value for performance
        language: language,
        theme: monokaiSublimeTheme,
      ),
    );
  }
}

class VideoContainerBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: VideoUnavailableWidget(
        url: element.attributes['src'] ?? '',
      ),
    );
  }
}

class HighLightBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfterWithContext(
    BuildContext context,
    md.Element element,
    TextStyle? preferredStyle,
    TextStyle? parentStyle,
  ) {
    var lang = 'plaintext';
    final pattern = RegExp(r'^language-(.+)$');

    var className = element.attributes['class'];

    if (className != null) {
      var out = pattern.firstMatch(className)?.group(1);

      if (out != null) {
        lang = out;
      }
    }

    return HighlightView(
      element.textContent.trim(),
      language: lang,
      theme: nightOwlTheme,
      padding: EdgeInsets.zero,
    );
  }
}
