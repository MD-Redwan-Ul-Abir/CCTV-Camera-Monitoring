import 'package:flutter/material.dart';

class CustomNavItem {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  CustomNavItem({required this.icon, required this.label, this.onPressed});
}
