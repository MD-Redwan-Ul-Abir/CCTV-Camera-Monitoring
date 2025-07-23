import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:skt_sikring/presentation/shared/widgets/buttons/primary_buttons.dart';
import 'package:skt_sikring/presentation/shared/widgets/custom_text_form_field.dart';

import '../../infrastructure/theme/app_colors.dart';
import '../../infrastructure/theme/text_styles.dart';
import '../../infrastructure/utils/app_images.dart';
import '../shared/widgets/customDropDown.dart';
import '../shared/widgets/imagePicker/custom_image_picker.dart';
import '../shared/widgets/imagePicker/imagePickerController.dart';
import 'controllers/create_report.controller.dart';

class CreateReportScreen extends StatefulWidget {
  const CreateReportScreen({super.key});

  @override
  State<CreateReportScreen> createState() => _CreateReportScreenState();
}

class _CreateReportScreenState extends State<CreateReportScreen> {
  final CreateReportController reportController =
  Get.find<CreateReportController>();


  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final imagePickerController imageController = Get.find<
        imagePickerController>();


    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.secondaryDark,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 70.h,
        title: Text(
          "Create reports",
          style: AppTextStyles.headLine6.copyWith(
            fontWeight: FontWeight.w400,
            height: 1.5,
            color: AppColors.primaryLight,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: SvgPicture.asset(
                  AppImages.backIcon,
                  color: AppColors.primaryLight,
                  height: 24.h,
                  width: 24.w
              ),
              onPressed: () {

                Get.back();

              },
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Report Title with validation
                CustomTextFormField(
                  hintText: "Report Title",
                  controller: reportController.titleController,
                  validator: (value) {
                    if (value == null || value
                        .trim()
                        .isEmpty) {
                      return 'Please enter a report title';
                    }
                    if (value
                        .trim()
                        .length < 5) {
                      return 'Title must be at least 5 characters long';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 16.h),

                // Report Template Dropdown with validation
                Obx(
                      () =>
                      CustomDropDown(
                        hintText: "Report template selection",
                        errorText: "Please select report template",
                        selectedValue: reportController.selectedReportTemplate
                            .value,
                        items: reportController.reportTemplateList,
                        onChanged: reportController.updateReportTemplate,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a report template';
                          }
                          return null;
                        },
                      ),
                ),

                SizedBox(height: 16.h),

                // Incident Severity Dropdown with validation
                Obx(
                      () =>
                      CustomDropDown(
                        hintText: "Incident Severity",
                        errorText: "Please select severity",
                        selectedValue: reportController.selectedSeverity.value,
                        items: reportController.severityList,
                        onChanged: reportController.updateSeverity,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select incident severity';
                          }
                          return null;
                        },
                      ),
                ),

                SizedBox(height: 16.h),

