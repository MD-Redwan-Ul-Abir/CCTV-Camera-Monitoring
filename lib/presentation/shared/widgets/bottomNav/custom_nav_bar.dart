import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    this.backgroundColor = Colors.white,
    this.selectedItemColor = Colors.green,
    this.unselectedItemColor = Colors.grey,
    this.cornerRadius = 16.0,
    this.elevation = 8.0,
    this.height = 60.0,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: elevation,
      color: Colors.transparent,
      shadowColor: Colors.black.withOpacity(0.1),
      // Handle the 1px overflow by clipping to bounds
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
                    // Icon with indicator
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Animated container for background indicator
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: isSelected ? 40 : 0,
                          width: isSelected ? 40 : 0,
                          decoration: BoxDecoration(
                            // when active , background color
                            color:
                                isSelected
                                    // ? selectedItemColor?.withOpacity(0.1)
                                    ? Color(0xFFEEFEE6)
                                    : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        // Icon
                        Icon(
                          item.icon,
                          color:
                              isSelected
                                  ? selectedItemColor
                                  : unselectedItemColor,
                          size: 24,
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    // Label
                    Text(
                      item.label,
                      // style: TextStyle(
                      //   color:
                      //       isSelected
                      //           ? selectedItemColor
                      //           : unselectedItemColor,
                      //   fontSize: 12,
                      //   fontWeight:
                      //       isSelected ? FontWeight.bold : FontWeight.normal,
                      // ),
                      style: AppTextStyles.textButton.copyWith(
                        color:
                            isSelected
                                ? selectedItemColor
                                : unselectedItemColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
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
    // }
  }
}
