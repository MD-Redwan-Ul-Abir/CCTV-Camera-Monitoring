//
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
//
// import '../../../../infrastructure/navigation/routes.dart';
// import '../../../../infrastructure/theme/app_colors.dart';
// import '../buttons/secondary_outllined_button.dart';
//
// class CarDetailsCard extends StatelessWidget {
//   final String carName;
//   final int price;
//   final String date;
//   final double ratings;
//   final String carImageUrl;
//   final VoidCallback? seeDetails;
//
//   const CarDetailsCard({
//     super.key,
//     required this.carName,
//     required this.price,
//
//     required this.ratings,
//     required this.carImageUrl,
//     this.seeDetails,
//     required this.date,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 15),
//       child: Container(
//         height: 160.h,
//         width: 348.w,
//         clipBehavior: Clip.hardEdge,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(9.r),
//           color: AppColors.hintColor,
//         ),
//         child: Stack(
//           clipBehavior: Clip.none,
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(
//                 top: 22,
//                 left: 22,
//                 right: 22,
//                 bottom: 10,
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   /// Title & Rating Row
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         carName,
//                         style: AppTextStyles.headLine6.copyWith(
//                           color: AppColors.secondaryTextColor,
//                         ),
//                       ),
//                       Row(
//                         children: [
//                           SvgPicture.asset(AppImages.ratingsIcon),
//                           SizedBox(width: 2.w),
//                           Text(
//                             "$ratings/5",
//                             style: AppTextStyles.textCaption1,
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 6.h),
//
//                   /// Price & Button
//                   Text("$price\$/$date", style: AppTextStyles.paragraph),
//                   SizedBox(height: 41.h),
//                   SecondaryOutlinedButton(
//                     height: 30.h,
//                     onPressed: () {
//                       Get.toNamed(Routes.CAR_DETAILS_PAGE);
//                     },
//                     text: 'See details',
//                   ),
//                 ],
//               ),
//             ),
//
//             /// Car image positioned bottom right
//             Positioned(
//               bottom: -34, // allow slight overflow
//               right: -35,
//               child: Image.asset(
//                 carImageUrl,
//                 height: 150.h,
//                 fit: BoxFit.fitHeight,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
