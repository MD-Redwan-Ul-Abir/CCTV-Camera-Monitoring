
import 'package:flutter/material.dart';
import 'package:skt_sikring/presentation/shared/widgets/slider_indicator.dart';
import 'dart:async';

import '../../../infrastructure/theme/app_colors.dart';
import '../../../infrastructure/theme/text_styles.dart';

class TextSlider extends StatefulWidget {
  const TextSlider({super.key});

  @override
  _TextSliderState createState() => _TextSliderState();
}

class _TextSliderState extends State<TextSlider> {
  int _currentIndex = 0;
  late Timer _timer;

  final List<String> _texts = [
    "The best streaming anime app of the century to entertain you every day",
    "Discover thousands of anime titles from classics to the latest releases",
    "Watch your favorite anime anytime, anywhere with our easy-to-use interface",
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    // Create a timer that fires every 2.5 seconds
    _timer = Timer.periodic(const Duration(milliseconds: 2500), (timer) {
      setState(() {
        // Move to next index or loop back to start
        _currentIndex = (_currentIndex + 1) % _texts.length;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: Text(
            key: ValueKey<int>(_currentIndex),
            _texts[_currentIndex],
            textAlign: TextAlign.center,
            style: AppTextStyles.button,
          ),
        ),
        const SizedBox(height: 24),
        SliderIndicator(
          itemCount: _texts.length,
          currentIndex: _currentIndex,
          selectedColor: AppColors.primaryDark,
          unselectedColor: Colors.white,
        ),
      ],
    );
  }
}
