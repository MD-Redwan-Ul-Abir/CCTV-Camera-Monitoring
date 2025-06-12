import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:skt_sikring/presentation/shared/widgets/buttons/primary_buttons.dart';

import '../../infrastructure/theme/app_colors.dart';
import '../../infrastructure/theme/text_styles.dart';
import '../../infrastructure/utils/app_images.dart';
import 'controllers/site_details.controller.dart';

class SiteDetailsScreen extends GetView<SiteDetailsController> {
  const SiteDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryDark,

      appBar: AppBar(
        backgroundColor: AppColors.secondaryDark,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 80.h,
        title: Text(
          "Site Details",
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
                height: 30.h,
                width: 30.w,
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Auto Carousel Slider
              AutoCarouselSlider(),

              SizedBox(height: 20.h),

              // Site Information
              Text(
                "Site A, Bashundhara",
                style: AppTextStyles.button.copyWith(
                  color: AppColors.primaryLight,
                  fontWeight: FontWeight.w600,
                ),
              ),

              SizedBox(height: 8.h),

              Text(
                "23 - 30 May (40 Hours)",
                style: AppTextStyles.caption1.copyWith(
                  color: AppColors.primaryLight.withOpacity(0.7),
                ),
              ),

              SizedBox(height: 24.h),

              // Assign Manager Section
              Text(
                "Assign manager",
                style: AppTextStyles.caption1.copyWith(
                  color: AppColors.primaryLight.withOpacity(0.8),
                ),
              ),

              SizedBox(height: 12.h),

              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.secondaryDark,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20.r,
                      backgroundImage: AssetImage(AppImages.chatPerson),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      "Henrik",
                      style: AppTextStyles.caption1.copyWith(
                        color: AppColors.primaryLight,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),

              // Type Section
              Text(
                "Type",
                style: AppTextStyles.caption1.copyWith(
                  color: AppColors.primaryLight.withOpacity(0.8),
                ),
              ),

              SizedBox(height: 12.h),

              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.secondaryDark,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  "Construction Site",
                  style: AppTextStyles.caption1.copyWith(
                    color: AppColors.primaryLight,
                  ),
                ),
              ),

              SizedBox(height: 40.h),

              // Live View Site Button
              PrimaryButton(width: double.infinity,onPressed: (){}, text: 'Live View Site')
            ],
          ),
        ),
      ),
    );
  }
}

class AutoCarouselSlider extends StatefulWidget {
  const AutoCarouselSlider({super.key});

  @override
  _AutoCarouselSliderState createState() => _AutoCarouselSliderState();
}

class _AutoCarouselSliderState extends State<AutoCarouselSlider> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  // Sample images - replace with your actual image paths
  final List<String> _images = [
    AppImages.chatPerson, // Replace with actual site images
    AppImages.chatPerson, // Replace with actual site images
    AppImages.chatPerson, // Replace with actual site images
    AppImages.chatPerson, // Replace with actual site images
  ];

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_currentPage < _images.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 350),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Carousel Container
        Container(
          height: 220.h,
          width: 3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.r),
            color: AppColors.secondaryDark,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: _images.length,
              itemBuilder: (context, index) {
                return Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(_images[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Overlay for better text visibility if needed
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.3),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        SizedBox(height: 16.h),

        // Dot Indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _images.length,
                (index) => AnimatedContainer(
              duration: Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              height: 8.h,
              width: _currentPage == index ? 24.w : 8.w,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? AppColors.primaryDark
                    : AppColors.grayDarker,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
        ),
      ],
    );
  }
}