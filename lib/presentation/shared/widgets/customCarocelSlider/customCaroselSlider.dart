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
  final String defaultAssetImage; // New parameter for default asset image

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
    this.defaultAssetImage = 'assets/images/default_placeholder.png', // Default asset path
  });

  @override
  State<AutoCarouselSlider> createState() => _AutoCarouselSliderState();
}

class _AutoCarouselSliderState extends State<AutoCarouselSlider> {
  late final PageController _pageController;
  late int _currentPage;
  Timer? _timer;
  final Set<int> _loadedImages = {};
  final Set<int> _failedImages = {};

  @override
  void initState() {
    super.initState();
    _currentPage = 0;
    _pageController = PageController();

    // Only start auto slide if there are images
    if (widget.images.isNotEmpty) {
      _startAutoSlide();
    }
  }

  void _startAutoSlide() {
    _timer?.cancel();
    _timer = Timer.periodic(widget.autoPlayInterval, (timer) {
      final totalItems = widget.images.isEmpty ? 1 : widget.images.length;

      if (_currentPage < totalItems - 1) {
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

  void _onImageFailed(int index) {
    setState(() {
      _failedImages.add(index);
    });
  }

  Widget _buildDefaultAssetImage() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Image.asset(
        widget.defaultAssetImage,
        width: double.infinity,
        height: double.infinity,
        fit: widget.imageFit,
        errorBuilder: (context, error, stackTrace) {
          // Fallback if even the asset image fails to load
          return Container(
            width: double.infinity,
            height: double.infinity,
            color: widget.loadingBackgroundColor.withOpacity(0.1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.image_not_supported,
                  size: 48.r,
                  color: Colors.grey,
                ),
                SizedBox(height: 8.h),
                Text(
                  'No image available',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNetworkImage(String imageUrl, int index) {
    return Container(
      width: double.infinity,
      color: widget.loadingBackgroundColor.withOpacity(0.1),
      child: Stack(
        children: [
          // Image with loading state
          Image.network(
            imageUrl,
            width: double.infinity,
            height: double.infinity,
            fit: widget.imageFit,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                // Image has loaded successfully
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
              // Mark this image as failed and return default asset image
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _onImageFailed(index);
              });
              return _buildDefaultAssetImage();
            },
          ),

          // Gradient overlay (only show when image is loaded and not failed)
          if (_loadedImages.contains(index) && !_failedImages.contains(index))
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
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // If no network images provided, show default asset image
    final bool hasNetworkImages = widget.images.isNotEmpty;
    final int itemCount = hasNetworkImages ? widget.images.length : 1;

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
              itemCount: itemCount,
              itemBuilder: (context, index) {
                // If custom image builder is provided
                if (widget.customImageBuilder != null && hasNetworkImages) {
                  return widget.customImageBuilder!(
                    context,
                    index,
                    widget.images[index],
                  );
                }

                // If no network images, show default asset image
                if (!hasNetworkImages) {
                  return _buildDefaultAssetImage();
                }

                // Show network image with fallback to default asset
                return _buildNetworkImage(widget.images[index], index);
              },
            ),
          ),
        ),

        if (widget.showIndicators && itemCount > 1) ...[
          SizedBox(height: 16.h),
          // Dot Indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              itemCount,
                  (index) => Padding(
                padding: widget.indicatorPadding,
                child: AnimatedContainer(
                  duration: widget.animationDuration,
                  height: widget.indicatorSize.h,
                  width: _currentPage == index
                      ? widget.activeIndicatorSize.w
                      : widget.indicatorSize.w,
                  decoration: BoxDecoration(
                    color: _currentPage == index
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