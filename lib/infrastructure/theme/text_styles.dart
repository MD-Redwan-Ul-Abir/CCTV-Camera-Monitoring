import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle headLine1 = TextStyle(
    fontSize: 64.sp,
    fontWeight: FontWeight.w500,
    fontFamily: GoogleFonts.poppins().fontFamily,
    color: AppColors.secondaryLight,
    height: 1.3,
    letterSpacing: 0,
  );

  static TextStyle headLine2 = TextStyle(
    fontSize: 60.sp,
    fontWeight: FontWeight.w500,
    fontFamily: GoogleFonts.poppins().fontFamily,
    color: AppColors.secondaryLight,

    letterSpacing: 0,
  );

  static TextStyle headLine3 = TextStyle(
    fontSize: 32.sp,
    fontWeight: FontWeight.w600,
    fontFamily: GoogleFonts.poppins().fontFamily,
    color: AppColors.secondaryLight,

    letterSpacing: 0,
  );

  static TextStyle headLine4 = TextStyle(
    fontSize: 32.sp,
    fontWeight: FontWeight.w600,
    fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
    color: AppColors.secondaryLight,

    letterSpacing: 0,
  );

  static TextStyle headLine5 = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w500,
    fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
    color: AppColors.primaryLight,
    height: 1.2,
    letterSpacing: 0,
  );

  static TextStyle headLine6 = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w400, // Match Figma
    fontFamily: GoogleFonts.poppins().fontFamily,
    color: AppColors.secondaryLight,
    height: 1.5,
    letterSpacing: 1.08,
  );

  static TextStyle paragraph = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
    color: AppColors.secondaryLight,
    letterSpacing: 0,
  );
  static TextStyle paragraph2 = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w400,
    fontFamily: GoogleFonts.poppins().fontFamily,
    color: AppColors.primaryLight,
    height: 1.6,
    letterSpacing: 0,
  );
  static TextStyle paragraph3 = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    fontFamily: GoogleFonts.poppins().fontFamily,
    color: AppColors.primaryLight,
    height: 1.5,
    letterSpacing: 0,
  );
  static TextStyle textButton = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
    color: AppColors.secondaryLight,
    height: 1.2,
    letterSpacing: 0,
  );
  static TextStyle textCaption1 = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
    color: AppColors.secondaryLightActive,
    height: 1.2,
    letterSpacing: 0,
  );

  static TextStyle caption1 = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    fontFamily: GoogleFonts.poppins().fontFamily,
    color: AppColors.secondaryDark,
    height: 1.35,
    letterSpacing: 0,
  );
  // static TextStyle calendarText = TextStyle(
  //   fontSize: 12.sp,
  //   fontWeight: FontWeight.w600,
  //   fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
  //   color: AppColors.secondaryTextColor,
  //   height: 1.2,
  //   letterSpacing: 0,
  // );
  // static TextStyle textCaption2 = TextStyle(
  //   fontSize: 10.sp,
  //   fontWeight: FontWeight.w500,
  //   fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
  //   color: AppColors.secondaryTextColor,
  //   height: 1.2,
  //   letterSpacing: 0,
  // );

  static TextStyle button = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    fontFamily: GoogleFonts.poppins().fontFamily,
    color: AppColors.secondaryLightActive,
    letterSpacing: 0.21, // Match Figma
    height: 1.5, // Match line height (21px)
  );

  static TextStyle secondaryText = TextStyle(
    fontSize: 12.sp,
    letterSpacing: 0,
    fontWeight: FontWeight.w400,
    fontFamily: GoogleFonts.poppins().fontFamily,
    color: AppColors.primaryDark,
    height: 1.35,
  );

  static TextStyle secondaryText2 = TextStyle(
    fontSize: 12.sp,
    letterSpacing: 0,
    fontWeight: FontWeight.w400,
    fontFamily: GoogleFonts.poppins().fontFamily,
    color: AppColors.grayDarker,
    height: 1.35,
  );
}
