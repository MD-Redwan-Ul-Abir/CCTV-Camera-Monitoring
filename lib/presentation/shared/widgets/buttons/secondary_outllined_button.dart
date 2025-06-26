
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../infrastructure/theme/app_colors.dart';
import '../../../../infrastructure/theme/text_styles.dart';

class SecondaryOutlinedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final double? width;
  final double? height;
  final String? svgAsset;
  final double iconSize;
  final Color? borderColor;

  const SecondaryOutlinedButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.width,
    this.svgAsset,
    this.iconSize = 20,
    this.borderColor = Colors.white,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: OutlinedButton(
        onPressed: onPressed,

        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          side: BorderSide(color: borderColor ?? Colors.white, width: 2),
          backgroundColor: AppColors.secondaryDark,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (svgAsset != null) ...[
              SvgPicture.asset(
                svgAsset!,
                width: iconSize,
                height: iconSize,
                color: borderColor,
              ),
              SizedBox(width: 8),
            ],
            Text(
              text,
              style: AppTextStyles.textButton.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
