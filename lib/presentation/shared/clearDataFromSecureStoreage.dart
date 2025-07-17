
import '../../infrastructure/utils/secure_storage_helper.dart';

class clearData{
  Future<void> clearStoredUserData() async {
    try {
      final keysToDelete = [
        "id", "userCustomId", "email", "name", "canMessage", "role", "address",
        "fcmToken", "profileImageUrl", "profileImageId", "status", "subscriptionType",
        "isEmailVerified", "isDeleted", "isResetPassword", "isGoogleVerified",
        "isAppleVerified", "authProvider", "failedLoginAttempts", "stripeCustomerId",
        "conversationRestrictWith", "createdAt", "updatedAt", "accessToken", "refreshToken"
      ];

      for (String key in keysToDelete) {
        await SecureStorageHelper.remove(key);
      }

      print("All stored user data cleared successfully");
    } catch (e) {
      print("Error clearing stored user data: $e");
    }
  }
}