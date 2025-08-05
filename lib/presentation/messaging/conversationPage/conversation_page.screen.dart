import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../infrastructure/theme/app_colors.dart';
import '../../../infrastructure/theme/text_styles.dart';
import '../../../infrastructure/utils/app_images.dart';
import '../../shared/widgets/imagePicker/custom_image_picker.dart';
import '../../shared/widgets/imagePicker/imagePickerController.dart';
import 'controllers/conversation_page.controller.dart';

class ConversationPageScreen extends StatefulWidget {
  const ConversationPageScreen({super.key});

  @override
  State<ConversationPageScreen> createState() => _ConversationPageScreenState();
}

class _ConversationPageScreenState extends State<ConversationPageScreen> {
  final ConversationPageController conversationController = Get.find<ConversationPageController>();

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
              child: Image.network(
                conversationController.commonController.profileImage.value,
                height: 32.h,
                width: 32.w,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 32.h,
                    width: 32.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryNormal,
                    ),
                    child: Icon(
                      Icons.person,
                      color: AppColors.primaryLight,
                      size: 20.sp,
                    ),
                  );
                },
              ),
            ),
            SizedBox(width: 6.w),
            Text(conversationController.commonController.userName.value, style: AppTextStyles.headLine6),
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
            child: Obx(() {
              if (conversationController.isLoading.value && conversationController.conversationList.isEmpty) {
                return Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryNormal,
                  ),
                );
              }

              return Column(
                children: [
                  // Load more indicator at the top - more subtle and smooth
                  AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    height: conversationController.isLoadingMore.value ? 40.h : 0,
                    child: conversationController.isLoadingMore.value
                        ? Container(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 16.w,
                            height: 16.h,
                            child: CircularProgressIndicator(
                              strokeWidth: 1.5,
                              color: AppColors.primaryNormal,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Loading...',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11.sp,
                              color: AppColors.primaryLight.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    )
                        : SizedBox.shrink(),
                  ),

                  // Messages list
                  Expanded(
                    child: conversationController.groupedMessages.isEmpty
                        ? Center(
                      child: Text(
                        'No messages yet',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14.sp,
                          color: AppColors.primaryLight.withOpacity(0.7),
                        ),
                      ),
                    )
                        : ListView.builder(
                      controller: conversationController.scrollController,
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      itemCount: conversationController.groupedMessages.length,
                      itemBuilder: (context, index) {
                        final item = conversationController.groupedMessages[index];

                        if (item['type'] == 'date') {
                          return _buildDateSeparator(item['date']);
                        } else {
                          return _buildMessageBubble(item);
                        }
                      },
                    ),
                  ),
                ],
              );
            }),
          ),

          // Selected images preview
          _buildSelectedImagesPreview(),

          // Message input area
          _buildMessageInput(),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildSelectedImagesPreview() {
    return Obx(() {
      if (conversationController.imageController.selectedImages.isEmpty) {
        return SizedBox.shrink();
      }

      return Container(
        height: 100.h,
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: conversationController.imageController.selectedImages.length,
          itemBuilder: (context, index) {
            final image = conversationController.imageController.selectedImages[index];
            return Container(
              width: 80.w,
              height: 80.h,
              margin: EdgeInsets.only(right: 8.w),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: Image.file(
                      image,
                      width: 80.w,
                      height: 80.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 2.h,
                    right: 2.w,
                    child: GestureDetector(
                      onTap: () {
                        conversationController.imageController.selectedImages.removeAt(index);
                      },
                      child: Container(
                        width: 20.w,
                        height: 20.h,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 12.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildDateSeparator(String date) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16.h),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 1.h,
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
                    ? AppColors.primaryNormal // Your color for sent messages
                    : AppColors.grayDarker, // Color for received messages
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.r),
                  topRight: Radius.circular(8.r),
                  bottomLeft: isUser ? Radius.circular(8.r) : Radius.circular(20.r),
                  bottomRight: isUser ? Radius.circular(20.r) : Radius.circular(8.r),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display attachments (images) if they exist
                  if (message['attachments'] != null && message['attachments'].isNotEmpty) ...[
                    ...message['attachments'].map<Widget>((attachment) {
                      if (attachment != null && attachment.isNotEmpty) {
                        return Container(
                          margin: EdgeInsets.only(bottom: 8.h),
                          child: GestureDetector(
                            onTap: () => _showFullScreenImage(attachment),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: Image.network(
                                attachment,
                                height: 200.h,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    height: 200.h,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: AppColors.grayDarker,
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: AppColors.primaryNormal,
                                        value: loadingProgress.expectedTotalBytes != null
                                            ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                            : null,
                                      ),
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 200.h,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: AppColors.grayDarker,
                                      borderRadius: BorderRadius.circular(8.r),
                                      border: Border.all(
                                        color: AppColors.primaryDark,
                                        width: 1,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.broken_image_outlined,
                                          color: AppColors.primaryLight.withOpacity(0.6),
                                          size: 40.sp,
                                        ),
                                        SizedBox(height: 8.h),
                                        Text(
                                          'Failed to load image',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 12.sp,
                                            color: AppColors.primaryLight.withOpacity(0.6),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      }
                      return SizedBox.shrink();
                    }).toList(),
                  ],

                  // Message text (only show if there's text content)
                  if (message['text'] != null && message['text'].toString().isNotEmpty) ...[
                    Text(
                      message['text'] ?? '',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.primaryLight,
                        height: 1.35,
                      ),
                    ),
                  ],

                  // Timestamp
                  if (message['timestamp'] != null) ...[
                    SizedBox(height: 4.h),
                    Text(
                      _formatMessageTime(message['timestamp']),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.primaryLight.withOpacity(0.6),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFullScreenImage(String imageUrl) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.9),
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: Stack(
            children: [
              // Full screen image
              Center(
                child: InteractiveViewer(
                  panEnabled: true,
                  scaleEnabled: true,
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    width: double.infinity,
                    height: double.infinity,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryNormal,
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.broken_image_outlined,
                              color: AppColors.primaryLight,
                              size: 80.sp,
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              'Failed to load image',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 16.sp,
                                color: AppColors.primaryLight,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Close button
              Positioned(
                top: 50.h,
                right: 20.w,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 24.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatMessageTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.secondaryDark,
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
            GestureDetector(
              onTap: () {
                showImagePickerOption(
                  context,
                  conversationController.imageController,
                );
              },
              child: SvgPicture.asset(AppImages.imageFileIcon),
            ),
            SizedBox(width: 12.w),

            // Text input
            Expanded(
              child: TextField(
                controller: conversationController.messageController,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.primaryLight,
                ),
                decoration: InputDecoration(
                  hintText: "Type a message",
                  hintStyle: AppTextStyles.button.copyWith(letterSpacing: 0),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (value) => conversationController.sendMessage(),
              ),
            ),
            SizedBox(width: 12.w),

            // Send button with loading state
            Obx(() => GestureDetector(
              onTap: conversationController.isSendingMessage.value
                  ? null
                  : () => conversationController.sendMessage(),
              child: conversationController.isSendingMessage.value
                  ? SizedBox(
                width: 24.w,
                height: 24.h,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primaryNormal,
                ),
              )
                  : SvgPicture.asset(AppImages.sendIcon),
            )),
          ],
        ),
      ),
    );
  }
}