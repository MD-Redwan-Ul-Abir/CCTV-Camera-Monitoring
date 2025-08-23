import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../languageChanging/appString.dart';

import '../../../../infrastructure/theme/app_colors.dart';
import '../../../../infrastructure/theme/text_styles.dart';

import 'imagePickerController.dart';

void showImagePickerOption(
  BuildContext context,
  imagePickerController controller,
) {
  showModalBottomSheet(
    backgroundColor: Colors.white,
    context: context,
    builder: (_) {
      return Padding(
        padding: const EdgeInsets.all(18.0),
        child: Row(
          children: [
            // Pick from gallery
            Expanded(
              child: GestureDetector(
                onTap: () {
                  controller.pickImage(ImageSource.gallery);
                  Get.back();
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.image,
                      size: 50.w,
                      color: AppColors.primaryDark,
                    ),
                    SizedBox(height: 8.h),
                    // CustomText(
                    //   text: 'Gallery',
                    //   fontWeight: FontWeight.w600,
                    //   color: Colors.black,
                    //   fontSize: 16.sp,
                    // ),
                    Text(AppStrings.galleryOption.tr, style: AppTextStyles.textButton),
                  ],
                ),
              ),
            ),
            // Pick from camera
            Expanded(
              child: GestureDetector(
                onTap: () {
                  controller.pickImage(ImageSource.camera);
                  Get.back();
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.camera_alt,
                      size: 50.w,
                      color: AppColors.primaryDark,
                    ),
                    SizedBox(height: 8.h),
                    // CustomText(
                    //   text: 'Camera',
                    //   fontWeight: FontWeight.w600,
                    //   color: Colors.black,
                    //   fontSize: 16.sp,
                    // ),
                    Text(AppStrings.cameraOption.tr, style: AppTextStyles.textButton),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
