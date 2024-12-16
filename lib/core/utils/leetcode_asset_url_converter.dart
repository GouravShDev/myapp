class LeetcodeAssetUrlConverter {
  LeetcodeAssetUrlConverter._();
  static String convertRelativeUrlToAbsoluteUrl(String url) {
    // Check if the icon URL is relative
    if (!Uri.parse(url).isAbsolute) {
      // Prepend the base URL for relative URLs
      return 'https://leetcode.com/$url';
    }
    return url;
  }
}
