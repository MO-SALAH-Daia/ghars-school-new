import 'package:flutter/material.dart';

import '../../app_core/app_core.dart';
import 'custom_zoom/custom_zoom.dart';

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
    final appLangManager = locator<AppLanguageManager>();

    return ValueListenableBuilder<String>(
      valueListenable: appLangManager.langNotifier,
      builder: (context, lang, _) {
        return ZoomDrawer(
          key: ValueKey(lang),
          controller: locator<ZoomDrawerController>(),
          style: DrawerStyle.style1,
          openCurve: Curves.fastOutSlowIn,
          // closeCurve: Curves.easeInOutCirc,
          slideWidth:
              MediaQuery.of(context).size.width * (lang == 'en' ? 0.85 : 0.63),
          isRtl: lang == 'ar',
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
        );
      },
    );
  }
}
