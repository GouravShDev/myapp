
import 'package:codersgym/core/error/result.dart';

/// Parser for HTML and Markdown combination content returns in the
/// leetcode api in editorial solution
///
/// It removes some html content like Video player iframe because its
/// don't work in app web view probably due to security reasons
///
/// returns the HTML content suitable for showing in app web view
class HTMLMarkdownParser {
  Result<String, HTMLMarkdownParserFailure> parseAndFormatContent(
    String content,
  ) {
    try {
      // Replace special character '$$' with '*' present in the solutions
      // content. Leetcode wrap content around this charater to provide
      // special styling. Example :  $$O(n)$$ time
      // final filterContent = content.replaceAll('', '*');
      // final htmlContent = markdownToHtml(content);
      return Success(content);
    } catch (e) {
      return Failure(InvalidFormatFailure());
    }
  }
}

sealed class HTMLMarkdownParserFailure implements Exception {}

class InvalidFormatFailure extends HTMLMarkdownParserFailure {}
