class ApiConstants {
  ///----------------sucure storage constent--------------------

  static const String signInToken = 'sign-in-token';
  static const String signUpToken = 'sign-up-token';
  static const String forgetPassToken = 'forget-pass-token';
  static const String userId = 'user-id';
  static const String userName = 'user-name';
  static const String userEmail = 'user-email';
  static const String userImage = 'user-image';

  static const token = 'token';
  static const company = 'company';
  static const tempId = 'tempId';
  //static const userId = 'userId';
  static const resetPasswordToken = 'resetPasswordToken';
  static String APP_NAME = "Golf Game";
  static String bearerToken = "bearerToken";
  //static String userID="userID";

  // share preference Key
  static String THEME = "theme";

  static const String LANGUAGE_CODE = 'language_code';
  static const String COUNTRY_CODE = 'country_code';

  static RegExp emailValidator = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );

  static RegExp passwordValidator = RegExp(
    r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$",
  );

  ////----------------------Network URL for app---------------------------

  static String baseUrl = "https://sheakh6731.sobhoy.com/api/v1";
  static String imageBaseUrl = "https://radwan2000.sobhoy.com";

  ///-------------------------------------Auth------------------------------------

  static String logInUrl = '$baseUrl/auth/login';
  static String verifyEmail = '$baseUrl/auth/verify-email';
  static String changPassUrl = '$baseUrl/auth/change-password';
  static String forgetPassUrl = '$baseUrl/auth/forgot-password';
  static String resetPassUrl = '$baseUrl/auth/reset-password';
}
