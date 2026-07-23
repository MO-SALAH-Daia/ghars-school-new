import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghars_school/shared/side_menu/custom_zoom/custom_zoom.dart';
import 'package:ghars_school/shared/side_menu/drawer/drawer_widget.dart';

import '../../app_core/app_core.dart';

class MainAppBar extends StatelessWidget {
  final bool hasCartBtn, hasNotificationBtn, hasDrawerBtn;
  final String? title;
  final VoidCallback? onBackBtnClicked,
      onDrawerBtnClicked,
      onNotificationsBtnClicked,
      onCartBtnClicked;
  const MainAppBar({
    super.key,
    this.hasCartBtn = false,
    this.hasNotificationBtn = false,
    this.hasDrawerBtn = false,
    this.title,
    this.onBackBtnClicked,
    this.onDrawerBtnClicked,
    this.onNotificationsBtnClicked,
    this.onCartBtnClicked,
  });

  /// defaultOnBackBtnClicked
  _defaultOnBackBtnClicked(context) {
    Navigator.of(context).pop();
  }

  /// defaultOnNotificationsBtnClicked

  /// defaultOnDrawerBtnClicked
  _defaultOnDrawerBtnClicked(context) {
    innerNotifier.value = locator<PrefsService>().appLanguage;
    ZoomDrawer.of(context)?.toggle();
  }

  _defaultOnNotificationsBtnClicked(context) {
    // Navigator.of(context).pushNamed(AppRoutesNames.NOTIFICATIONS_PAGE);
  }

  /// DefaultOnCartBtnClicked
  _defaultOnCartBtnClicked(context) {
    // Navigator.of(context).pushNamed(
    //   AppRoutesNames.CART_PAGE,
    //   arguments: CartArgs(),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
      actionsIconTheme: const IconThemeData(color: Colors.white),
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16.0, sigmaY: 16.0),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppStyle.appColor.withValues(alpha: 0.85),
                  AppStyle.blueCyan.withValues(alpha: 0.85),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              border: Border(
                bottom: BorderSide(
                  color: Colors.white.withValues(alpha: 0.25),
                  width: 1.2,
                ),
              ),
            ),
          ),
        ),
      ),
      leading: hasDrawerBtn
          ? IconButton(
              icon: const Icon(Icons.menu_rounded),
              onPressed:
                  onDrawerBtnClicked ??
                  () {
                    _defaultOnDrawerBtnClicked(context);
                  },
            )
          : IconButton(
              icon: Icon(Icons.arrow_back_ios, size: 18.sp),
              onPressed:
                  onBackBtnClicked ??
                  () {
                    _defaultOnBackBtnClicked(context);
                  },
            ),
      title: title == null
          ? SizedBox(
              width: 55,
              child: Image.asset(AppAssets.logoPng, fit: BoxFit.fill),
            )
          : Text(
              title!,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
                fontFamily: 'Cairo',
              ),
            ),
      actions: [
        if (hasNotificationBtn)
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed:
                onNotificationsBtnClicked ??
                () {
                  _defaultOnNotificationsBtnClicked(context);
                },
          ),
      ],
    );
  }
}
