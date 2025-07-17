import '../../infrastructure/utils/api_content.dart';

class ProfileImageHelper {
  /// Returns a complete image URL based on the given [imageUrl].
  /// - Adds dummy prefix if not a full URL.
  /// - Returns empty string if input is null or empty.
  static String formatImageUrl(String? imageUrl) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      if (imageUrl.startsWith('http')) {
        return imageUrl;
      } else {
        return "${ApiConstants.dummyImageUrl}$imageUrl";
      }
    } else {
      print("No profile image URL available");
      return "";
    }
  }
}
