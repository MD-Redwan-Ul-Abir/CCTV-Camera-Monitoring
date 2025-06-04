// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
//
// import '../../../../infrastructure/theme/app_colors.dart';
//
// class CustomInputField extends StatefulWidget {
//   final String hintText;
//   final String? svgIconPath;
//   final bool isPassword;
//   final TextEditingController controller;
//   final bool isDisable;
//   final int? maxline;
//
//   const CustomInputField({
//     super.key,
//     required this.hintText,
//     this.svgIconPath,
//     this.isPassword = false,
//     this.isDisable = false,
//     this.maxline,
//     required this.controller,
//   });
//
//   @override
//   _CustomInputFieldState createState() => _CustomInputFieldState();
// }
//
// class _CustomInputFieldState extends State<CustomInputField> {
//   bool _isPasswordVisible = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       enabled: !widget.isDisable,
//       controller: widget.controller,
//       obscureText: widget.isPassword && !_isPasswordVisible,
//       maxLines: widget.maxline ?? 1,
//       // Toggle visibility
//       decoration: InputDecoration(
//         hintText: widget.hintText,
//         filled: true,
//         fillColor: AppColors.secondaryColor,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8.0),
//           borderSide: BorderSide(color: AppColors.primaryColor),
//         ),
//         disabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8.0),
//           borderSide: BorderSide(color: AppColors.primaryColor, width: 1.5),
//         ),
//         prefixIcon:
//             widget.svgIconPath != null
//                 ? Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: SvgPicture.asset(widget.svgIconPath!),
//                 )
//                 : null,
//         suffixIcon:
//             widget.isPassword
//                 ? IconButton(
//                   icon: Icon(
//                     _isPasswordVisible
//                         ? Icons.visibility
//                         : Icons.visibility_off,
//                     color: AppColors.primaryColor,
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       _isPasswordVisible = !_isPasswordVisible;
//                     });
//                   },
//                 )
//                 : null,
//       ),
//     );
//   }
// }
