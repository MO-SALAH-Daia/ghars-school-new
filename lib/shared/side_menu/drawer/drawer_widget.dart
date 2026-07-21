import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghars_school/shared/side_menu/custom_zoom/custom_zoom.dart';
import 'package:ghars_school/shared/side_menu/drawer/drawer_item.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app_core/app_core.dart';

/*
Created by: Mohammad Salah
Date: Monday 07 March 2022
*/

AnimationController? innerController;

final ValueNotifier<String> innerNotifier = ValueNotifier<String>(
  locator<PrefsService>().appLanguage,
);

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  ValueNotifier<DrawerState>? _stateNotifier;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final state = ZoomDrawer.of(context)?.stateNotifier;
    if (state != _stateNotifier) {
      _stateNotifier?.removeListener(_onStateChanged);
      _stateNotifier = state;
      _stateNotifier?.addListener(_onStateChanged);
    }
  }

  @override
  void dispose() {
    _stateNotifier?.removeListener(_onStateChanged);
    super.dispose();
  }

  void _onStateChanged() {
    final state = _stateNotifier?.value;
    if (state == DrawerState.opening) {
      innerController?.forward();
    } else if (state == DrawerState.closing) {
      innerController?.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final prefs = context.use<PrefsService>();
    // final appSettings = context.use<AppSettingsManager>();
    // final mainTabsManager = context.use<MainTabsManager>();

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
              valueListenable: innerNotifier,
              builder: (context, lang, _) {
                final contentWidget = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                        top: 35,
                        bottom: 15,
                        left: 35,
                        right: 35,
                      ),
                      height: 90.w,
                      width: 90.w,
                      child: Image.asset(
                        AppAssets.logoPng,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 5),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        prefs.userObj != null
                            ? '${prefs.userObj?.name} \n${prefs.userObj?.email}'
                            : '${context.translate(AppStrings.registerThrough)}',
                        style: TextStyle(
                          color: AppStyle.twilight,
                          fontSize: 14.sp,
                          height: 1.3,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    // if (prefs.userObj != null)
                    //   Padding(
                    //     padding: const EdgeInsets.symmetric(horizontal: 35.0),
                    //     child: Text(
                    //       '${prefs.userObj?.email}',
                    //       style: TextStyle(
                    //         color: Colors.white,
                    //         fontSize: 13.sp,
                    //       ),
                    //     ),
                    //   ),
                    const SizedBox(height: 20),
                    DrawerItemWidget(
                      title: '${context.translate(AppStrings.home)}',
                      // icon: SvgPicture.asset(
                      //   AppAssets.HOME_SVG,
                      //   // height: 14.sp,
                      //   color: AppStyle.begooOrange,
                      // ),
                      icon: Icon(
                        // FontAwesomeIcons.home,
                        Icons.home,
                        color: AppStyle.appColor,
                      ),
                      onClick: () {
                        ZoomDrawer.of(context)?.close();
                      },
                    ),
                    if (prefs.userObj != null)
                      DrawerItemWidget(
                        title: '${context.translate(AppStrings.myAccount)}',
                        // icon: SvgPicture.asset(
                        //   AppAssets.HOME_SVG,
                        //   // height: 14.sp,
                        //   color: AppStyle.begooOrange,
                        // ),
                        icon: Icon(
                          // FontAwesomeIcons.home,
                          Icons.person,
                          color: AppStyle.appColor,
                        ),
                        onClick: () {
                          ZoomDrawer.of(context)?.close();
                          // Navigator.of(context)
                          //     .pushNamed(AppRoutesNames.PROFILE_PAGE);
                        },
                      ),
                    DrawerItemWidget(
                      title: '${context.translate(AppStrings.search)}',
                      icon: Icon(
                        // FontAwesomeIcons.shoppingBag,
                        Icons.shopping_bag,
                        color: AppStyle.appColor,
                      ),
                      onClick: () {
                        ZoomDrawer.of(context)?.close();
                        // Navigator.of(context)
                        //     .pushNamed(AppRoutesNames.MY_ORDERS_PAGE);
                      },
                    ),
                    DrawerItemWidget(
                      title: '${context.translate(AppStrings.discount)}',
                      // icon: const Icon(
                      //   // FontAwesomeIcons.percentage ,
                      //   Icons.discount_sharp,
                      // ),
                      icon: Icon(
                        // FontAwesomeIcons.percentage ,
                        Icons.settings,
                        color: AppStyle.appColor,
                      ),
                      onClick: () {
                        ZoomDrawer.of(context)?.close();
                        // mainTabsManager.isFromAds = true;
                      },
                    ),
                    // DrawerItemWidget(
                    //     title: '${context.translate(AppStrings.CouponCodes)}',
                    //     icon: const Icon(
                    //       // FontAwesomeIcons.briefcase,
                    //       Icons.discount,
                    //       color: AppStyle.begooOrange,
                    //     ),
                    //     onClick: () {
                    //       ZoomDrawer.of(context)?.close();
                    //     }),
                    DrawerItemWidget(
                      title: '${context.translate(AppStrings.wallet)}',
                      icon: Icon(Icons.wallet, color: AppStyle.appColor),
                      onClick: () {
                        ZoomDrawer.of(context)?.close();
                        // Navigator.of(context)
                        //     .pushNamed(AppRoutesNames.MyWalletPage);
                      },
                    ),
                    DrawerItemWidget(
                      title: '${context.translate(AppStrings.contactUs)}',
                      icon: Icon(
                        // FontAwesomeIcons.chalkboardTeacher,
                        Icons.chat_bubble,
                        color: AppStyle.appColor,
                      ),
                      onClick: () {
                        ZoomDrawer.of(context)?.close();
                        // Navigator.of(context)
                        //     .pushNamed(AppRoutesNames.ContactUsPage);
                      },
                    ),
                    DrawerItemWidget(
                      title: '${context.translate(AppStrings.notifications)}',
                      icon: Icon(Icons.notifications, color: AppStyle.appColor),
                      onClick: () {
                        ZoomDrawer.of(context)?.close();
                        // Navigator.of(context)
                        //     .pushNamed(AppRoutesNames.NOTIFICATIONS_PAGE);
                      },
                    ),
                    const SizedBox(height: 30),
                    Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      margin: const EdgeInsets.only(
                        bottom: 50,
                        top: 50,
                        left: 20,
                        right: 20,
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          backgroundColor: AppStyle.appColor,
                          shadowColor: AppStyle.appColor,
                          // fixedSize: const Size.fromWidth(120),
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 30,
                          ),
                        ),
                        child: Text(
                          '${context.translate(prefs.userObj != null ? AppStrings.logout : AppStrings.login)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        onPressed: () {
                          // if (prefs.userObj != null) {
                          //   logoutFirstDialog(context, onClickLoginBtn: () {
                          //     prefs.removeUserObj();
                          //     googleSignInService.signOut();
                          //     facebookSignInService.logout();
                          //     appSettings.refreshCartCount();
                          //
                          //     _fcm.unsubscribeFromTopic('IosEn${prefs.currencyId}');
                          //     _fcm.unsubscribeFromTopic('IosAr${prefs.currencyId}');
                          //     _fcm.unsubscribeFromTopic(
                          //         'AndroidEn${prefs.currencyId}');
                          //     _fcm.unsubscribeFromTopic(
                          //         'AndroidAr${prefs.currencyId}');
                          //
                          //     if (Platform.isIOS) {
                          //       _fcm.subscribeToTopic('IOS');
                          //     } else if (Platform.isAndroid) {
                          //       _fcm.subscribeToTopic('Android');
                          //     }
                          //
                          //     Navigator.of(context).pushNamedAndRemoveUntil(
                          //         AppRoutesNames.LoginPage,
                          //         (Route<dynamic> route) => false);
                          //   }, onClickCancelBtn: () {
                          //     Navigator.of(context).pop();
                          //   });
                          // } else {
                          //   Navigator.of(context).pushNamedAndRemoveUntil(
                          //       AppRoutesNames.LoginPage,
                          //       (Route<dynamic> route) => false);
                          // }
                        },
                      ),
                    ),
                  ],
                );

                return lang == "en"
                    ? SlideInLeft(
                        manualTrigger: true,
                        controller: (controller) =>
                            innerController = controller,
                        duration: const Duration(milliseconds: 500),
                        child: contentWidget,
                      )
                    : SlideInRight(
                        manualTrigger: true,
                        controller: (controller) =>
                            innerController = controller,
                        duration: const Duration(milliseconds: 500),
                        child: contentWidget,
                      );
              },
            ),
          ),
        ),
      ),
    );
  }
}
