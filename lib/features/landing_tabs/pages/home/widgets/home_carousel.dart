import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghars_school/app_core/resources/app_style/app_style.dart';
import 'package:ghars_school/features/landing_tabs/pages/home/models/gallery_image_model.dart';

class HomeCarousel extends StatefulWidget {
  final List<ImagesGallery> images;

  const HomeCarousel({super.key, required this.images});

  @override
  State<HomeCarousel> createState() => _HomeCarouselState();
}

class _HomeCarouselState extends State<HomeCarousel> {
  final PageController _carouselController = PageController(
    viewportFraction: 0.9,
  );
  int _carouselIndex = 0;
  Timer? _carouselTimer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    if (_carouselTimer == null && widget.images.length > 1) {
      _carouselTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
        if (_carouselController.hasClients) {
          int nextIndex = _carouselIndex + 1;
          if (nextIndex >= widget.images.length) {
            nextIndex = 0;
          }
          _carouselController.animateToPage(
            nextIndex,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _carouselTimer?.cancel();
    _carouselController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        SizedBox(
          height: 160.h,
          child: PageView.builder(
            controller: _carouselController,
            itemCount: widget.images.length,
            onPageChanged: (index) {
              setState(() {
                _carouselIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final img = widget.images[index];
              return AnimatedBuilder(
                animation: _carouselController,
                builder: (context, child) {
                  double value = 1.0;
                  if (_carouselController.position.haveDimensions) {
                    value = (_carouselController.page ?? 0) - index;
                    value = (1 - (value.abs() * 0.15)).clamp(0.0, 1.0);
                  }
                  return Center(
                    child: SizedBox(
                      height: Curves.easeOut.transform(value) * 160.h,
                      width: Curves.easeOut.transform(value) * double.infinity,
                      child: child,
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 8.r,
                        offset: Offset(0, 4.h),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: () {
                    final imageUrl = img.imageFile ?? '';
                    final isValid =
                        imageUrl.startsWith('http://') ||
                        imageUrl.startsWith('https://');
                    if (!isValid) {
                      return Container(
                        color: Colors.grey[100],
                        child: Icon(
                          Icons.broken_image,
                          size: 40.sp,
                          color: Colors.grey[400],
                        ),
                      );
                    }
                    return CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[200],
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[100],
                        child: Icon(
                          Icons.broken_image,
                          size: 40.sp,
                          color: Colors.grey[400],
                        ),
                      ),
                    );
                  }(),
                ),
              );
            },
          ),
        ),
        if (widget.images.length > 1) ...[
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.images.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: EdgeInsets.symmetric(horizontal: 3.w),
                width: _carouselIndex == index ? 16.w : 6.w,
                height: 6.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3.r),
                  color: _carouselIndex == index
                      ? AppStyle.appColor
                      : AppStyle.greyLight,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
