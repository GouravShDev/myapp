
import 'package:markdown/markdown.dart';


/// Parse iframe blocks in Markdown.
/// This syntax handles iframe elements with their attributes while maintaining
/// proper parsing and nesting behavior.
class IframeBlockSyntax extends BlockSyntax {
  @override
  RegExp get pattern => RegExp(
    r'^\s*<iframe\b[^>]*>.*?</iframe>|^\s*<iframe\b[^>]*/?>',
    caseSensitive: false,
    multiLine: true,
  );

  // Updated attribute pattern to handle more HTML attribute formats
  // Handles:
  // - Quoted attributes: attr="value" or attr='value'
  // - Unquoted attributes: attr=value
  // - Boolean attributes: disabled
  // - Data attributes: data-*
  // - Attributes with hyphens: allow-scripts
  final _attributePattern = RegExp(
    r'''([a-zA-Z][\w-]*(?:\:[a-zA-Z][\w-]*)?)\s*(?:=\s*(?:["']([^"']*)["']|([^\s"'=<>`]+)))?''',
    multiLine: true,
  );

  // Iframes can interrupt paragraphs since they are block-level elements
  @override
  bool canEndBlock(BlockParser parser) => true;


  @override
  List<Line> parseChildLines(BlockParser parser) {
    final lines = <Line>[];
    var openTags = 0;

    // Handle first line
    final firstLine = parser.current.content;
    openTags += '<iframe'.allMatches(firstLine).length;
    openTags -= '</iframe>'.allMatches(firstLine).length;
    lines.add(parser.current);
    parser.advance();

    // Continue parsing until we find the matching closing tag
    while (!parser.isDone && openTags > 0) {
      final currentLine = parser.current.content;
      openTags += '<iframe'.allMatches(currentLine).length;
      openTags -= '</iframe>'.allMatches(currentLine).length;

      lines.add(parser.current);
      parser.advance();
    }

    // Check if the next line starts another iframe block
    if (!parser.isDone && pattern.hasMatch(parser.current.content)) {
      lines.addAll(parseChildLines(parser));
    }

    return lines;
  }

  Map<String, String> _parseAttributes(String content) {
    final attributes = <String, String>{};
    final matches = _attributePattern.allMatches(content);

    for (final match in matches) {
      final key = match.group(1);
      final value = match.group(2);
      if (key != null && value != null) {
        attributes[key] = value;
      }
    }

    return attributes;
  }

  @override
  Node parse(BlockParser parser) {
    // Get content between tags
    final lines = parseChildLines(parser);
    final content = lines.map((e) => e.content).join('\n').trim();

    // Extract attributes from the opening tag
    final attributes = _parseAttributes(content);

    // Create iframe element
    final iframeElement = Element('iframe', []);
    iframeElement.attributes.addAll(attributes);

    // Extract content between opening and closing tags
    final contentMatch = RegExp(r'<iframe[^>]*>(.*?)</iframe>', dotAll: true)
        .firstMatch(content);
    if (contentMatch != null && contentMatch.group(1)?.isNotEmpty == true) {
      iframeElement.children?.add(Text(contentMatch.group(1)!.trim()));
    }

    // Wrap iframe in a paragraph element
    return Element('p', [iframeElement]);
  }

  /// Validates if the iframe HTML is properly formatted
  bool isValidIframe(String content) {
    final openTags = '<iframe'.allMatches(content).length;
    final closeTags = '</iframe>'.allMatches(content).length;

    return openTags > 0 && (openTags == closeTags || content.contains('/>'));
  }


}
