import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../infrastructure/theme/app_colors.dart';
import '../../infrastructure/theme/text_styles.dart';
import '../../infrastructure/utils/app_images.dart';
import 'controllers/conversation_page.controller.dart';

class ConversationPageScreen extends GetView<ConversationPageController> {
  const ConversationPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryDark,
      appBar: AppBar(
        backgroundColor: AppColors.secondaryDark,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.asset(
                AppImages.profilePic,
                height: 32.h,
                width: 32.w,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 6.w),
            Text("SGT Sikring", style: AppTextStyles.headLine6),
            Spacer(),
            SvgPicture.asset(
              AppImages.settingsIcon,
              height: 16.h,
              width: 16.w,
              color: Color(0xFFFFFFFF).withOpacity(0.62),
            )
          ],
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 14),
          child: IconButton(
            icon: SvgPicture.asset(
              AppImages.backIcon,
              height: 24.h,
              width: 24.w,
              color: AppColors.primaryLight,
            ),
            onPressed: () => Get.back(),
          ),
        ),
      ),
      body: Column(
        children: [
          // Chat messages area
          Expanded(
            child: Obx(() => ListView.builder(
              controller: controller.scrollController,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              itemCount: controller.groupedMessages.length,
              itemBuilder: (context, index) {
                final item = controller.groupedMessages[index];

                if (item['type'] == 'date') {
                  return _buildDateSeparator(item['date']);
                } else {
                  return _buildMessageBubble(item);
                }
              },
            )),
          ),

          // Message input area
          _buildMessageInput(),
          SizedBox(
            height: 20.h,
          )
        ],
      ),
    );
  }

  Widget _buildDateSeparator(String date) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16.h),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 1,
              color: Color(0xFF3A3A3A),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              date,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: Color(0xFFBAB8B9),
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 1,
              color: Color(0xFF3A3A3A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final bool isUser = message['isUser'] ?? false;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [

          // Message bubble
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(Get.context!).size.width * 0.75,
              ),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: isUser
                    ? AppColors.grayDarker // Orange color for user messages
                    : AppColors.primaryNormal, // Dark gray for received messages
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.r),
                  topRight: Radius.circular(8.r),
                  bottomLeft: isUser ? Radius.circular(8.r) : Radius.circular(20.r),
                  bottomRight: isUser ? Radius.circular(20.r) : Radius.circular(8.r),
                ),
              ),
              child: Text(
                message['text'] ?? '',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.primaryLight,
                  height: 1.35,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.secondaryDark,
        // border: Border(
        //   top: BorderSide(
        //     color: Color(0xFF3A3A3A),
        //     width: 1,
        //   ),
        // ),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: AppColors.secondaryDark,
          borderRadius: BorderRadius.circular(100.r),
          border: Border.all(
            color: AppColors.primaryDark,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Attachment icon
            SvgPicture.asset(AppImages.imageFileIcon),
            SizedBox(width: 12.w),

            // Text input
            Expanded(
              child: TextField(
                controller: controller.messageController,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.primaryLight,
                ),
                decoration: InputDecoration(
                  hintText: "Type a message",
                  // hintStyle: GoogleFonts.plusJakartaSans(
                  //   fontSize: 14.sp,
                  //   fontWeight: FontWeight.w400,
                  //   color: Color(0xFFBAB8B9),
                  // ),
                  hintStyle: AppTextStyles.button.copyWith(
                    letterSpacing: 0
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (value) => controller.sendMessage(),
              ),
            ),
            SizedBox(width: 12.w), // Replace Spacer() with fixed spacing
            GestureDetector(
                onTap: () => controller.sendMessage(),
                child: SvgPicture.asset(AppImages.sendIcon)
            )
          ],
        ),
      ),
    );
  }
}