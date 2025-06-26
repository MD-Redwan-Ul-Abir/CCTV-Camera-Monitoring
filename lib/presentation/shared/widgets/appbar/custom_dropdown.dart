import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../infrastructure/utils/log_helper.dart';


class CustomDropdown extends StatefulWidget {
  final List<String> options;
  final Function(String)? onChanged;
  final String? hint;

  const CustomDropdown({
    super.key,
    required this.options,
    this.onChanged,
    this.hint,
  });

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String? _selectedOption;
  bool _isOpen = false;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    if (widget.options.isNotEmpty) {
      // _selectedOption = widget.options.first;
    }
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _toggleDropdown() {
    if (_isOpen) {
      _removeOverlay();
    } else {
      _showOverlay();
    }
    setState(() {
      _isOpen = !_isOpen;
    });
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _showOverlay() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _selectOption(String option) {
    LoggerHelper.info("Selected option: $option");
    setState(() {
      _selectedOption = option;
      _isOpen = false;
    });
    if (widget.onChanged != null) {
      widget.onChanged!(option);
    }
    _removeOverlay();
  }

  OverlayEntry _createOverlayEntry() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    return OverlayEntry(
      builder:
          (context) => Positioned(
            width: size.width,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0.0, size.height),
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(10),
                color: Color(0xFF1F222A),
                child: Container(
                  constraints: BoxConstraints(maxHeight: 150),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: widget.options.length,
                    itemBuilder: (context, index) {
                      final option = widget.options[index];
                      return InkWell(
                        onTap: () {
                          _selectOption(option);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color:
                                _selectedOption == option
                                    ? Color(0xFF3A3E4A)
                                    : Color(0xFF1F222A),
                          ),
                          child: Text(
                            option,
                            style: TextStyle(
                              color:
                                  _selectedOption == option
                                      ? Colors.white
                                      : Color(0xFFA1A1A1),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: SizedBox(
        width: Get.width,
        child: GestureDetector(
          onTap: _toggleDropdown,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color: Color(0xFF1F222A),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedOption ?? widget.hint!,
                  style: TextStyle(color: Color(0xFFA1A1A1), fontSize: 16),
                ),
                Icon(
                  _isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  color: Color(0xFFA1A1A1),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
