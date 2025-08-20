import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:skt_sikring/presentation/shared/widgets/buttons/primary_buttons.dart';
import 'package:skt_sikring/presentation/shared/widgets/custom_text_form_field.dart';

import '../../../infrastructure/theme/app_colors.dart';
import '../../../infrastructure/theme/text_styles.dart';
import '../../../infrastructure/utils/app_images.dart';
import '../../shared/networkImageFormating.dart';
import 'controllers/add_conversations.controller.dart';

class AddConversationsScreen extends StatefulWidget {
  const AddConversationsScreen({super.key});

  @override
  State<AddConversationsScreen> createState() => _AddConversationsScreenState();
}

class _AddConversationsScreenState extends State<AddConversationsScreen> {
  final AddConversationsController addConversationsController =
      Get.find<AddConversationsController>();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    addConversationsController.getAllTakeablePeople();
  }

  @override
  Widget build(BuildContext context) {
    List<Color> cardColors = [
      AppColors.greenLight,
      AppColors.yellowLightActive,
      Color(0xFFC7ECFF), // Light Mint
    ];
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(45.h),
        child: AppBar(
          backgroundColor: AppColors.secondaryDark,
          elevation: 0,
          scrolledUnderElevation: 0,
          automaticallyImplyLeading: false,
          title: Text(
            "Add Contacts",
            style: AppTextStyles.headLine6.copyWith(
              fontWeight: FontWeight.w400,
              height: 1.5,
              fontSize: 16.sp,
              color: AppColors.primaryLight,
            ),
          ),
          leading: Padding(
            padding: EdgeInsets.only(left: 8.0.w),
            child: Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: SvgPicture.asset(
                  AppImages.backIcon,
                  color: AppColors.primaryLight,
                  height: 24.h,
                  width: 24.w,
                ),
                onPressed: () {
                  Get.back();
                },
              ),
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: Obx(() {
        if (addConversationsController.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primaryNormal),
          );
        } else if (addConversationsController.userAttributes.isEmpty) {
          return Center(
            child: Text(
              "There's no one to chat.",
              style: AppTextStyles.headLine6,
            ),
          );
        }
        return ListView.builder(
          itemCount: addConversationsController.userAttributes.length,

          itemBuilder: (context, index) {
            // final color = cardColors[index % cardColors.length];
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
              child: Container(
                height: 60.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(4.r),
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100.r),
                        child: Container(
                          height: 42.w,
                          width: 42.w,

                          decoration: BoxDecoration(
                            color: AppColors.secondaryDarker,
                            borderRadius: BorderRadius.circular(100.r),
                          ),
                          child: Image.network(
                            ProfileImageHelper.formatImageUrl(
                              addConversationsController
                                  .userAttributes[index]
                                  .personId
                                  ?.profileImage
                                  ?.imageUrl,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${addConversationsController.userAttributes[index].personId!.name}",
                          style: AppTextStyles.caption1.copyWith(
                            color: AppColors.secondaryLight,
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          "${addConversationsController.userAttributes[index].personId!.role}",
                          style: AppTextStyles.caption2.copyWith(
                            color: AppColors.secondaryLight,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),

                    GestureDetector(
                      onTap: () {
                        addConversationsController.siteID.value =
                            addConversationsController
                                .userAttributes[index]
                                .siteId!;
                        Get.bottomSheet(
                          SingleChildScrollView(
                            child: Form(
                              key: _formKey,
                              child: Container(
                                padding: EdgeInsets.fromLTRB(24, 12, 24, 24),
                                decoration: BoxDecoration(
                                  color: AppColors.grayLight,
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(24.r),
                                  ),
                                  border: Border(
                                    top: BorderSide(
                                      color: AppColors.primaryNormal,
                                      width: 3.w,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Handle indicator
                                    Container(
                                      width: 50.w,
                                      height: 5.h,
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryNormal,
                                        borderRadius: BorderRadius.circular(
                                          2.5.r,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 24.h),

                                    // User info chip
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryLight,
                                        borderRadius: BorderRadius.circular(
                                          20.r,
                                        ),
                                        border: Border.all(
                                          color: AppColors.primaryNormal
                                              .withOpacity(0.3),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CircleAvatar(
                                            radius: 12.r,
                                            backgroundColor:
                                                AppColors.primaryNormal,
                                            child: Text(
                                              "${addConversationsController.userAttributes[index].personId!.name?[0].toUpperCase()}",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 8.w),
                                          Text(
                                            "${addConversationsController.userAttributes[index].personId!.name}",
                                            style: AppTextStyles.paragraph
                                                .copyWith(
                                                  color: AppColors.primaryDark,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 16.h),

                                    Text(
                                      'Start a new conversation',
                                      style: AppTextStyles.headLine4.copyWith(
                                        color: AppColors.secondaryNormal,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 8.h),

                                    Text(
                                      'Send your first message to begin chatting',
                                      textAlign: TextAlign.center,
                                      style: AppTextStyles.paragraph.copyWith(
                                        color: AppColors.grayDark,
                                      ),
                                    ),
                                    SizedBox(height: 24.h),

                                    CustomTextFormField(
                                      hintText: 'Your message',
                                      controller:
                                          addConversationsController
                                              .sendMessageController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter a message';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: 24.h),

                                    PrimaryButton(
                                      width: double.infinity,
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          Navigator.of(context).pop();
                                          List<String> participants = [
                                            addConversationsController.userAttributes[index].personId!.userId!,
                                          ];
                                          if (addConversationsController.localPersonID !=
                                              null) {
                                            participants.add(
                                              addConversationsController.localPersonID!.value,
                                            );
                                          }
                                          bool result = await addConversationsController.startChat(
                                                    participants: participants,
                                                    siteId: addConversationsController.siteID.value,
                                                  );

                                          if (result == true) {
                                            addConversationsController.sendMessageController.clear();

                                            Future.delayed(
                                              Duration(milliseconds: 300),
                                              () {
                                                addConversationsController.userAttributes.removeAt(index);
                                              },
                                            );
                                          }
                                        }
                                      },
                                      text: 'Send message',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          isScrollControlled: true,
                        );
                      },
                      child: Container(
                        height: 26.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.r),
                          color: AppColors.greenDark,
                        ),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            child: Text(
                              "Start Chat",
                              style: AppTextStyles.caption2.copyWith(
                                color: AppColors.secondaryLight,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
