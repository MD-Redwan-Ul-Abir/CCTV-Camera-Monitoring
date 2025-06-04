import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomSvgRatingBar extends StatelessWidget {
  final double rating;
  final int starCount;
  final Function(double) onRatingChanged;
  final String fullIconPath;
  final String halfIconPath;
  final String emptyIconPath;
  final double iconSize;

  const CustomSvgRatingBar({
    super.key,
    required this.rating,
    required this.onRatingChanged,
    required this.fullIconPath,
    required this.halfIconPath,
    required this.emptyIconPath,
    this.starCount = 5,
    this.iconSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> stars = [];

    for (int i = 0; i < starCount; i++) {
      double currentStar = i + 1;
      String iconToUse;

      if (currentStar <= rating) {
        iconToUse = fullIconPath;
      } else if (currentStar - 0.5 <= rating) {
        iconToUse = halfIconPath;
      } else {
        iconToUse = emptyIconPath;
      }

      stars.add(
        GestureDetector(
          onTap: () => onRatingChanged(currentStar),
          child: SvgPicture.asset(iconToUse, height: iconSize, width: iconSize),
        ),
      );

      // Add spacing between stars, except after the last one
      if (i != starCount - 1) {
        stars.add(SizedBox(width: 4.w)); // adjust spacing here
      }
    }

    return Row(mainAxisSize: MainAxisSize.min, children: stars);
  }
}
