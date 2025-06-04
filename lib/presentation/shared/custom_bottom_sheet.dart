import 'package:flutter/material.dart';

class CustomBottomSheet {
  /// Shows a custom bottom sheet with the provided content.
  ///
  /// Parameters:
  /// - [context]: The BuildContext to show the bottom sheet
  /// - [content]: The widget to display inside the bottom sheet
  /// - [backgroundColor]: The background color of the bottom sheet
  /// - [elevation]: The elevation of the bottom sheet
  /// - [shape]: The shape of the bottom sheet
  /// - [isDismissible]: Whether the bottom sheet can be dismissed by tapping outside
  /// - [enableDrag]: Whether the bottom sheet can be dragged
  /// - [isScrollControlled]: Whether the bottom sheet can take up the full screen
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget content,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
    bool isDismissible = true,
    bool enableDrag = true,
    bool isScrollControlled = false,
    double? heightFactor,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: backgroundColor ?? Theme.of(context).cardColor,
      elevation: elevation ?? 8.0,
      shape:
          shape ??
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
          ),
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: isScrollControlled,
      constraints:
          heightFactor != null
              ? BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * heightFactor,
              )
              : null,
      builder: (BuildContext context) {
        return content;
      },
    );
  }

  /// Shows a persistent bottom sheet with the provided content.
  ///
  /// Parameters:
  /// - [context]: The BuildContext to show the bottom sheet
  /// - [content]: The widget to display inside the bottom sheet
  /// - [backgroundColor]: The background color of the bottom sheet
  /// - [elevation]: The elevation of the bottom sheet
  /// - [shape]: The shape of the bottom sheet
  static PersistentBottomSheetController showPersistent({
    required BuildContext context,
    required Widget content,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
  }) {
    return showBottomSheet(
      context: context,
      backgroundColor: backgroundColor ?? Theme.of(context).cardColor,
      elevation: elevation ?? 8.0,
      shape:
          shape ??
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
          ),
      builder: (BuildContext context) {
        return content;
      },
    );
  }
}

// uses example

// CustomBottomSheet.show(
//   context: context,
//   content: Container(
//     padding: EdgeInsets.all(16.0),
//     child: Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Text('Custom Bottom Sheet'),
//         SizedBox(height: 16.0),
//         ElevatedButton(
//           onPressed: () => Navigator.pop(context),
//           child: Text('Close'),
//         ),
//       ],
//     ),
//   ),
//   isScrollControlled: true,
//   heightFactor: 0.5,
// );

// // Persistent bottom sheet
// CustomBottomSheet.showPersistent(
//   context: context,
//   content: Container(
//     padding: EdgeInsets.all(16.0),
//     child: Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Text('Persistent Bottom Sheet'),
//         SizedBox(height: 16.0),
//       ],
//     ),
//   ),
// );
