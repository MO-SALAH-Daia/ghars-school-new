import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghars_school/app_core/app_core.dart';
import 'package:ghars_school/features/onboarding/why_ghars_page.dart';
import 'package:ghars_school/shared/side_menu/custom_zoom/custom_zoom.dart';
import 'package:ghars_school/shared/side_menu/drawer/drawer_item.dart';

class OnboardingDrawerWidget extends StatefulWidget {
  const OnboardingDrawerWidget({super.key});

  @override
  State<OnboardingDrawerWidget> createState() => _OnboardingDrawerWidgetState();
}

class _OnboardingDrawerWidgetState extends State<OnboardingDrawerWidget> {
  late final ValueNotifier<String> _langNotifier;

  @override
  void initState() {
    super.initState();
    _langNotifier = ValueNotifier<String>(locator<PrefsService>().appLanguage);
  }

  @override
  void dispose() {
    _langNotifier.dispose();
    super.dispose();
  }

  void _changeLanguage(String currentLang) {
    final String nextLang = currentLang == 'en' ? 'ar' : 'en';
    final appLangManager = locator<AppLanguageManager>();

    // Close the drawer before language change to prevent UI glitching during transition
    ZoomDrawer.of(context)?.close();

    appLangManager.changeLanguage(Locale(nextLang));
    locator<PrefsService>().appLanguage = nextLang;
    _langNotifier.value = nextLang;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xfff8faf6),
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xfff8faf6), Color(0xffedf4e8)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ValueListenableBuilder<String>(
              valueListenable: _langNotifier,
              builder: (context, lang, _) {
                final bool isAr = lang == 'ar';
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Drawer Header Logo
                      Container(
                        margin: EdgeInsets.only(top: 35.h, bottom: 16.h),
                        height: 90.h,
                        width: 90.w,
                        child: Image.asset(
                          AppAssets.logoPng,
                          fit: BoxFit.contain,
                        ),
                      ),

                      // Welcome Text
                      Text(
                        context.translate(AppStrings.welcome) ?? 'Welcome',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppStyle.twilight,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      SizedBox(
                        width: 150.w,
                        child: Text(
                          context.translate('welcomeToGhars') ?? 'Ghars School',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppStyle.lightGrey,
                          ),
                        ),
                      ),
                      Divider(
                        // height: 35.h,
                        color: Colors.grey.withOpacity(0.1),
                      ),

                      // Why Ghars?
                      DrawerItemWidget(
                        title: context.translate('whyGhars') ?? 'Why Ghars?',
                        icon: Icon(
                          Icons.info_outline_rounded,
                          color: AppStyle.appColor,
                          size: 20.sp,
                        ),
                        onClick: () {
                          ZoomDrawer.of(context)?.close();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const WhyGharsPage(),
                            ),
                          );
                        },
                      ),
                      // SizedBox(height: 10.h),

                      // Admission Form
                      DrawerItemWidget(
                        title:
                            context.translate('admissionForm') ??
                            'Admission Form',
                        icon: Icon(
                          Icons.assignment_turned_in_outlined,
                          color: AppStyle.appColor,
                          size: 20.sp,
                        ),
                        onClick: () {
                          ZoomDrawer.of(context)?.close();
                        },
                      ),
                      // SizedBox(height: 10.h),

                      // Language Toggle
                      DrawerItemWidget(
                        title: isAr ? 'English' : 'العربية',
                        icon: Icon(
                          Icons.language_rounded,
                          color: AppStyle.appColor,
                          size: 20.sp,
                        ),
                        onClick: () {
                          _changeLanguage(lang);
                        },
                      ),
                      // SizedBox(height: 10.h),

                      // Login
                      DrawerItemWidget(
                        title: context.translate(AppStrings.login) ?? 'Login',
                        icon: Icon(
                          Icons.login_rounded,
                          color: AppStyle.appColor,
                          size: 20.sp,
                        ),
                        onClick: () {
                          ZoomDrawer.of(context)?.close();
                          Navigator.of(
                            context,
                          ).pushNamed(AppRoutesNames.loginPage);
                        },
                      ),
                      // SizedBox(height: 40.h),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
