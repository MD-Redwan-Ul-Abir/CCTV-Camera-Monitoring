import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:skt_sikring/infrastructure/theme/text_styles.dart';
import 'package:skt_sikring/presentation/messaging/common/socket_controller.dart';
import 'package:skt_sikring/presentation/messaging/message/controllers/message_screen.controller.dart';
import 'package:skt_sikring/presentation/messaging/common/commonController.dart';
import 'package:skt_sikring/presentation/shared/widgets/buttons/primary_buttons.dart';

import '../../infrastructure/navigation/routes.dart';
import '../../infrastructure/theme/app_colors.dart';
import '../../infrastructure/utils/app_images.dart';
import '../../infrastructure/utils/secure_storage_helper.dart';
import '../shared/widgets/customRatings/customRatings.dart';
import '../shared/widgets/custom_text_form_field.dart';
import '../shared/widgets/imagePicker/custom_image_picker.dart';

import 'controllers/profile.controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController profileController = Get.find<ProfileController>();
  final MessageScreenController _messageScreenController = Get.find<MessageScreenController>();
  final SocketController _socketController = Get.find<SocketController>();

  @override
  Widget build(BuildContext context) {
    //final imageController = Get.lazyPut(()=>imagePickerController());

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(45.h),
        // Set the height as per your requirement
        child: AppBar(
          backgroundColor: AppColors.secondaryDark,
          elevation: 0,
          scrolledUnderElevation: 0,
          automaticallyImplyLeading: false,
          title: Text(
            "Profile & Settings",
            style: AppTextStyles.headLine6.copyWith(
              fontWeight: FontWeight.w400,
              height: 1.5,
              color: AppColors.primaryLight,
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 26.h),
              Stack(
                children: [
                  Stack(
                    clipBehavior: Clip.none, // Allow overflow to be visible
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(200.r),
                        child: Container(
                          width: 100.r,
                          height: 100.r,
                          color: AppColors.grayDarker,
                          // Replace this part in your profile.screen.dart:
                          child: Obx(() {
                            if(profileController.isLoading.value){

                              return Center(
                                child: CircularProgressIndicator(color: AppColors.primaryNormal),
                              );

                            }else

                            if (profileController
                                .imageController
                                .selectedImages
                                .isNotEmpty) {
                              profileController.updateProfilePicture();
                              profileController.imageController.removeImage(0);

                              return Image.network(
                                profileController
                                    .homeController
                                    .profileImageUrl
                                    .value,
                                fit: BoxFit.cover,
                              );
                            }
                            // Show network image as default
                            else {
                              return Image.network(
                                profileController
                                    .homeController
                                    .profileImageUrl
                                    .value,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  // Show a placeholder if network image fails
                                  return Container(
                                    color: AppColors.grayDarker,
                                    child: Icon(
                                      Icons.person,
                                      size: 50.r,
                                      color: AppColors.primaryLight,
                                    ),
                                  );
                                },
                              );
                            }
                          }),
                        ),
                      ),
                      Positioned(
                        bottom: -6.h,
                        // Negative value to position it like an overlay
                        right: -10.w,
                        // Negative value to position it like an overlay
                        child: GestureDetector(
                          onTap: () {
                            showImagePickerOption(
                              context,
                              profileController.imageController,
                            );
                            // profileController.selectedImage.value= profileController.imageController.selectedImages.first.path;
                            // LoggerHelper.error(profileController.selectedImage.value);
                          },
                          child: Container(
                            width: 48.r,
                            height: 48.r,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFFF5733),
                              border: Border.all(
                                color: Color(0xFFFFFFFF),
                                width: 4.5.r,
                              ),
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                AppImages.pen,
                                height: 25.h,
                                width: 25.w,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Obx(() {
                return Text(
                  profileController.name.value,
                  style: AppTextStyles.paragraph3,
                );
              }),
              SizedBox(height: 20.h),
              PrimaryButton(
                backgroundColor: AppColors.primaryDarker,
                width: double.infinity,
                onPressed: () {
                  Get.toNamed(
                    Routes.CUSTOM_PRIVACY_POLICY,
                    arguments: {
                      'title': 'Edit Profile',
                      'customWidget': Form(
                        key: profileController.editProfileFormKey,
                        child: Column(
                          children: [
                            SizedBox(height: 6.h),
                            Obx(() {
                              return CustomTextFormField(
                                hintText: profileController.name.value,
                                controller:
                                    profileController.userNameController,
                                prefixSvg: AppImages.profile2,
                              );
                            }),
                            SizedBox(height: 16.h),
                            Obx(() {
                              return CustomTextFormField(
                                hintText: profileController.email.value ?? "",
                                readOnly: true,
                                prefixSvg: AppImages.emailIcon,
                              );
                            }),
                            SizedBox(height: 16.h),
                            Obx(() {
                              return CustomTextFormField(
                                hintText: profileController.address.value,
                                controller: profileController.addressController,
                                prefixSvg: AppImages.locationIcon,
                              );
                            }),
                            SizedBox(height: 22.h),
                            Obx(() {
                              if (profileController.isLoading.value == true) {
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.primaryLight,
                                  ),
                                );
                              }
                              return PrimaryButton(
                                width: double.infinity,

                                onPressed: () async {
                                  await profileController.editProfile();
                                },
                                text: 'Update',
                              );
                            }),
                          ],
                        ),
                      ),
                    },
                  );
                },
                text: "Edit Profile",
              ),
              SizedBox(height: 50.h),
              Container(
                height: 330.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.r),
                  color: AppColors.secondaryDarker,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Account Settings",
                          style: AppTextStyles.paragraph3,
                        ),
                      ),
                      Spacer(),
                      ProfileSettings(
                        text: 'Change Password',
                        leftIcon: AppImages.lock,
                        onTap: () {
                          Get.toNamed(Routes.CHANGE_PASSWORD);
                        },
                      ),
                      Spacer(),
                      ProfileSettings(
                        text: 'Privacy Settings',
                        leftIcon: AppImages.settingsIcon,
                        onTap: () {
                          Get.toNamed(Routes.PRIVACY_SETTINGS);
                        },
                      ),
                      Spacer(),

                      ProfileSettings(
                        text: 'Reviews',
                        leftIcon: AppImages.ratingsIcon,
                        onTap: () {
                          // Reset rating before navigating
                          profileController.rating.value = 0.0;
                          profileController.commentController.clear();

                          Get.toNamed(
                            Routes.CUSTOM_PRIVACY_POLICY,
                            arguments: {
                              'title': 'Reviews',
                              'customWidget': Form(
                                key: profileController.reviewFormKey,
                                child: Column(
                                  children: [
                                    SizedBox(height: 30.h),
                                    SvgPicture.asset(
                                      AppImages.review,
                                      height: 292.h,
                                      width: 292.w,
                                    ),
                                    Text(
                                      'Rating',
                                      style: AppTextStyles.textButton.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 10.h),
                                    Obx(
                                      () => CustomSvgRatingBar(
                                        rating: profileController.rating.value,
                                        fullIconPath:
                                            AppImages.starIconFullFill,
                                        halfIconPath:
                                            AppImages.starIconHalfFill,
                                        emptyIconPath: AppImages.ratingsIcon,
                                        onRatingChanged: (newRating) {
                                          profileController.updateRating(
                                            newRating,
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(height: 30.h),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'Comment (optional)',
                                        style: AppTextStyles.button,
                                      ),
                                    ),
                                    SizedBox(height: 10.h),
                                    CustomTextFormField(
                                      controller:
                                          profileController.commentController,
                                      hintText: 'Write your opinion',
                                      keyboardType: 'multiline',

                                      validator: (value) {
                                        // Since comment is optional, we can return null for validation
                                        // But you can add validation if needed
                                        if (value != null &&
                                            value.trim().length > 500) {
                                          return 'Comment should not exceed 500 characters';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: 25.h),

                                    Obx(() {
                                      if (profileController.isLoading.value ==
                                          true) {
                                        return Center(
                                          child: CircularProgressIndicator(
                                            color: AppColors.primaryLight,
                                          ),
                                        );
                                      }
                                      return PrimaryButton(
                                        width: double.infinity,

                                        onPressed: () async {
                                          await profileController
                                              .submitReview();
                                        },
                                        text: 'Submit',
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            },
                          );
                        },
                      ),

                      Spacer(),
                      ProfileSettings(
                        text: 'Language',
                        leftIcon: AppImages.language,
                        onTap: () {
                          _showLanguageDropdown(context);
                        },
                      ),
                      Spacer(),
                      ProfileSettings(
                        text: 'Log out',
                        leftIcon: AppImages.undo,
                        onTap: () {
                          // implement it here
                          _showDeleteAccountDialog(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguageDropdown(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: AppColors.primaryLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(
                //   'Select Language',
                //   style: AppTextStyles.button.copyWith(
                //     fontWeight: FontWeight.w600,
                //     color: AppColors.secondaryDarker,
                //     fontSize: 16.sp,
                //   ),
                // ),
                // SizedBox(height: 20.h),

                // English Option
                _buildLanguageOption(context, 'English', 'en', () {
                  _selectLanguage('English');
                  Navigator.of(context).pop();
                }, AppImages.English),
                //Divider(color: AppColors.grayDarker, height: 1.h),

                // Spanish Option
                _buildLanguageOption(context, 'Dansk', 'da', () {
                  _selectLanguage('Danish');
                  Navigator.of(context).pop();
                }, AppImages.Danish),
                // Divider(color: AppColors.grayDarker, height: 1.h),

                // French Option
                _buildLanguageOption(context, 'Svenska', 'sv', () {
                  _selectLanguage('Swedish');
                  Navigator.of(context).pop();
                }, AppImages.swedish),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    String language,
    String code,
    VoidCallback onTap,
    String svgPath,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Row(
          children: [
            SvgPicture.asset(svgPath, height: 20.h, width: 20.w),
            SizedBox(width: 12.w),
            Text(
              language,
              style: AppTextStyles.caption1.copyWith(
                color: AppColors.secondaryDarker,
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            Spacer(),
            // You can add a checkmark icon here if you want to show the selected language
            // Icon(Icons.check, color: AppColors.primaryDark, size: 20.r),
          ],
        ),
      ),
    );
  }

  void _selectLanguage(String language) {
    // Handle language selection here
    // You can save the selected language to SharedPreferences or update the app loca le

    Get.snackbar(
      'Language Changed',
      'Language changed to $language',
      backgroundColor: AppColors.primaryDark,
      colorText: Colors.white,
      duration: Duration(seconds: 2),
    );

    // Example: Update app locale (you'll need to implement this based on your localization setup)
    if (language == 'Danish') {
      Get.updateLocale(Locale('da', 'DK'));
    } else if (language == 'Swedish') {
      Get.updateLocale(Locale('sv', 'SE'));
    } else {
      Get.updateLocale(Locale('en', 'US'));
    }
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: AppColors.primaryLight, // Light beige background
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Container(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Text(
                  'Are you sure you want to log out of your account?',
                  style: AppTextStyles.button.copyWith(
                    fontWeight: FontWeight.w400,
                    color: AppColors.secondaryDarker,
                    fontSize: 16.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24.h),

                // Buttons Row
                Row(
                  children: [
                    // Cancel Button
                    Expanded(
                      child: Container(
                        height: 48.h,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.grayDarker,
                            width: 1.5.w,
                          ),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: AppTextStyles.button.copyWith(
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),

                    // Delete Button
                    Expanded(
                      child: SizedBox(
                        height: 48.h,
                        child: ElevatedButton(
                          onPressed: () {
                            // Perform complete socket cleanup first
                            _socketController.performLogoutCleanup();
                            
                            // Clear stored user data
                            clearStoredUserData();

                            // Clear message controller data
                            _messageScreenController.clearUserData();
                            _messageScreenController.commonController.clearCommonValues();

                            Navigator.of(context).pop();
                            _handleDeleteAccount();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.redDark, // Deep red
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Log out',
                            style: AppTextStyles.button.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> clearStoredUserData() async {
    try {
      final keysToDelete = [
        "id",
        "userCustomId",
        "email",
        "name",
        "canMessage",
        "role",
        "address",
        "fcmToken",
        "profileImageUrl",
        "profileImageId",
        "status",
        "subscriptionType",
        "isEmailVerified",
        "isDeleted",
        "isResetPassword",
        "isGoogleVerified",
        "isAppleVerified",
        "authProvider",
        "failedLoginAttempts",
        "stripeCustomerId",
        "conversationRestrictWith",
        "createdAt",
        "updatedAt",
        "accessToken",
        "refreshToken",
      ];

      for (String key in keysToDelete) {
        await SecureStorageHelper.remove(key);
      }

      print("All stored user data cleared successfully");
    } catch (e) {
      print("Error clearing stored user data: $e");
    }
  }

  void _handleDeleteAccount() {
    // Show success message
    Get.snackbar(
      'Logout Successful', 
      'You have successfully logged out from your account.',
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );

    // Navigate back to login or home screen
    Phoenix.rebirth(context);
    Get.offAllNamed(Routes.LOG_IN);
  }
}

class ProfileSettings extends StatelessWidget {
  final String text;
  final String leftIcon;
  final VoidCallback onTap;

  const ProfileSettings({
    super.key,
    required this.text,
    required this.leftIcon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SvgPicture.asset(
                leftIcon,
                height: 17.h,
                width: 17.w,
                color: AppColors.primaryLight,
              ),
              SizedBox(width: 14.w),
              Text(text, style: AppTextStyles.button),
            ],
          ),
          SvgPicture.asset(
            AppImages.forwardIcon,
            height: 24.h,
            width: 24.w,
            //color: AppColors.secondaryTextColor,
          ),
        ],
      ),
    );
  }
}
