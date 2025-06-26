import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../infrastructure/theme/app_colors.dart';
import '../../../infrastructure/theme/text_styles.dart';
import '../../../infrastructure/utils/app_images.dart';

class CustomDropDown extends StatelessWidget {
  final String hintText;
  final String errorText;
  final String? selectedValue;
  final List<DropdownMenuItem<String>> items;
  final ValueChanged<String?>? onChanged;
  final FormFieldValidator<String>? validator;

  const CustomDropDown({
    super.key,
    required this.hintText,
    required this.errorText,
    required this.selectedValue,
    required this.items,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<String>(
      value: selectedValue,
      hint: Text(
        hintText,
        style: AppTextStyles.button.copyWith(
          color: AppColors.primaryLight,
        ),
      ),
      items: items,
      onChanged: onChanged,
      validator: validator ??
              (value) {
            if (value == null || value.isEmpty) {
              return errorText;
            }
            return null;
          },
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.grayDarker,
        contentPadding: EdgeInsets.only(top:  18.h,bottom: 18.h, right: 20.w,left: 4.w),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.r),
          borderSide: BorderSide.none,
        ),
      ),
      dropdownStyleData: DropdownStyleData(
        maxHeight: 300.h,
        // width: 400.w, // Custom width
        decoration: BoxDecoration(
          color: AppColors.secondaryDarker,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.primaryDarker, width: 1.2),
        ),
         offset: const Offset(0, -4), // To adjust dropdown position
      ),
      iconStyleData: IconStyleData(
        icon: Transform.rotate(
          angle: 3.14 / -2,
          child: SvgPicture.asset(
            AppImages.backIcon,
            height: 24.h,
            width: 24.w,
            color: AppColors.primaryLight,
          ),
        ),
      ),
      style: AppTextStyles.button.copyWith(color: AppColors.primaryLight),
    );
  }
}
