import 'package:flutter/material.dart';
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
    // Scaffold.of(context).openDrawer();
    innerNotifier.value = locator<PrefsService>().appLanguage;
    ZoomDrawer.of(context)?.toggle();

    /// TODO: Implement DefaultOnDrawerBtnClicked
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
    // final cartCountManager = context.use<CartCountManager>();
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
      actionsIconTheme: const IconThemeData(color: Colors.white),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppStyle.appColor, AppStyle.blueCyan],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
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
              icon: const Icon(Icons.arrow_back_ios),
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
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
      actions: [
        if (hasNotificationBtn)
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed:
                onNotificationsBtnClicked ??
                () {
                  _defaultOnNotificationsBtnClicked(context);
                },
          ),
        // if (hasCartBtn)
        // ValueListenableBuilder<int>(
        //     valueListenable: cartCountManager.cartCountNotifier,
        //     builder: (context, value, _) {
        //       return IconButton(
        //         icon:  badges.Badge(
        //           showBadge: value > 0,
        //
        //           badgeStyle: badges.BadgeStyle(
        //             badgeColor: Colors.grey[800]!,
        //           ),
        //           badgeAnimation:const badges.BadgeAnimation.scale(
        //             animationDuration: Duration(seconds: 1),
        //             colorChangeAnimationDuration: Duration(seconds: 1),
        //             loopAnimation: false,
        //             curve: Curves.fastOutSlowIn,
        //             colorChangeAnimationCurve: Curves.easeInCubic,
        //           ),
        //           // animationType: BadgeAnimationType.scale,
        //           badgeContent: Text('$value',
        //               style: const TextStyle(color: Colors.white)),
        //           child: const Icon(
        //             Icons.shopping_cart,
        //             color: AppStyle.begooOrange,
        //           ),
        //         ),
        //         onPressed: onCartBtnClicked ??
        //             () {
        //               _defaultOnCartBtnClicked(context);
        //             },
        //       );
        //     }),
      ],
    );
  }
}
