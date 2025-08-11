import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

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
  final AddConversationsController addConversationsController = Get.find<
      AddConversationsController>();

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
        if(addConversationsController.isLoading.value){
          return Center(
            child: CircularProgressIndicator(color: AppColors.primaryNormal),
          );
        }else if(addConversationsController.userAttributes.isEmpty){
          return Center(
            child: Text("There's no one to chat.",style: AppTextStyles.headLine6,),
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
                            ProfileImageHelper.formatImageUrl( addConversationsController.userAttributes[index].personId?.profileImage?.imageUrl), fit: BoxFit.cover,),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${addConversationsController.userAttributes[index].personId!.name}", style: AppTextStyles.caption1.copyWith(
                            color: AppColors.secondaryLight, fontSize: 14.sp)),
                        SizedBox(height: 4.h,),
                        Text("${addConversationsController.userAttributes[index].personId!.role}", style: AppTextStyles.caption2.copyWith(
                            color: AppColors.secondaryLight),)
                      ],
                    ),
                    Spacer()
                    ,
                    GestureDetector(
                      onTap: () {
addConversationsController.userAttributes.removeAt(index);
                      },
                      child: Container(
                        height: 26.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.r),
                          color: AppColors.greenDark,
                        ),
                        child: Center(child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w,),
                          child: Text("Start Chat",
                            style: AppTextStyles.caption2.copyWith(
                                color: AppColors.secondaryLight),),
                        ),),
                      ),
                    )
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
