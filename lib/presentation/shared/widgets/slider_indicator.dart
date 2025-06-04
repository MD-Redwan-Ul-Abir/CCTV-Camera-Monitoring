import 'package:flutter/material.dart';

class SliderIndicator extends StatelessWidget {
  final int itemCount;
  final int currentIndex;
  final Color selectedColor;
  final Color unselectedColor;
  final double height;
  final double spacing;

  const SliderIndicator({
    super.key,
    required this.itemCount,
    required this.currentIndex,
    required this.selectedColor,
    required this.unselectedColor,
    this.height = 10.0,
    this.spacing = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(itemCount, (index) {
        // Determine if this is the current index
        final bool isSelected = index == currentIndex;

        return Padding(
          padding: EdgeInsets.only(right: index < itemCount - 1 ? spacing : 0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: height,
            width: isSelected ? height * 3 : height,
            decoration: BoxDecoration(
              color: isSelected ? selectedColor : unselectedColor,
              borderRadius: BorderRadius.circular(height / 2),
            ),
          ),
        );
      }),
    );
  }
}
