import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/routes/app_routes.dart';
import '../../../infrastructure/theme/app_colors.dart';
import '../../../infrastructure/theme/text_styles.dart';
import '../../../infrastructure/utils/app_images.dart';

import 'controllers/message_screen.controller.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  @override
  Widget build(BuildContext context) {
final MessageScreenController messageScreenController = Get.find<MessageScreenController>();




    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(45.h), // Set the height as per your requirement
        child: AppBar(
          backgroundColor: AppColors.secondaryDark,
          elevation: 0,
          scrolledUnderElevation: 0,
          automaticallyImplyLeading: false,
          title: Text(
            "Message",
            style: AppTextStyles.headLine6.copyWith(
              fontWeight: FontWeight.w400,
              height: 1.5,
              color: AppColors.primaryLight,
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 24.w,vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              SizedBox(
                height: 10.h,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Message',
                  style: AppTextStyles.headLine6.copyWith(height: 1.5),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: messageScreenController.messageList.length,
                itemBuilder: (context, index) {
                  final dotColor = messageScreenController.messageList[index]['status'] == 'active'? AppColors.greenNormal: AppColors.redNormal;

                  return Card(
                    color: AppColors.secondaryDark,
                    elevation: 0,
                    margin: EdgeInsets.only(bottom: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: InkWell(
                      onTap: () {
                        Get.toNamed(Routes.CONVERSATION_PAGE);
                      },
                      borderRadius: BorderRadius.circular(4.r), // Match card's border radius
                      splashColor: AppColors.grayDarker.withOpacity(0.3), // Customize ripple color
                      highlightColor: AppColors.grayDarker.withOpacity(0.3), // Customize highlight color
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6,vertical: 12), // Add some padding inside the card
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.asset(
                                    AppImages.chatPerson,
                                    height: 64.h,
                                    width: 64.w,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ConstrainedBox(
                                        constraints: BoxConstraints(
                                          maxWidth: MediaQuery.of(context).size.width * 0.5,
                                        ),
                                        child: Text(
                                          messageScreenController.messageList[index]['name']!,
                                          style: AppTextStyles.button.copyWith(
                                              color: AppColors.primaryLight
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      SizedBox(height: 8.h),
                                      Text(
                                        messageScreenController.messageList[index]['message']!,
                                        style: AppTextStyles.caption1.copyWith(
                                          color: Color(0xFFBAB8B9),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      messageScreenController.messageList[index]['time']!,
                                      style: GoogleFonts.plusJakartaSans(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w400,
                                          height: 1.35,
                                          color: Color(0xFFD1DDEB).withOpacity(0.62)
                                      ),
                                    ),
                                    SizedBox(height: 12.h),
                                    Icon(
                                      Icons.circle,
                                      size: 10,
                                      color: dotColor,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}