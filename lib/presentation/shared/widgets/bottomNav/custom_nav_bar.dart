import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';  // Import the Flutter SVG package
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../infrastructure/theme/app_colors.dart';
import '../../../../infrastructure/theme/text_styles.dart';
import 'nav_bar_model.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<CustomNavItem> items;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final double cornerRadius;
  final double elevation;
  final double height;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.backgroundColor =AppColors.secondaryDark,
    this.selectedItemColor = Colors.green,
    this.unselectedItemColor = AppColors.grayDarker,
    this.cornerRadius = 0.0,
    this.elevation = 0.0,
    this.height = 60.0,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: elevation,
      color:AppColors.secondaryDark,
      shadowColor: Colors.black.withOpacity(0.1),
      clipBehavior: Clip.hardEdge,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(cornerRadius),
        topRight: Radius.circular(cornerRadius),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(cornerRadius),
            topRight: Radius.circular(cornerRadius),
          ),
        ),
        height: height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(items.length, (index) {
            final item = items[index];
            final isSelected = index == currentIndex;

            return Expanded(
              child: InkWell(
                onTap: () => onTap(index),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon with background indicator
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Animated background for selected state
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          // height: isSelected ? 40 : 0,
                          // width: isSelected ? 40 : 0,
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.transparent : Colors.transparent,
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                        // SVG Icon
                        SvgPicture.asset(
                          item.svgAssetPath,  // Use the SVG asset path
                          color: isSelected ? selectedItemColor : unselectedItemColor,
                          width: 18.w,  // You can adjust the size as needed
                          height: 18.h,
                        ),
                      ],
                    ),
                     SizedBox(height: 4.h),
                    // Label
                    Text(
                      item.label,
                      style: AppTextStyles.caption1.copyWith(
                        color: isSelected ? selectedItemColor : unselectedItemColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 13.sp

                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
