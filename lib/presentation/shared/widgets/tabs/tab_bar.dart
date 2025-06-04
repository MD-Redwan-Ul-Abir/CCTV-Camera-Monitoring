import 'package:flutter/material.dart';

import '../../../../infrastructure/theme/app_colors.dart';

class CustomTabBar extends StatefulWidget {
  final List<String> items;
  final Color selectedColor;
  final Color unselectedColor;
  final Color selectedTextColor;
  final Color unselectedTextColor;
  final void Function(int)? onTabChanged;
  final int initialSelectedIndex;

  const CustomTabBar({
    Key? key,
    required this.items,
    this.selectedColor = Colors.black,
    this.unselectedColor = Colors.white,
    this.selectedTextColor = Colors.white,
    this.unselectedTextColor = Colors.grey,
    this.onTabChanged,
    this.initialSelectedIndex = 0,
  }) : super(key: key);

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialSelectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              widget.items.length,
              (index) => Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                      widget.onTabChanged?.call(index);
                    },
                    borderRadius: BorderRadius.circular(99),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color:
                            _selectedIndex == index
                                ? widget.selectedColor
                                : widget.unselectedColor,
                        borderRadius: BorderRadius.circular(99),
                        border:
                            _selectedIndex == index
                                ? null
                                : Border.all(
                                  color: AppColors.primaryDark,
                                  width: 1,
                                ),
                      ),
                      child: Text(
                        widget.items[index],
                        style: TextStyle(
                          color:
                              _selectedIndex == index
                                  ? widget.selectedTextColor
                                  : widget.unselectedTextColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
