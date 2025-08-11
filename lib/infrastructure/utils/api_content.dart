class ApiConstants {
  ApiConstants._();
  ///----------------sucure storage constent--------------------

  // static const String signInToken = 'sign-in-token';
  // static const String signUpToken = 'sign-up-token';
  // static const String forgetPassToken = 'forget-pass-token';
  // static const String userId = 'user-id';
  // static const String userName = 'user-name';
  // static const String userEmail = 'user-email';
  // static const String userImage = 'user-image';

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

  static String baseUrl = "https://sheakh6733.sobhoy.com/api/v1";
  static String imageBaseUrl = "https://sheakh6733.sobhoy.com" ;
  static String dummyImageUrl = "https://sheakh6733.sobhoy.com";
  static String socketUrl = "https://sheakh6733.sobhoy.com";

  ///-------------------------------------Auth------------------------------------

  static String logInUrl = 'auth/login';
  static String verifyEmail = 'auth/verify-email';
  static String changPassUrl = 'auth/change-password';
  static String forgetPassUrl = 'auth/forgot-password';
  static String resetPassUrl = 'auth/reset-password';

  ///------------------------------------Customer---------------------------------

  static String getUserInfo = '/user/get-profile-info';
  static String getAllSiteByPersonID({String? personID,String? role, int? limit}) =>  '/user-site/paginate?personId=$personID&role=$role&limit=$limit';
  static String getASiteBySiteID({String? siteID,String? role}) =>  '/user-site/paginate/for-customer/siteId?siteId=$siteID&role=$role';
  static String getAllCameraWhichHaveUserAccess({String? siteID,String? personId}) =>  '/camera-person/live-view/?siteId=$siteID&personId=$personId';
  static String getCameraByCameraID({String? id,String? limit}) =>  '/camera/paginate?_id=$id&limit=$limit';


  ///-----------------------------------Report & Camera-----------------------------------------


  static String createReport = 'report/create';
  static String getAllTodaysReport({String? createdAt,String? role,String? personID, int? limit}) =>  '/customer-report/paginate/customer?createdAt=$createdAt&personId=$personID&role=$role&limit=$limit';
  static String getAReportByReportID({String? reportID,}) =>  '/report/$reportID';
  static String getReportsBySelection({String? reportType,String? personID,int? limit,int? page}) =>  '/customer-report/paginate?reportType=$reportType&personId=$personID&page=$page&limit=$limit';
  static String getCameraBySiteIdandPersonId({String? siteId,String? personId}) =>  '/camera-person/live-view/?siteId=$siteId&personId=$personId';


  ///-------------------------------Profile info Get------------------------------------

  static String getPrivacyData = '/settings/all';
  static String postReviewAndRatings = '/review/create';
  static String updateUserProfile = '/user/profile';
  static String updateProfilePicture = '/user/profile-image';

///-------------------------------Send image in the message section------------------------------------

  static String sendImageInMessage = 'message/create';


  ///----------------------------------Add Conversation List-------------------------------------------


  static String getAddConversations({String? personID,String? role, }) =>  '/user-site/conversation/person/paginate/?personId=$personID&role=$role';

}