                // Site Name Dropdown with validation
                Obx(
                      () =>
                      CustomDropDown(
                        hintText: "Site Name",
                        errorText: "Please select Site",
                        selectedValue: reportController.selectedSite.value,
                        items: reportController.siteList,
                        onChanged: reportController.updateSite,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a site';
                          }
                          return null;
                        },
                      ),
                ),

                SizedBox(height: 16.h),

                // Description with validation
                CustomTextFormField(
                  hintText: 'Description',
                  keyboardType: 'multiline',
                  controller: reportController.descriptionController,
                  validator: (value) {
                    if (value == null || value
                        .trim()
                        .isEmpty) {
                      return 'Please enter a description';
                    }
                    if (value
                        .trim()
                        .length < 10) {
                      return 'Description must be at least 10 characters long';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 16.h),

                // Photos/Document section (no validation needed as it's optional)
                Container(
                  width: double.infinity,
                  height: 219.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.r),
                    color: AppColors.grayDarker,
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 14.h,
                      left: 16.w,
                      right: 16.w,
                      bottom: 21.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Photos/Document',
                          style: AppTextStyles.button.copyWith(
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                        SizedBox(height: 9.h),
                        Obx(() =>
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(3, (index) {
                                bool hasImage = index <
                                    imageController.selectedImages.length;

                                return GestureDetector(
                                  onTap: () {
                                    if (hasImage) {
                                      _showImageOptions(
                                          context, imageController, index);
                                    } else {
                                      showImagePickerOption(
                                          context, imageController);
                                    }
                                  },
                                  child: hasImage
                                      ? Stack(
                                    children: [
                                      Container(
                                        height: 90.h,
                                        width: 90.w,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              4.r),
                                          border: Border.all(
                                            color: AppColors
                                                .secondaryLightHover,
                                            width: 1.w,
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              4.r),
                                          child: Image.file(
                                            imageController
                                                .selectedImages[index],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 2,
                                        right: 2,
                                        child: GestureDetector(
                                          onTap: () {
                                            imageController.removeImage(index);
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                      : DottedBorder(
                                    options: RectDottedBorderOptions(
                                      color: AppColors.secondaryLightHover,
                                      dashPattern: [2, 2],
                                      strokeWidth: 1.w,
                                    ),
                                    child: SizedBox(
                                      height: 90.h,
                                      width: 90.w,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment
                                            .center,
                                        crossAxisAlignment: CrossAxisAlignment
                                            .center,
                                        children: [
                                          SvgPicture.asset(AppImages.camera2),
                                          SizedBox(height: 4.h),
                                          Text(
                                            'Add Photo',
                                            style: AppTextStyles.caption2,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            )),
                        SizedBox(height: 27.h),
                        Obx(() =>
                            GestureDetector(
                              onTap: () {
                                if (imageController.selectedVideo.value !=
                                    null) {
                                  _showVideoOptions(context, imageController);
                                } else {
                                  imageController.pickVideoFromGallery();
                                }
                              },
                              child: Container(
                                height: 32.h,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4.r),
                                  color: Colors.transparent,
                                  border: Border.all(
                                    color: AppColors.secondaryLightHover,
                                    width: 1.r,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (imageController.selectedVideo.value ==
                                        null) ...[
                                      SvgPicture.asset(AppImages.upload),
                                      SizedBox(width: 8.w),
                                      Text(
                                        'Upload Video',
                                        style: AppTextStyles.button.copyWith(
                                          color: Color(0xFFFFFFFF),
                                        ),
                                      ),
                                    ] else
                                      ...[
                                        Icon(
                                          Icons.videocam,
                                          color: AppColors.primaryLight,
                                          size: 20.w,
                                        ),
                                        SizedBox(width: 8.w),
                                        Expanded(
                                          child: Text(
                                            imageController.videoName.value,
                                            style: AppTextStyles.button
                                                .copyWith(
                                              color: Color(0xFFFFFFFF),
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            imageController.clearVideo();
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(4),
                                            child: Icon(
                                              Icons.close,
                                              color: Colors.red,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                  ],
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 24.h),

                // Submit Button with form validation
                Obx(() {
                  if(reportController.isLoading.value==true){
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryLight,
                      ),
                    );
                  }
                  return PrimaryButton(
                    width: double.infinity,
                    onPressed: () {
                      // reportController.submitForm(context, _formKey, reportController, reportController.titleController, reportController.descriptionController);

                      if (_formKey.currentState!.validate()) {
                        reportController.createReport();
                      }
                    },
                    text: 'Submit Report',
                  );
                }),

                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Form submission method with validation
  // void _submitForm(
  //     BuildContext context,
  //     GlobalKey<FormState> formKey,
  //     CreateReportController reportController,
  //     TextEditingController titleController,
  //     TextEditingController descriptionController,
  //     ) {
  //   if (formKey.currentState!.validate()) {
  //     // All validations passed
  //     final formData = {
  //       'title': titleController.text.trim(),
  //       'description': descriptionController.text.trim(),
  //       'reportTemplate': reportController.selectedReportTemplate.value,
  //       'severity': reportController.selectedSeverity.value,
  //       'site': reportController.selectedSite.value,
  //     };
  //
  //     // Process the form data
  //     print('Form is valid! Data: $formData');
  //
  //     // Show success message
  //     // ScaffoldMessenger.of(context).showSnackBar(
  //     //   SnackBar(
  //     //     content: Text('Report submitted successfully!'),
  //     //     backgroundColor: Colors.green,
  //     //   ),
  //     // );
  //   } else {
  //     // Form has validation errors
  //     // ScaffoldMessenger.of(context).showSnackBar(
  //     //   SnackBar(
  //     //     content: Text('Please fix the errors in the form'),
  //     //     backgroundColor: Colors.red,
  //     //   ),
  //     // );
  //   }
  // }

  // Show options for existing images
  void _showImageOptions(BuildContext context, imagePickerController controller,
      int index) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  // Replace image
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.back();
                        showImagePickerOption(context, controller);
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.edit,
                            size: 50.w,
                            color: AppColors.primaryDark,
                          ),
                          SizedBox(height: 8.h),
                          Text("Replace", style: AppTextStyles.textButton),
                        ],
                      ),
                    ),
                  ),
                  // Remove image
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        controller.removeImage(index);
                        Get.back();
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.delete,
                            size: 50.w,
                            color: Colors.red,
                          ),
                          SizedBox(height: 8.h),
                          Text("Remove", style: AppTextStyles.textButton
                              .copyWith(color: Colors.red)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // Show options for existing video
  void _showVideoOptions(BuildContext context,
      imagePickerController controller) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  // Replace video
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.back();
                        controller.pickVideoFromGallery();
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.edit,
                            size: 50.w,
                            color: AppColors.primaryDark,
                          ),
                          SizedBox(height: 8.h),
                          Text("Replace", style: AppTextStyles.textButton),
                        ],
                      ),
                    ),
                  ),
                  // Remove video
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        controller.clearVideo();
                        Get.back();
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.delete,
                            size: 50.w,
                            color: Colors.red,
                          ),
                          SizedBox(height: 8.h),
                          Text("Remove", style: AppTextStyles.textButton
                              .copyWith(color: Colors.red)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}