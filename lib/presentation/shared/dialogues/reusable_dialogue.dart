// Reusable Dialogue Widget
import 'package:flutter/material.dart';

class ReusableDialogue extends StatelessWidget {
  final List<Widget> children;
  final bool? canPop;

  const ReusableDialogue({super.key, required this.children, this.canPop});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPop ?? false,
      child: Dialog(
        backgroundColor: Color(0xFF1F222A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [...children],
          ),
        ),
      ),
    );
  }
}
