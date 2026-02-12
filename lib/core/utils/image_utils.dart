/// Helper utility for image processing
class ImageUtils {
  /// Converts low-resolution image URLs (especially from iTunes/RSS) to high-resolution versions.
  static String getHighResUrl(String? url) {
    if (url == null || url.isEmpty) return '';

    // Handle iTunes/Apple Podcast images (mzstatic.com)
    // Example: https://is1-ssl.mzstatic.com/image/.../100x100bb.jpg
    // We replace the dimension part with 1024x1024bb for max quality
    if (url.contains('mzstatic.com') || url.contains('apple.com')) {
      return url.replaceAll(RegExp(r'\d+x\d+bb'), '1024x1024bb');
    }

    return url;
  }
}
