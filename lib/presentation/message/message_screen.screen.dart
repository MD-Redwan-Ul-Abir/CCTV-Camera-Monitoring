import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../infrastructure/navigation/routes.dart';
import '../../infrastructure/theme/app_colors.dart';
import '../../infrastructure/theme/text_styles.dart';
import '../../infrastructure/utils/app_images.dart';
import 'controllers/message_screen.controller.dart';

class MessageScreen extends GetView<MessageScreenController> {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {

    List<Map<String, String>> siteData = [
      {'Company name': 'Henriks Company', 'date': 'Yesterday','topic':'Meeting Schedule','description':'Lets schedule a meeting for next week...'},
      {'Company name': 'Alices Agency', 'date': 'Today','topic':'Project Update','description':'We need to review the project progress this week.'},
      {'Company name': 'Bobs Firm', 'date': 'Tomorrow','topic':'Budget Review','description':'Prepare the budget analysis for next months meeting. '},
    ];

    List<Map<String, String>> messageList = [
      {'name': 'Henrik', 'time': '9:45 AM','message':'Meeting Schedule','status':'active'},
      {'name': 'Alice', 'time': '10:25 AM','message':'Project Update','status':'inactive'},
      {'name': 'Bobs', 'time': '3:50 AM','message':'Budget Review','status':'active'},
    ];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.h), // Set the height as per your requirement
        child: AppBar(
          backgroundColor: AppColors.secondaryDark,
          elevation: 0,
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
          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Announcement',
                  style: AppTextStyles.headLine6.copyWith(height: 1.5),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: siteData.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: AppColors.grayDarker,
                    elevation: 2,
                    margin: EdgeInsets.only(bottom: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                siteData[index]['Company name']!,
                                style: AppTextStyles.paragraph3.copyWith(
                                  //fontWeight: FontWeight.bold,
                                  color: AppColors.primaryLight
                                ),
                              ),
                              Text(
                                siteData[index]['date']!,
                                style: AppTextStyles.caption1.copyWith(
                                  color: AppColors.secondaryLightActive,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            siteData[index]['topic']!,
                            style: AppTextStyles.caption1.copyWith(
                              //fontWeight: FontWeight.w600,
                              color: AppColors.secondaryLightActive,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            siteData[index]['description']!,
                            style: AppTextStyles.caption1.copyWith(

                              color: AppColors.secondaryLightActive,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
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
                itemCount: siteData.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: AppColors.grayDarker,
                    elevation: 2,
                    margin: EdgeInsets.only(bottom: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                siteData[index]['Company name']!,
                                style: AppTextStyles.paragraph3.copyWith(
                                  //fontWeight: FontWeight.bold,
                                    color: AppColors.primaryLight
                                ),
                              ),
                              Text(
                                siteData[index]['date']!,
                                style: AppTextStyles.caption1.copyWith(
                                  color: AppColors.secondaryLightActive,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            siteData[index]['topic']!,
                            style: AppTextStyles.caption1.copyWith(
                              //fontWeight: FontWeight.w600,
                              color: AppColors.secondaryLightActive,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            siteData[index]['description']!,
                            style: AppTextStyles.caption1.copyWith(

                              color: AppColors.secondaryLightActive,
                            ),
                          ),
                        ],
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