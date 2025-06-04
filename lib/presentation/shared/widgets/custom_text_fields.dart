import 'package:flutter/material.dart';

import '../../../infrastructure/theme/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final Color? hintColor;
  final Color? backgroundColor;
  final Color? activeBgColor;
  final bool isPassword;
  final Widget? leftIcon;
  final Widget? rightIcon;
  final InputBorder? border;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final TextStyle? textStyle;
  final int? maxLines;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final BoxDecoration? backgroundDecoration;
  final EdgeInsets? backgroundPadding;

  const CustomTextField({
    super.key,
    this.controller,
    this.hintText,
    this.hintColor,
    this.backgroundColor,
    this.activeBgColor,
    this.isPassword = false,
    this.leftIcon,
    this.rightIcon,
    this.border,
    this.enabledBorder,
    this.focusedBorder,
    this.borderRadius,
    this.padding,
    this.textStyle,
    this.maxLines = 1,
    this.keyboardType,
    this.onChanged,
    this.validator,
    this.backgroundDecoration,
    this.backgroundPadding,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;
  bool _isFocused = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget textField = TextFormField(
      cursorColor: AppColors.primaryDark,
      controller: widget.controller,
      obscureText: _obscureText,
      maxLines: widget.isPassword ? 1 : widget.maxLines,
      keyboardType: widget.keyboardType,
      style: widget.textStyle ?? TextStyle(color: AppColors.primaryDark),
      onChanged: widget.onChanged,
      validator: widget.validator,
      focusNode: _focusNode,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(color: widget.hintColor ?? Colors.grey),
        filled: widget.backgroundColor != null || widget.activeBgColor != null,
        fillColor:
            _isFocused && widget.activeBgColor != null
                ? widget.activeBgColor
                : widget.backgroundColor,
        prefixIcon: widget.leftIcon,
        prefixIconConstraints: const BoxConstraints(
          minWidth: 40,
          maxWidth: 40,
          minHeight: 16,
          maxHeight: 16,
        ),
        suffixIcon:
            widget.isPassword
                ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
                : widget.rightIcon,
        suffixIconConstraints: const BoxConstraints(
          minWidth: 40,
          maxWidth: 40,
          minHeight: 16,
          maxHeight: 16,
        ),
        border:
            widget.border ??
            OutlineInputBorder(
              borderRadius: widget.borderRadius ?? BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: Colors.grey),
            ),
        enabledBorder:
            widget.enabledBorder ??
            OutlineInputBorder(
              borderRadius: widget.borderRadius ?? BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: Colors.grey),
            ),
        focusedBorder:
            widget.focusedBorder ??
            OutlineInputBorder(
              borderRadius: widget.borderRadius ?? BorderRadius.circular(8.0),
              borderSide: const BorderSide(
                color: AppColors.primaryDark,
                width: 2,
              ),
            ),
        contentPadding:
            widget.padding ??
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      ),
    );

    // Apply background decoration if provided
    if (widget.backgroundDecoration != null) {
      return Container(
        decoration: widget.backgroundDecoration,
        padding: widget.backgroundPadding ?? EdgeInsets.zero,
        child: textField,
      );
    }

    return textField;
  }
}
