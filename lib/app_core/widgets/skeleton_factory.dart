import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

enum ObserverSkeletonType { none, list, grid, card, detail, home }

class SkeletonConfig {
  final ObserverSkeletonType type;
  final int itemCount;

  const SkeletonConfig({required this.type, this.itemCount = 6});
}

class SkeletonFactory extends StatelessWidget {
  final List<SkeletonConfig> configs;

  const SkeletonFactory({super.key, required this.configs});

  @override
  Widget build(BuildContext context) {
    if (configs.isEmpty ||
        configs.any((c) => c.type == ObserverSkeletonType.none)) {
      return const SizedBox.shrink();
    }

    return Skeletonizer(
      enabled: true,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: configs
              .map((config) => _buildSkeletonByConfig(context, config))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildSkeletonByConfig(BuildContext context, SkeletonConfig config) {
    final type = config.type;
    final itemCount = config.itemCount;
    switch (type) {
      case ObserverSkeletonType.list:
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          itemCount: itemCount,
          itemBuilder: (context, index) => Padding(
            padding: EdgeInsets.only(bottom: 15.h),
            child: Row(
              children: [
                const Bone.circle(size: 50),
                SizedBox(width: 15.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Bone.text(),
                      SizedBox(height: 8.h),
                      Bone.text(width: 150.w),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );

      case ObserverSkeletonType.grid:
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(16.w),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 15.h,
            crossAxisSpacing: 15.w,
            childAspectRatio: 0.85,
          ),
          itemCount: itemCount,
          itemBuilder: (context, index) => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Bone.square(borderRadius: BorderRadius.circular(12.r)),
                ),
                Padding(
                  padding: EdgeInsets.all(8.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Bone.text(),
                      SizedBox(height: 5.h),
                      Bone.text(width: 60.w),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );

      case ObserverSkeletonType.card:
        return Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              itemCount,
              (index) => Card(
                margin: EdgeInsets.only(bottom: 15.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: const Bone.text(),
                ),
              ),
            ),
          ),
        );

      case ObserverSkeletonType.detail:
        return Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.r),
                ),
              ),
              SizedBox(height: 20.h),
              Container(
                height: 30.h,
                width: 200.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.r),
                ),
              ),
              SizedBox(height: 10.h),
              const Text('Loading content line 1...'),
              const Text('Loading content line 2...'),
              const Text('Loading content line 3...'),
              SizedBox(height: 30.h),
              Container(
                height: 50.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ],
          ),
        );

      case ObserverSkeletonType.home:
        return _buildHomeSkeleton(context);

      case ObserverSkeletonType.none:
        return const SizedBox.shrink();
    }
  }

  Widget _buildHomeSkeleton(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Slider Placeholder
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          child: SizedBox(
            height: 150.sp,
            child: Bone.square(borderRadius: BorderRadius.circular(20.r)),
          ),
        ),

        // Packages Section Placeholder
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Bone.text(width: 100.w),
              Bone.text(width: 50.w),
            ],
          ),
        ),
        SizedBox(
          height: 200.sp,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            separatorBuilder: (context, index) => SizedBox(width: 15.w),
            itemBuilder: (context, index) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 200.w,
                  height: 120.sp,
                  child: Bone.square(borderRadius: BorderRadius.circular(15.r)),
                ),
                SizedBox(height: 10.h),
                Bone.text(width: 180.w),
                SizedBox(height: 5.h),
                Bone.text(width: 120.w),
              ],
            ),
          ),
        ),

        // Restaurants Section Placeholder
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Bone.text(width: 120.w),
              Bone.text(width: 50.w),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: List.generate(
              2,
              (index) => Padding(
                padding: EdgeInsets.only(bottom: 15.h),
                child: Row(
                  children: [
                    Bone.square(
                      size: 80.sp,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    SizedBox(width: 15.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Bone.text(width: double.infinity),
                          SizedBox(height: 8.h),
                          Bone.text(width: 150.w),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
