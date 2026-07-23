import 'dart:async';
import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghars_school/app_core/app_core.dart';
import 'package:ghars_school/features/onboarding/why_ghars_page.dart';
import 'package:ghars_school/shared/side_menu/custom_zoom/custom_zoom.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late final PageController _carouselController1;
  late final PageController _carouselController2;
  int _carouselIndex1 = 0;
  int _carouselIndex2 = 0;
  Timer? _timer1;
  Timer? _timer2;

  final List<String> _sliderImages1 = [
    'assets/images/g (1).jpeg',
    'assets/images/g (2).jpeg',
    'assets/images/g (3).jpeg',
    'assets/images/g (4).jpeg',
    'assets/images/g (5).jpeg',
    'assets/images/g (6).jpeg',
    'assets/images/g (7).jpeg',
    'assets/images/g (8).jpeg',
    'assets/images/g (9).jpeg',
  ];

  final List<String> _sliderImages2 = [
    'assets/images/g (10).jpeg',
    'assets/images/g (11).jpeg',
    'assets/images/g (12).jpeg',
    'assets/images/g (14).jpeg',
    'assets/images/g (15).jpeg',
    'assets/images/g (16).jpeg',
    'assets/images/g (17).jpeg',
    'assets/images/g (18).jpeg',
    'assets/images/g (19).jpeg',
    'assets/images/g (20).jpeg',
    'assets/images/g (21).jpeg',
    'assets/images/g (22).jpeg',
  ];

  @override
  void initState() {
    super.initState();
    _carouselController1 = PageController(initialPage: 0);
    _carouselController2 = PageController(initialPage: 0);

    // Auto play timers
    _timer1 = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_carouselIndex1 < _sliderImages1.length - 1) {
        _carouselIndex1++;
      } else {
        _carouselIndex1 = 0;
      }
      if (_carouselController1.hasClients) {
        _carouselController1.animateToPage(
          _carouselIndex1,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
        );
      }
    });

    _timer2 = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_carouselIndex2 < _sliderImages2.length - 1) {
        _carouselIndex2++;
      } else {
        _carouselIndex2 = 0;
      }
      if (_carouselController2.hasClients) {
        _carouselController2.animateToPage(
          _carouselIndex2,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer1?.cancel();
    _timer2?.cancel();
    _carouselController1.dispose();
    _carouselController2.dispose();
    super.dispose();
  }

  void _openImageZoom(String assetPath) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: Stack(
            alignment: Alignment.center,
            children: [
              GestureDetector(
                onTap: () => Navigator.of(dialogContext).pop(),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black.withOpacity(0.9),
                ),
              ),
              InteractiveViewer(
                panEnabled: true,
                minScale: 0.5,
                maxScale: 4.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.asset(assetPath, fit: BoxFit.contain),
                ),
              ),
              Positioned(
                top: 40.h,
                right: 20.w,
                child: IconButton(
                  icon: const Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () => Navigator.of(dialogContext).pop(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBentoCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color iconColor,
    required bool isWide,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: color.withOpacity(0.15), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: 15.r,
                backgroundColor: color.withOpacity(0.12),
                child: Icon(icon, color: iconColor, size: 16.sp),
              ),
              if (isWide)
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: iconColor.withOpacity(0.4),
                  size: 12.sp,
                ),
            ],
          ),
          SizedBox(height: 6.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.bold,
                  color: AppStyle.twilight,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 2.h),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 9.sp,
                  color: AppStyle.lightGrey,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isAr = locator<PrefsService>().appLanguage == 'ar';
    final appLanguage = locator<AppLanguageManager>();
    final prefs = locator<PrefsService>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Glow Decoration
          Positioned(
            top: -100.h,
            right: -100.w,
            child: Container(
              width: 320.w,
              height: 320.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppStyle.blueCyan.withOpacity(0.06),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
          Positioned(
            top: 250.h,
            left: -150.w,
            child: Container(
              width: 350.w,
              height: 350.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppStyle.appColor.withOpacity(0.05),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),

          // Main Content
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                // Custom App Bar
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Hamburger Menu Button
                      GestureDetector(
                        onTap: () {
                          ZoomDrawer.of(context)?.toggle();
                        },
                        child: CircleAvatar(
                          radius: 20.r,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.menu_rounded,
                            color: AppStyle.appColor,
                            size: 24.sp,
                          ),
                        ),
                      ),
                      // Small School Logo
                      Image.asset(
                        AppAssets.logoPng,
                        height: 45.h,
                        fit: BoxFit.contain,
                      ),
                      // Language Switcher
                      GestureDetector(
                        onTap: () {
                          final String nextLang = isAr ? 'en' : 'ar';
                          appLanguage.changeLanguage(Locale(nextLang));
                          prefs.appLanguage = nextLang;
                          setState(() {});
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: AppStyle.appColor.withOpacity(0.15),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.language_rounded,
                                color: AppStyle.appColor,
                                size: 16.sp,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                isAr ? 'EN' : 'العربية',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppStyle.appColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Scrollable Body
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(bottom: 100.h),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10.h),

                          // Welcome Section
                          FadeInDown(
                            duration: const Duration(milliseconds: 600),
                            child: Text(
                              context.translate(AppStrings.welcome) ??
                                  'Welcome',
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: AppStyle.twilight,
                              ),
                            ),
                          ),
                          FadeInDown(
                            duration: const Duration(milliseconds: 700),
                            child: Text(
                              context.translate('welcomeToGhars') ??
                                  'Welcome to Ghars Bilingual School',
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: AppStyle.lightGrey,
                                height: 1.4,
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),

                          // Video Card Section
                          FadeInDown(
                            duration: const Duration(milliseconds: 800),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const WhyGharsPage(),
                                  ),
                                );
                              },
                              child: Card(
                                elevation: 0,
                                color: const Color(0xffedf4e8).withOpacity(0.5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.r),
                                  side: BorderSide(
                                    color: AppStyle.appColor.withOpacity(0.1),
                                  ),
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(16.r),
                                  child: Row(
                                    children: [
                                      // Image Thumbnail with Play Overlay
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              12.r,
                                            ),
                                            child: Image.asset(
                                              'assets/images/g (1).jpeg',
                                              width: 100.w,
                                              height: 65.h,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          CircleAvatar(
                                            radius: 16.r,
                                            backgroundColor: AppStyle.appColor
                                                .withOpacity(0.9),
                                            child: Icon(
                                              Icons.play_arrow_rounded,
                                              color: Colors.white,
                                              size: 20.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 14.w),
                                      // Text
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              context.translate('whyGhars') ??
                                                  'Why Ghars?',
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.bold,
                                                color: AppStyle.twilight,
                                              ),
                                            ),
                                            SizedBox(height: 4.h),
                                            Text(
                                              isAr
                                                  ? "شاهد الفيديو التعريفي واكتشف مناهج وقيم مدرسة غرس"
                                                  : "Watch our introductory video and discover Ghars values.",
                                              style: TextStyle(
                                                fontSize: 9.sp,
                                                color: AppStyle.lightGrey,
                                                height: 1.3,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 24.h),

                          // Bento Grid Highlights
                          Text(
                            context.translate('discoverGhars') ??
                                'Discover Ghars',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: AppStyle.twilight,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          FadeInUp(
                            duration: const Duration(milliseconds: 800),
                            child: GridView.count(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisCount: 2,
                              crossAxisSpacing: 12.w,
                              mainAxisSpacing: 12.h,
                              childAspectRatio: 1.1,
                              children: [
                                // Islamic values (Wide aspect feel via grid items)
                                GestureDetector(
                                  onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => const WhyGharsPage(),
                                    ),
                                  ),
                                  child: _buildBentoCard(
                                    title: isAr
                                        ? "التربية الإسلامية"
                                        : "Islamic Values",
                                    subtitle: isAr
                                        ? "عقيدة راسخة وحفظ القرآن الكريم"
                                        : "Solid Islamic values and Quran study.",
                                    icon: Icons.menu_book_rounded,
                                    color: AppStyle.appColor,
                                    iconColor: AppStyle.appColor,
                                    isWide: false,
                                  ),
                                ),
                                // American standard
                                GestureDetector(
                                  onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => const WhyGharsPage(),
                                    ),
                                  ),
                                  child: _buildBentoCard(
                                    title: isAr
                                        ? "المنهج الأمريكي"
                                        : "American Curriculum",
                                    subtitle: isAr
                                        ? "معايير CCS المعتمدة دولياً"
                                        : "Aligned with international CCS standards.",
                                    icon: Icons.school_rounded,
                                    color: AppStyle.blueCyan,
                                    iconColor: AppStyle.blueCyan,
                                    isWide: false,
                                  ),
                                ),
                                // Science NGSS
                                GestureDetector(
                                  onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => const WhyGharsPage(),
                                    ),
                                  ),
                                  child: _buildBentoCard(
                                    title: isAr
                                        ? "مناهج العلوم"
                                        : "Science NGSS",
                                    subtitle: isAr
                                        ? "مواكبة المعايير العلمية NGSS"
                                        : "Next Generation Science Standards.",
                                    icon: Icons.science_rounded,
                                    color: AppStyle.secondaryColor,
                                    iconColor: AppStyle.secondaryColor,
                                    isWide: false,
                                  ),
                                ),
                                // Safe environment
                                GestureDetector(
                                  onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => const WhyGharsPage(),
                                    ),
                                  ),
                                  child: _buildBentoCard(
                                    title: isAr
                                        ? "فصول غير مختلطة"
                                        : "Non-Mixed Classes",
                                    subtitle: isAr
                                        ? "بيئة تربوية آمنة لجميع المراحل"
                                        : "Safe, single-gender environment.",
                                    icon: Icons.gpp_good_rounded,
                                    color: AppStyle.mauve,
                                    iconColor: AppStyle.mauve,
                                    isWide: false,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 28.h),

                          // Who We Are & Gallery Carousel 1
                          Text(
                            context.translate('whoUs') ?? 'Who We Are',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: AppStyle.twilight,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            context.translate('whoUsDesc') ?? '',
                            style: TextStyle(
                              fontSize: 10.5.sp,
                              color: AppStyle.lightGrey,
                              height: 1.5,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          // Gallery Carousel 1
                          Container(
                            height: 170.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Stack(
                              children: [
                                PageView.builder(
                                  controller: _carouselController1,
                                  itemCount: _sliderImages1.length,
                                  onPageChanged: (index) {
                                    setState(() {
                                      _carouselIndex1 = index;
                                    });
                                  },
                                  itemBuilder: (context, index) {
                                    final imgPath = _sliderImages1[index];
                                    return GestureDetector(
                                      onTap: () => _openImageZoom(imgPath),
                                      child: Image.asset(
                                        imgPath,
                                        fit: BoxFit.cover,
                                      ),
                                    );
                                  },
                                ),
                                // Indicators overlay
                                Positioned(
                                  bottom: 12.h,
                                  left: 0,
                                  right: 0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(
                                      _sliderImages1.length,
                                      (index) => Container(
                                        margin: EdgeInsets.symmetric(
                                          horizontal: 3.w,
                                        ),
                                        width: _carouselIndex1 == index
                                            ? 16.w
                                            : 6.w,
                                        height: 6.w,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            3.r,
                                          ),
                                          color: _carouselIndex1 == index
                                              ? AppStyle.appColor
                                              : Colors.white.withOpacity(0.6),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 30.h),

                          // What We Do & Gallery Carousel 2
                          Text(
                            context.translate('whatWEDo') ?? 'What We Do',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: AppStyle.twilight,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            context.translate('whatWeDoDesc') ?? '',
                            style: TextStyle(
                              fontSize: 10.5.sp,
                              color: AppStyle.lightGrey,
                              height: 1.5,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          // Gallery Carousel 2
                          Container(
                            height: 170.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Stack(
                              children: [
                                PageView.builder(
                                  controller: _carouselController2,
                                  itemCount: _sliderImages2.length,
                                  onPageChanged: (index) {
                                    setState(() {
                                      _carouselIndex2 = index;
                                    });
                                  },
                                  itemBuilder: (context, index) {
                                    final imgPath = _sliderImages2[index];
                                    return GestureDetector(
                                      onTap: () => _openImageZoom(imgPath),
                                      child: Image.asset(
                                        imgPath,
                                        fit: BoxFit.cover,
                                      ),
                                    );
                                  },
                                ),
                                // Indicators overlay
                                Positioned(
                                  bottom: 12.h,
                                  left: 0,
                                  right: 0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(
                                      _sliderImages2.length,
                                      (index) => Container(
                                        margin: EdgeInsets.symmetric(
                                          horizontal: 3.w,
                                        ),
                                        width: _carouselIndex2 == index
                                            ? 16.w
                                            : 6.w,
                                        height: 6.w,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            3.r,
                                          ),
                                          color: _carouselIndex2 == index
                                              ? AppStyle.appColor
                                              : Colors.white.withOpacity(0.6),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Sticky Glass Bottom Action Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: EdgeInsets.only(
                    left: 20.w,
                    right: 20.w,
                    top: 15.h,
                    bottom: 25.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    border: Border(
                      top: BorderSide(
                        color: Colors.black.withOpacity(0.05),
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Log In Button (Primary)
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppStyle.appColor,
                            elevation: 2,
                            shadowColor: AppStyle.appColor.withOpacity(0.4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                          ),
                          onPressed: () {
                            Navigator.of(
                              context,
                            ).pushNamed(AppRoutesNames.loginPage);
                          },
                          child: Text(
                            context.translate(AppStrings.login) ?? 'Log In',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      // Admission Form Button (Secondary Outline)
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: AppStyle.appColor,
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                          ),
                          onPressed: () {},
                          child: Text(
                            context.translate('admissionForm') ??
                                'Admission Form',
                            style: TextStyle(
                              color: AppStyle.appColor,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
