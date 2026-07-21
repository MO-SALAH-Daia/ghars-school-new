import 'package:flutter/material.dart';

import '../../app_core/app_core.dart';
import 'custom_zoom/custom_zoom.dart';
// import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

/*
Created by: Mohammad Salah
Date: Monday 07 March 2022
*/
class ContainerPageWithDrawer extends StatelessWidget {
  final Widget mainScreen, menuScreen;
  const ContainerPageWithDrawer({
    super.key,
    required this.mainScreen,
    required this.menuScreen,
  });

  @override
  Widget build(BuildContext context) {
    final prefs = context.use<PrefsService>();

    return ZoomDrawer(
      controller: locator<ZoomDrawerController>(),
      style: DrawerStyle.style1,
      openCurve: Curves.fastOutSlowIn,
      // closeCurve: Curves.easeInOutCirc,
      slideWidth:
          MediaQuery.of(context).size.width *
          (prefs.appLanguage == 'en' ? 0.85 : 0.63),
      isRtl: prefs.appLanguage == 'ar',
      angle: -12,
      disableGesture: false,
      mainScreenTapClose: true,
      borderRadius: 20,
      duration: const Duration(milliseconds: 500),
      backgroundColor: AppStyle.appColor.shade300,
      showShadow: true,
      shadowLayer1Color: AppStyle.appColor.shade200,
      mainScreen: mainScreen,
      menuScreen: menuScreen,
      // mainScreen: const TabsWidget(key: Key('x')),
      // menuScreen: const DrawerWidget(key: Key('xx')),
    );
  }
}
