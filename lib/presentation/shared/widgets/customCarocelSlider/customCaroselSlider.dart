import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../infrastructure/theme/app_colors.dart';

class AutoCarouselSlider extends StatefulWidget {
  final List<String> images;
  final double height;
  final double aspectRatio;
  final Duration autoPlayInterval;
  final Duration animationDuration;
  final Curve animationCurve;
  final bool showIndicators;
  final Color activeIndicatorColor;
  final Color inactiveIndicatorColor;
  final double indicatorSize;
  final double activeIndicatorSize;
  final EdgeInsets indicatorPadding;
  final BoxFit imageFit;
  final BorderRadius borderRadius;
  final Widget Function(BuildContext, int, String)? customImageBuilder;
  final Function(int)? onPageChanged;
  final Color loadingIndicatorColor;
  final Color loadingBackgroundColor;

  const AutoCarouselSlider({
    super.key,
    required this.images,
    this.height = 220,
    this.aspectRatio = 16 / 9,
    this.autoPlayInterval = const Duration(seconds: 5),
    this.animationDuration = const Duration(milliseconds: 350),
    this.animationCurve = Curves.easeInOut,
    this.showIndicators = true,
    this.activeIndicatorColor = Colors.blue,
    this.inactiveIndicatorColor = Colors.grey,
    this.indicatorSize = 8,
    this.activeIndicatorSize = 8,
    this.indicatorPadding = const EdgeInsets.symmetric(horizontal: 4),
    this.imageFit = BoxFit.cover,
    this.borderRadius = BorderRadius.zero,
    this.customImageBuilder,
    this.onPageChanged,
    this.loadingIndicatorColor = AppColors.primaryNormal,
    this.loadingBackgroundColor = Colors.grey,
  });

  @override
  State<AutoCarouselSlider> createState() => _AutoCarouselSliderState();
}

class _AutoCarouselSliderState extends State<AutoCarouselSlider> {
  late final PageController _pageController;
  late int _currentPage;
  Timer? _timer;
  final Set<int> _loadedImages = {};

  @override
  void initState() {
    super.initState();
    _currentPage = 0;
    _pageController = PageController();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer?.cancel();
    _timer = Timer.periodic(widget.autoPlayInterval, (timer) {
      if (_currentPage < widget.images.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: widget.animationDuration,
          curve: widget.animationCurve,
        );
      }
    });
  }

  void _handlePageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
    if (widget.onPageChanged != null) {
      widget.onPageChanged!(index);
    }
  }

  void _onImageLoaded(int index) {
    setState(() {
      _loadedImages.add(index);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Carousel Container
        SizedBox(
          height: widget.height.h,
          width: double.infinity,
          child: ClipRRect(
            borderRadius: widget.borderRadius,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: _handlePageChanged,
              itemCount: widget.images.length,
              itemBuilder: (context, index) {
                if (widget.customImageBuilder != null) {
                  return widget.customImageBuilder!(
                    context,
                    index,
                    widget.images[index],
                  );
                }

                return Container(
                  width: double.infinity,
                  color: widget.loadingBackgroundColor.withOpacity(0.1),
                  child: Stack(
                    children: [
                      // Image with loading state
                      Image.network(
                        widget.images[index],
                        width: double.infinity,
                        height: double.infinity,
                        fit: widget.imageFit,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            // Image has loaded
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _onImageLoaded(index);
                            });
                            return child;
                          }

                          // Show loading indicator
                          return Container(
                            width: double.infinity,
                            height: double.infinity,
                            color: widget.loadingBackgroundColor.withOpacity(0.1),
                            child: Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                    : null,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  widget.loadingIndicatorColor,
                                ),
                                strokeWidth: 3.0,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: double.infinity,
                            height: double.infinity,
                            color: widget.loadingBackgroundColor.withOpacity(0.1),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 48.r,
                                  color: Colors.red,
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  'Failed to load image',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      // Gradient overlay (only show when image is loaded)
                      if (_loadedImages.contains(index))
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.3),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),

        if (widget.showIndicators) ...[
          SizedBox(height: 16.h),
          // Dot Indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.images.length,
                  (index) => Padding(
                padding: widget.indicatorPadding,
                child: AnimatedContainer(
                  duration: widget.animationDuration,
                  height: widget.indicatorSize.h,
                  width:
                  _currentPage == index
                      ? widget.activeIndicatorSize.w
                      : widget.indicatorSize.w,
                  decoration: BoxDecoration(
                    color:
                    _currentPage == index
                        ? widget.activeIndicatorColor
                        : widget.inactiveIndicatorColor,
                    borderRadius: BorderRadius.circular(widget.indicatorSize.r),
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}