import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skt_sikring/infrastructure/utils/app_images.dart';

import '../../../infrastructure/theme/app_colors.dart';
import '../../../infrastructure/theme/text_styles.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final Color? dropdownHintTextColor;

  final int? prefixIconHeight;
  final int? prefixIconWeight;
  final int? sufixIconHeight;
  final int? sufixIconWeight;
  final Color? hintColor;
  final int? maxlength;
  final int? boxHeight;
  final String? keyboardType;
  final dynamic suffixSvg;
  final EdgeInsetsGeometry? prefixPadding;
  final dynamic prefixSvg;
  final List<DropdownMenuItem<String>>? dropDownItems;
  final Color? dropdownIconColor;
  final Color? filledColor;
  final Color? hintTextColor;
  final bool? filledstatus;
  final String? selectedValue;
  final ValueChanged<String?>? onChanged;
  final double? dropdownHeight;
  final double? dropdownWidth;
  final GlobalKey<FormState>? formKey;
  final bool isEnabled;
  final bool readOnly; // Added readOnly property
  final ValueChanged<String?>? onSaved, onFieldSubmitted;
  final FormFieldValidator<String>? validator;
  final VoidCallback? onTapSuffix;
  final FocusNode? focusNode;
  final bool autofocus;
  final String? suffixIcon;
  final Color? cursorColor;
  final bool? showFocusedBorder;

  const CustomTextFormField({
    super.key,
    required this.hintText,
    this.suffixSvg,
    this.prefixSvg,
    this.hintColor,
    this.maxlength,
    this.boxHeight,
    this.keyboardType,
    this.dropDownItems,
    this.controller,
    this.prefixPadding,
    this.dropdownIconColor,
    this.filledColor,
    this.hintTextColor,
    this.selectedValue,
    this.onChanged,
    this.dropdownHeight,
    this.dropdownWidth,
    this.filledstatus,
    this.formKey,
    this.isEnabled = true,
    this.readOnly = false, // Default value for readOnly
    this.onSaved,
    this.validator,
    this.onTapSuffix,
    this.onFieldSubmitted,
    this.focusNode,
    this.autofocus = false,
    this.suffixIcon,
    this.showFocusedBorder = false,
    this.prefixIconHeight,
    this.prefixIconWeight,
    this.sufixIconHeight,
    this.sufixIconWeight,
    this.dropdownHintTextColor,
    this.cursorColor,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _obscureText = true;

  TextInputType? _getKeyboardType(String? type) {
    switch (type) {
      case 'text':
        return TextInputType.text;
      case 'number':
        return TextInputType.number;
      case 'email':
        return TextInputType.emailAddress;
      case 'phone':
        return TextInputType.phone;
      case 'multiline':
        return TextInputType.multiline;
      case 'datetime':
        return TextInputType.datetime;
      case 'url':
        return TextInputType.url;
      case 'visiblePassword':
        return TextInputType.visiblePassword;
      default:
        return TextInputType.text;
    }
  }

  bool get _isPasswordField => widget.keyboardType == 'visiblePassword';

  @override
  Widget build(BuildContext context) {
    if (widget.dropDownItems != null && widget.dropDownItems!.isNotEmpty) {
      return IgnorePointer(
        ignoring: !widget.isEnabled || widget.readOnly, // Updated to consider readOnly
        child: DropdownButtonFormField<String>(
          value: widget.selectedValue,
          items: widget.dropDownItems,
          onChanged: widget.isEnabled && !widget.readOnly ? widget.onChanged : null, // Updated
          decoration: _inputDecoration(context),
          style: AppTextStyles.button,
          dropdownColor: AppColors.grayDarker,
          iconEnabledColor: widget.dropdownIconColor,
          icon: Transform.rotate(
            angle: 3.14 / -2, // Rotate 90 degrees, in radians (for 180 degrees use 3.14, for 90 degrees use 3.14 / 2)
            child: SvgPicture.asset(
              AppImages.backIcon, // Bell icon from assets
              height: 24.h, // Set the desired height
              width: 24.w,  // Set the desired width
              color: widget.dropdownIconColor ?? AppColors.primaryLight, // Set the color
            ),
          ),
        ),
      );
    }

    return TextFormField(
      controller: widget.controller,
      autofocus: widget.autofocus,
      focusNode: widget.focusNode,
      enabled: widget.isEnabled,
      readOnly: widget.readOnly, // Added readOnly property
      onChanged: widget.isEnabled && !widget.readOnly ? widget.onChanged : null, // Updated
      onSaved: widget.onSaved,
      cursorColor: widget.cursorColor ?? AppColors.primaryNormal,
      onFieldSubmitted: widget.onFieldSubmitted,
      validator: (value) {
        final customError = widget.validator?.call(value);
        if (customError != null) return customError;

        if (widget.keyboardType == 'email') {
          const emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
          final allowedDomains = [
            'gmail.com',
            'yahoo.com',
            'outlook.com',
            'icloud.com',
            'hotmail.com',
            'live.com',
            'protonmail.com'
          ];

          if (value == null || value.trim().isEmpty) {
            return 'Email is required';
          } else if (!RegExp(emailRegex).hasMatch(value.trim())) {
            return 'Enter a valid email address';
          } else {
            final domain = value.trim().split('@').last.toLowerCase();
            if (!allowedDomains.contains(domain)) {
              return 'Please use a valid email provider (e.g. gmail.com)';
            }
          }

          return null;
        }

        return null;
      },
      maxLength: widget.maxlength,
      obscureText: _isPasswordField ? _obscureText : false,
      keyboardType: _getKeyboardType(widget.keyboardType),
      minLines: widget.keyboardType == 'multiline' ? 5 : 1,
      maxLines: widget.keyboardType == 'multiline' ? null : 1,
      decoration: _inputDecoration(context),
      style: AppTextStyles.button,
    );
  }

  InputDecoration _inputDecoration(BuildContext context) {
    // Check if this is a dropdown with a selected value
    // bool isDropdownWithSelection = widget.dropDownItems != null &&
    //     widget.dropDownItems!.isNotEmpty &&
    //     widget.selectedValue != null;

    return InputDecoration(
      hintText: widget.hintText,
      hintStyle: AppTextStyles.button.copyWith(
        color: widget.dropdownHintTextColor ?? widget.hintTextColor ?? AppColors.primaryLight,
      ),
      filled: widget.filledstatus ?? true,
      fillColor:
      widget.filledColor ?? (widget.isEnabled ? AppColors.grayDarker : AppColors.grayDarker),
      contentPadding: EdgeInsets.symmetric(
        vertical: widget.boxHeight?.toDouble() ?? 18.h,
        horizontal: 20.w,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: Colors.transparent),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: Colors.transparent),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: AppColors.primaryDarker, width: 1.5),
      ),
      prefixIcon: _buildPrefixIcon(context),
      suffixIcon: _isPasswordField && !widget.readOnly // Don't show password toggle for readOnly fields
          ? IconButton(
        icon: widget.suffixSvg != null && _obscureText
            ? _buildSuffixIcon(context)!
            : SvgPicture.asset(
          _obscureText ? AppImages.passwordOff : AppImages.passwordOn,
          height: 18.h,
          width: 18.w,
          color: AppColors.primaryLight,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      )
          : _buildSuffixIcon(context),
    );
  }

  Widget? _buildPrefixIcon(BuildContext context) {
    if (widget.prefixSvg is String) {
      return Padding(
        padding: EdgeInsets.all(9.sp),
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: SvgPicture.asset(
            widget.prefixSvg!,
            height: widget.prefixIconHeight?.toDouble() ?? 16.h,
            width: widget.prefixIconWeight?.toDouble() ?? 16.w,
            fit: BoxFit.contain,
            color: AppColors.primaryLight,
          ),
        ),
      );
    } else if (widget.prefixSvg != null) {
      return Padding(
        padding: widget.prefixPadding ?? EdgeInsets.all(12.sp),
        child: widget.prefixSvg,
      );
    }
    return null;
  }

  Widget? _buildSuffixIcon(BuildContext context) {
    if (widget.suffixSvg is String) {
      return GestureDetector(
        onTap: widget.onTapSuffix, // Handle suffix icon tap
        child: Padding(
          padding: EdgeInsets.all(12.sp),
          child: SvgPicture.asset(
            widget.suffixSvg!,
            height: widget.sufixIconHeight?.toDouble() ?? 24.h,
            width: widget.sufixIconWeight?.toDouble() ?? 24.h,
            fit: BoxFit.cover,
          ),
        ),
      );
    } else if (widget.suffixSvg != null) {
      return Padding(padding: EdgeInsets.all(10.sp), child: widget.suffixSvg);
    }
    return null;
  }
}