import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ghars_school/app_core/app_core.dart';
import 'package:ghars_school/shared/main_button/main_button_widget.dart';

enum ButtonsAlignment { center, end }

///////////////////////////////////////////////////////////////////////////////
/// Custom alert dialog.
/// ///////////////////////////////////////////////////////////////////////////
class AppDialog extends StatelessWidget {
  final String? firstBtnTxt, secondBtnTxt, description, svgImagePath, pngImage;
  final String? firstTitle, secondTitle;
  final VoidCallback? onClickFirstBtn, onClickSecondBtn, onClickCloseBtn;
  final Widget? child;
  final bool hasCloseButton;

  final ButtonsAlignment buttonsAlignment;
  final Color svgColor;
  final Color? pngColor;
  final Color firstBtnColor;
  final Color? firstBtnBorderColor;
  final Color secondBtnColor;
  final Color? secondBtnBorderColor;
  final Color firstBtnTxtColor;
  final Color secondBtnTxtColor;
  final double secondBtnElevation;
  final Color closeIconColor;
  final Color dialogColor;
  final double? dialogTopPadding;

  const AppDialog({
    super.key,
    this.firstBtnTxt,
    this.hasCloseButton = true,
    this.secondBtnTxt,
    this.firstTitle,
    this.secondTitle,
    this.secondBtnElevation = 0,
    this.description,
    this.svgImagePath,
    this.onClickFirstBtn,
    this.onClickSecondBtn,
    this.onClickCloseBtn,
    this.pngColor,
    this.child,
    required this.buttonsAlignment,
    this.svgColor = AppStyle.bayZeroColor,
    this.firstBtnColor = AppStyle.bayZeroColor,
    this.secondBtnColor = Colors.black,
    this.firstBtnTxtColor = Colors.white,
    this.secondBtnTxtColor = Colors.white,
    this.closeIconColor = Colors.black,
    this.pngImage,
    this.dialogColor = Colors.white,
    this.firstBtnBorderColor,
    this.secondBtnBorderColor,
    this.dialogTopPadding,
  });

  @override
  Widget build(BuildContext context) {
    // final prefs = context.use<PrefsService>();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  Widget dialogContent(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.only(top: 20.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(
                  bottom: 20,
                  top: dialogTopPadding ?? 70,
                  left: 16,
                  right: 16,
                ),
                decoration: BoxDecoration(
                  // color: AppStyle.appColor,
                  color: dialogColor,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(17),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10.0,
                      offset: Offset(0.0, 5.0),
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    children: <Widget>[
                      if (firstTitle == null) const SizedBox(height: 20),

                      /// Title
                      if (firstTitle != null)
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: svgImagePath != null ? 20 : 0,
                            right: 50,
                            left: 50,
                          ),
                          child: Text(
                            firstTitle!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.sp,
                            ),
                          ),
                        ),

                      if (child != null) child!,

                      /// SVG Image
                      if (child == null && svgImagePath != null)
                        JelloIn(
                          child: SvgPicture.asset(
                            '$svgImagePath',
                            height: 100,
                            // color: svgColor,
                          ),
                        ),

                      /// SecondTitle
                      if (secondTitle != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 24.0, bottom: 12),
                          child: Text(
                            '$secondTitle',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),

                      /// Description
                      if (child == null && description != null)
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 24.0,
                            // horizontal: 0,
                          ),
                          child: Text(
                            '$description',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12.sp,
                              color: Colors.grey,
                            ),
                          ),
                        ),

                      /// Buttons
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          mainAxisAlignment:
                              buttonsAlignment == ButtonsAlignment.center
                              ? MainAxisAlignment.center
                              : MainAxisAlignment.end,
                          children: <Widget>[
                            /// First Button
                            if (firstBtnTxt != null)
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: firstBtnBorderColor != null
                                        ? BorderSide(
                                            color: firstBtnBorderColor!,
                                            width: 1,
                                          )
                                        : BorderSide.none,
                                  ),
                                  backgroundColor: firstBtnColor,
                                  shadowColor: firstBtnColor,
                                  // fixedSize: Size.fromWidth(90.sp),
                                  fixedSize: Size.fromWidth(
                                    MediaQuery.sizeOf(context).width,
                                  ),
                                  padding:
                                      //     const EdgeInsets.symmetric(vertical: 3),
                                      const EdgeInsets.symmetric(
                                        vertical: 12,
                                        horizontal: 25,
                                      ),
                                ),
                                onPressed: onClickFirstBtn ?? () {},
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  child: Text(
                                    '$firstBtnTxt',
                                    style: TextStyle(
                                      color: firstBtnTxtColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ),
                              ),
                            if (firstBtnTxt != null) const SizedBox(height: 15),

                            /// Second Button
                            if (secondBtnTxt != null)
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: secondBtnBorderColor != null
                                        ? BorderSide(
                                            color: secondBtnBorderColor!,
                                            width: 1,
                                          )
                                        : BorderSide.none,
                                  ),
                                  backgroundColor: secondBtnColor,

                                  shadowColor: secondBtnColor,
                                  elevation: secondBtnElevation,
                                  fixedSize: Size.fromWidth(
                                    MediaQuery.sizeOf(context).width,
                                  ),
                                  // fixedSize: const Size.fromWidth(120),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                ),
                                onPressed: onClickSecondBtn ?? () {},
                                child: Text(
                                  '$secondBtnTxt',
                                  style: TextStyle(
                                    color: secondBtnTxtColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.sp,
                                  ),
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
          if (hasCloseButton)
            Positioned(
              left: locator<PrefsService>().appLanguage == 'ar' ? 10 : null,
              right: locator<PrefsService>().appLanguage == 'en' ? 10 : null,
              top: 30,
              child: IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(0),
                  // padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    // color: Colors.grey[100],
                    color: Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                  child: Icon(Icons.close, size: 25.sp, color: closeIconColor),
                ),
                onPressed:
                    onClickCloseBtn ??
                    () {
                      Navigator.of(context).pop();
                    },
              ),
            ),

          /// PNG Image
          Positioned(
            top: 0,
            left: 16,
            right: 16,
            child: pngImage != null
                ? Spin(
                    child: CircleAvatar(
                      // backgroundColor: AppStyle.appColor,
                      backgroundColor: dialogColor,
                      // foregroundColor: AppStyle.appColor,
                      // foregroundColor: AppStyle.appColor.withOpacity(0.8),
                      foregroundColor: dialogColor,
                      // backgroundImage: AssetImage(imageUrl),
                      radius: 40.sp,
                      // child: ClipOval(
                      child: Swing(
                        duration: const Duration(seconds: 5),
                        infinite: true,
                        child: Image.asset(
                          pngImage!,
                          fit: BoxFit.contain,
                          color: pngColor ?? AppStyle.appColor,
                          width: 40.sp,
                          height: 80.sp,
                        ),
                      ),
                    ),
                    // ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
/////////////////////////<<<App Dialogs>>>//////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// class CustomDialog extends StatlessWidget {
//   final String title;
//   final String content;
//   final String buttonText;
//   final VoidCallback onPressed;
//
//   CustomDialog({
//     required this.title,
//     required this.content,
//     required this.buttonText,
//     required this.onPressed,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text(title),
//       content: Text(content),
//       actions: <Widget>[
//         TextButton(
//           child: Text(buttonText),
//           onPressed: onPressed,
//         ),
//       ],
//     );
//   }
// }

//******************************************************************************

/// 1. logoutAndLoginDialog
enum DialogAction { login, logout, deleteAccount }

void logoutAndLoginDialogAndDeleteAccount(
  BuildContext context, {
  required VoidCallback onClickLogoutBtn,
  VoidCallback? onClickCloseBtn,
  VoidCallback? onClickContinueBtn,
  required DialogAction dialogAction,
}) {
  final PrefsService prefs = locator<PrefsService>();
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => FadeInUp(
      child: AppDialog(
        pngImage: AppAssets.logoPng,
        buttonsAlignment: ButtonsAlignment.center,
        firstBtnTxt: dialogAction == DialogAction.logout
            ? prefs.appLanguage == 'ar'
                  ? 'الخروج'
                  : 'Log out'
            : dialogAction == DialogAction.login
            ? prefs.appLanguage == 'ar'
                  ? 'تسجيل الدخول'
                  : 'log in'
            : prefs.appLanguage == 'ar'
            ? 'حذف'
            : 'Delete',
        firstBtnTxtColor: Colors.white,
        firstBtnColor: dialogAction == DialogAction.deleteAccount
            ? Colors.redAccent
            : AppStyle.appColor,
        closeIconColor: AppStyle.appColor,
        // firstBtnTxt: '${context.translate(AppStrings.send)}',
        // secondBtnTxt: 'الاستمرار',
        secondBtnTxtColor: Colors.black,
        secondBtnColor: AppStyle.grey,
        onClickSecondBtn: onClickContinueBtn,
        onClickFirstBtn: onClickLogoutBtn,

        hasCloseButton: true,
        onClickCloseBtn: onClickCloseBtn,
        child: WillPopScope(
          onWillPop: () async => false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Text(
                  dialogAction == DialogAction.logout
                      ? prefs.appLanguage == 'ar'
                            ? 'تسجيل الخروج'
                            : 'Log out'
                      : dialogAction == DialogAction.login
                      ? prefs.appLanguage == 'ar'
                            ? 'تسجيل الدخول'
                            : 'Log in'
                      : prefs.appLanguage == 'ar'
                      ? 'حذف الحساب'
                      : 'Delete account',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                    // color: AppStyle.appColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 5),
              // status
              //     ? Center(
              //         child: FaIcon(
              //           FontAwesomeIcons.circleCheck,
              //           color: AppStyle.orange,
              //           size: 40.sp,
              //         ),
              //       )
              //     : Center(
              //         child: FaIcon(
              //           FontAwesomeIcons.faceSadCry,
              //           color: AppStyle.orange,
              //           size: 40.sp,
              //         ),
              //       ),
              // // Icon(FontA),
              // const SizedBox(
              //   height: 15,
              // ),
              Center(
                child: Text(
                  dialogAction == DialogAction.logout
                      ? prefs.appLanguage == 'ar'
                            ? 'هل انت متأكد من رغبتك في تسجيل الخروج؟'
                            : 'Are you sure you want to log out?'
                      : dialogAction == DialogAction.login
                      ? prefs.appLanguage == 'ar'
                            ? 'يجب تسجيل الدخول للمتابعة'
                            : 'You must log in to continue'
                      : prefs.appLanguage == 'ar'
                      ? 'هل انت متأكد من رغبتك في حذف حسابك الشخصي.'
                      : 'Are you sure you want to delete your account?',
                  style: TextStyle(fontSize: 13.sp),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
        // onClickCloseBtn: onClickCloseBtn,
        // description: message ??
        //     '${context.translate(AppStrings.Are_you_ready_to_watch_the_training_video)}',
      ),
    ),
  );
}

//******************************************************************************

//******************************************************************************

void api401Dialog(
  BuildContext context, {
  required VoidCallback onClickConfirmBtn,
  VoidCallback? onClickCloseBtn,
  VoidCallback? onClickSecondBtn,
  required String errorMessage,
}) {
  final PrefsService prefs = locator<PrefsService>();
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => FadeInUp(
      child: AppDialog(
        pngImage: AppAssets.logoPng,
        buttonsAlignment: ButtonsAlignment.center,
        firstBtnTxt: prefs.appLanguage == 'ar' ? 'تسجيل الدخول' : 'Login',
        firstBtnTxtColor: Colors.white,
        firstBtnColor: AppStyle.appColor,
        onClickFirstBtn: onClickConfirmBtn,
        // secondBtnTxt: 'الاستمرار',
        secondBtnTxtColor: Colors.black,
        secondBtnColor: AppStyle.grey,
        onClickSecondBtn: onClickSecondBtn,

        hasCloseButton: false,
        closeIconColor: AppStyle.appColor,

        onClickCloseBtn: onClickCloseBtn,
        child: WillPopScope(
          onWillPop: () async => false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Text(
                  // errorMessage,
                  prefs.appLanguage == 'ar' ? 'خطأ' : 'Error',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                    // color: AppStyle.appColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 5),
              Center(
                child: Text(
                  errorMessage,
                  style: TextStyle(
                    fontSize: 13.sp,
                    // color: AppStyle.appColor
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    ),
  );
}

//******************************************************************************

void showComingSoonDialog(
  BuildContext context, {
  required String title,
  required bool isArabic,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => FadeInUp(
      child: AppDialog(
        pngImage: AppAssets.logoPng,
        buttonsAlignment: ButtonsAlignment.center,
        firstBtnTxt: isArabic ? 'حسناً' : 'OK',
        firstBtnTxtColor: Colors.white,
        firstBtnColor: AppStyle.appColor,
        onClickFirstBtn: () => Navigator.pop(context),
        hasCloseButton: true,
        closeIconColor: AppStyle.appColor,
        child: WillPopScope(
          onWillPop: () async => false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Text(
                  isArabic ? 'قريباً' : 'Coming Soon',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                    fontFamily: 'Cairo',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 5),
              Center(
                child: Text(
                  isArabic
                      ? 'ميزة "$title" ستتوفر في التحديث القادم.'
                      : '"$title" feature will be available in the next update.',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontFamily: 'Cairo',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    ),
  );
}

//******************************************************************************
Path drawStar(Size size) {
  // Method to convert degree to radians
  double degToRad(double deg) => deg * (pi / 180.0);

  const numberOfPoints = 5;
  final halfWidth = size.width / 2;
  final externalRadius = halfWidth;
  final internalRadius = halfWidth / 2.5;
  final degreesPerStep = degToRad(360 / numberOfPoints);
  final halfDegreesPerStep = degreesPerStep / 2;
  final path = Path();
  final fullAngle = degToRad(360);
  path.moveTo(size.width, halfWidth);

  for (double step = 0; step < fullAngle; step += degreesPerStep) {
    path.lineTo(
      halfWidth + externalRadius * cos(step),
      halfWidth + externalRadius * sin(step),
    );
    path.lineTo(
      halfWidth + internalRadius * cos(step + halfDegreesPerStep),
      halfWidth + internalRadius * sin(step + halfDegreesPerStep),
    );
  }
  path.close();
  return path;
}

// final ConfettiController confettiController = ConfettiController(
//   duration: const Duration(seconds: 3),
// );

// void checkoutSuccessOrFailDialog(
//   BuildContext context, {
//   String message = '',
//   required bool success,
//   VoidCallback? onClickCloseBtn,
//   required String appointmentId,
//   bool isFromWallet = false,
// }) {
//   final PrefsService prefs = locator<PrefsService>();
//
//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (_) {
//       if (success) {
//         locator<AppStartManager>().execute();
//       }
//       return FadeInUp(
//         child: AppDialog(
//           // pngImage: success ? AppAssets.success : AppAssets.fail,
//           buttonsAlignment: ButtonsAlignment.center,
//           firstBtnTxt: success
//               ? isFromWallet
//                     ? prefs.appLanguage == 'ar'
//                           ? 'عرض المحفظة'
//                           : 'View Wallet'
//                     : prefs.appLanguage == 'ar'
//                     ? 'عرض الإيصال'
//                     : 'View Receipt'
//               : null,
//           firstBtnTxtColor: Colors.white,
//           firstBtnColor: AppStyle.mawedColor,
//           closeIconColor: AppStyle.mawedColor,
//           secondBtnTxt: prefs.appLanguage == 'ar'
//               ? 'الرجوع الى الرئيسية'
//               : 'Back to Home',
//           secondBtnTxtColor: AppStyle.grey,
//           secondBtnColor: Colors.transparent,
//           secondBtnBorderColor: Colors.grey.shade400,
//           onClickSecondBtn: () {
//             // confettiController.dispose();
//
//             Navigator.of(context).pop();
//             locator<MainTabsManager>().resetTabIndex();
//             Navigator.of(context).pushNamedAndRemoveUntil(
//               AppRoutesNames.mainTabsWidget,
//               (Route<dynamic> route) => false,
//             );
//           },
//           onClickFirstBtn: () {
//             // confettiController.dispose();
//             Navigator.of(context).pop();
//             if (isFromWallet) {
//               locator<WalletManager>().execute();
//               Navigator.of(
//                 context,
//               ).popUntil(ModalRoute.withName(AppRoutesNames.walletPage));
//             } else {
//               locator<MainTabsManager>().resetTabIndex();
//               Navigator.of(context).pushNamedAndRemoveUntil(
//                 AppRoutesNames.receiptPage,
//                 (Route<dynamic> route) => false,
//                 arguments: ReceiptArgs(
//                   appointmentId: appointmentId,
//                   isComingFromCheckout: true,
//                 ),
//               );
//             }
//           },
//
//           hasCloseButton: false,
//           onClickCloseBtn: onClickCloseBtn,
//           dialogTopPadding: 10,
//           child: WillPopScope(
//             onWillPop: () async => false,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Align(
//                   alignment: Alignment.center,
//                   // child: Pulse(
//                   //   infinite: true,
//                   //   from: 0.5,
//                   //   to: 1.0,
//                   //   duration: const Duration(seconds: 3),
//                   //   child: ConfettiWidget(
//                   //     confettiController: confettiController,
//                   //
//                   //     blastDirectionality: BlastDirectionality.explosive,
//                   //     // don't specify a direction, blast randomly
//                   //     shouldLoop: true,
//                   //     // start again as soon as the animation is finished
//                   //     colors: const [
//                   //       Colors.green,
//                   //       Colors.blue,
//                   //       Colors.pink,
//                   //       Colors.orange,
//                   //       Colors.purple,
//                   //     ],
//                   //
//                   //     // manually specify the colors to be used
//                   //     createParticlePath:
//                   //         drawStar, // define a custom shape/path.
//                   //     child: Icon(
//                   //       success ? Icons.check_circle : Icons.error,
//                   //       size: 80.sp,
//                   //       color: success ? Colors.green : Colors.red,
//                   //     ),
//                   //   ),
//                   // ),
//                   child: Image.asset(AppAssets.success),
//                 ),
//                 Center(
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 8.sp),
//                     child: Text(
//                       success
//                           ? isFromWallet
//                                 ? prefs.appLanguage == 'ar'
//                                       ? 'تمت العملية بنجاح! 🥰'
//                                       : 'The operation was successful! 🥰'
//                                 : prefs.appLanguage == 'ar'
//                                 ? 'تم تأكيد موعدك! 🥰'
//                                 : 'Your appointment is confirmed! 🥰'
//                           : prefs.appLanguage == 'ar'
//                           ? 'للاسف! لم تتم العملية برجاء اعادة المحاولة'
//                           : 'Unfortunately! The operation was not completed. Please try again',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16.sp,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 5),
//                 Center(
//                   child: Text(
//                     success
//                         ? isFromWallet
//                               ? prefs.appLanguage == 'ar'
//                                     ? 'شكرًا لشحن محفظتك. نتطلع لرؤيتك قريبًا.'
//                                     : 'Thank you for charging your wallet. We look forward to seeing you soon.'
//                               : prefs.appLanguage == 'ar'
//                               ? 'شكرًا لحجزك. نتطلع لرؤيتك قريبًا.'
//                               : 'Thank you for your booking. We look forward to seeing you soon.'
//                         : prefs.appLanguage == 'ar'
//                         ? 'فشلت عملية الدفع. قد يكون السبب مشكلة في بطاقتك، أو عدم كفاية الرصيد، أو مشكلة في بوابة الدفع. يُرجى المحاولة مرة أخرى أو التواصل مع البنك مزوّد خدمة الدفع للحصول على المساعدة.'
//                         : 'Your payment has failed. This could be due to an issue with your card, insufficient funds, or a problem with the payment gateway. Please try again or contact your bank/payment provider for assistance.',
//                     style: TextStyle(fontSize: 13.sp),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//               ],
//             ),
//           ),
//         ),
//       );
//     },
//   );
// }

//******************************************************************************
void deleteFromCartConfirmationDialog(
  BuildContext context, {
  required VoidCallback onClickConfirmBtn,
  VoidCallback? onClickCloseBtn,
  VoidCallback? onClickContinueBtn,
  String? logoPng,
  Color? pngColor,
}) {
  final PrefsService prefs = locator<PrefsService>();
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => FadeInUp(
      child: AppDialog(
        pngImage: logoPng ?? AppAssets.logoPng,
        pngColor: pngColor,
        buttonsAlignment: ButtonsAlignment.center,
        firstBtnTxt: prefs.appLanguage == 'ar' ? 'نعم' : 'OK',
        firstBtnTxtColor: Colors.white,
        firstBtnColor: AppStyle.appColor,
        closeIconColor: AppStyle.appColor,
        // firstBtnTxt: '${context.translate(AppStrings.send)}',
        // secondBtnTxt: 'الاستمرار',
        secondBtnTxtColor: Colors.black,
        secondBtnColor: AppStyle.grey,
        onClickSecondBtn: onClickContinueBtn,
        onClickFirstBtn: onClickConfirmBtn,

        hasCloseButton: true,
        onClickCloseBtn: onClickCloseBtn,
        child: WillPopScope(
          onWillPop: () async => false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Text(
                  prefs.appLanguage == 'ar' ? 'حذف' : 'Delete',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 15),
              // status
              //     ? Center(
              //         child: FaIcon(
              //           FontAwesomeIcons.circleCheck,
              //           color: AppStyle.orange,
              //           size: 40.sp,
              //         ),
              //       )
              //     : Center(
              //         child: FaIcon(
              //           FontAwesomeIcons.faceSadCry,
              //           color: AppStyle.orange,
              //           size: 40.sp,
              //         ),
              //       ),
              // // Icon(FontA),
              // const SizedBox(
              //   height: 15,
              // ),
              Center(
                child: Text(
                  prefs.appLanguage == 'ar'
                      ? 'هل انت متأكد من رغبتك في حذف العنصر؟'
                      : 'Are you sure you want to delete this item?',
                  style: TextStyle(fontSize: 13.sp),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
        // onClickCloseBtn: onClickCloseBtn,
        // description: message ??
        //     '${context.translate(AppStrings.Are_you_ready_to_watch_the_training_video)}',
      ),
    ),
  );
}

//******************************************************************************
void showAddCartSuccessDialog(
  BuildContext context, {
  // required VoidCallback onClickConfirmBtn,
  VoidCallback? onClickCloseBtn,
  VoidCallback? onClickContinueBtn,
  VoidCallback? onClickGoToCartBtn,
  bool goToCardButton = false,
  required String msg,
  required String title,
  required String continueBtnTitle,
  required String colorHex,
  String? goToCartTitle,
  String? logoPng,
  Color? pngColor,
}) {
  final PrefsService prefs = locator<PrefsService>();
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => FadeInUp(
      child: AppDialog(
        pngImage: logoPng ?? AppAssets.logoPng,
        pngColor: pngColor,
        dialogColor: Colors.white,
        buttonsAlignment: ButtonsAlignment.center,
        // firstBtnTxt: prefs.appLanguage == 'ar' ? 'حسنا' : 'OK',
        firstBtnTxtColor: Colors.white,
        firstBtnColor: AppStyle.appColor,
        closeIconColor: AppStyle.twilight,
        // firstBtnTxt: '${context.translate(AppStrings.send)}',
        // secondBtnTxt: 'الاستمرار',
        secondBtnTxtColor: Colors.black,
        secondBtnColor: AppStyle.grey,
        // onClickSecondBtn: onClickContinueBtn,
        // onClickFirstBtn: onClickConfirmBtn,
        hasCloseButton: true,
        onClickCloseBtn: onClickCloseBtn,
        child: WillPopScope(
          onWillPop: () async => false,
          child: Column(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              BounceInLeft(
                child: Center(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      // color: AppStyle.twilight.withValues(alpha: 0.8),
                    ),
                    textAlign: TextAlign.center,
                    // maxLines: 1,
                    // overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              BounceInRight(
                child: Center(
                  child: Text(
                    msg,
                    style: TextStyle(
                      fontSize: 14.sp,
                      // color: AppStyle.twilight.withValues(alpha: 0.8),
                    ),
                    textAlign: TextAlign.center,
                    // maxLines: 1,
                    // overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Column(
                spacing: 5,
                children: [
                  BounceInUp(
                    child: MainButtonWidget(
                      buttonHeight: 40.sp,
                      title: continueBtnTitle,
                      onClick: onClickContinueBtn,
                      color: AppStyle.appColor,
                    ),
                  ),

                  if (goToCardButton == true) const SizedBox(width: 15),
                  if (goToCardButton == true)
                    BounceInDown(
                      child: MainButtonWidget(
                        title: goToCartTitle ?? '',
                        buttonHeight: 40.sp,
                        onClick: onClickGoToCartBtn,
                        color: Colors.transparent,
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          // height: 1,
                        ),
                        borderColor: Colors.transparent,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        // onClickCloseBtn: onClickCloseBtn,
        // description: message ??
        //     '${context.translate(AppStrings.Are_you_ready_to_watch_the_training_video)}',
      ),
    ),
  );
}

//******************************************************************************

void showWalletEmptyDialog(
  BuildContext context, {
  // required VoidCallback onClickConfirmBtn,
  VoidCallback? onClickCloseBtn,
  VoidCallback? onClickContinueBtn,
  VoidCallback? onClickGoToCartBtn,
  bool goToCardButton = false,
  required String msg,
  required String title,
  required String continueBtnTitle,
  required String colorHex,
  String? goToCartTitle,
  String? logoPng,
  Color? pngColor,
}) {
  final PrefsService prefs = locator<PrefsService>();
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => FadeInUp(
      child: AppDialog(
        pngImage: logoPng ?? AppAssets.logoPng,
        pngColor: pngColor,
        dialogColor: Colors.white,
        buttonsAlignment: ButtonsAlignment.center,
        // firstBtnTxt: prefs.appLanguage == 'ar' ? 'حسنا' : 'OK',
        firstBtnTxtColor: Colors.white,
        firstBtnColor: AppStyle.appColor,
        closeIconColor: AppStyle.twilight,
        // firstBtnTxt: '${context.translate(AppStrings.send)}',
        // secondBtnTxt: 'الاستمرار',
        secondBtnTxtColor: Colors.black,
        secondBtnColor: AppStyle.grey,
        // onClickSecondBtn: onClickContinueBtn,
        // onClickFirstBtn: onClickConfirmBtn,
        hasCloseButton: true,
        onClickCloseBtn: onClickCloseBtn,
        child: WillPopScope(
          onWillPop: () async => false,
          child: Column(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              BounceInLeft(
                child: Center(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      // color: AppStyle.twilight.withValues(alpha: 0.8),
                    ),
                    textAlign: TextAlign.center,
                    // maxLines: 1,
                    // overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              BounceInRight(
                child: Center(
                  child: Text(
                    msg,
                    style: TextStyle(
                      fontSize: 14.sp,
                      // color: AppStyle.twilight.withValues(alpha: 0.8),
                    ),
                    textAlign: TextAlign.center,
                    // maxLines: 1,
                    // overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Column(
                spacing: 5,
                children: [
                  BounceInUp(
                    child: MainButtonWidget(
                      buttonHeight: 40.sp,
                      title: continueBtnTitle,
                      onClick: onClickContinueBtn,
                      color: AppStyle.appColor,
                    ),
                  ),

                  if (goToCardButton == true) const SizedBox(width: 15),
                  if (goToCardButton == true)
                    BounceInDown(
                      child: MainButtonWidget(
                        title: goToCartTitle ?? '',
                        buttonHeight: 40.sp,
                        onClick: onClickGoToCartBtn,
                        color: Colors.transparent,
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          // height: 1,
                        ),
                        borderColor: Colors.transparent,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        // onClickCloseBtn: onClickCloseBtn,
        // description: message ??
        //     '${context.translate(AppStrings.Are_you_ready_to_watch_the_training_video)}',
      ),
    ),
  );
}

//******************************************************************************

void errorDialog(
  BuildContext context, {
  required VoidCallback onClickConfirmBtn,
  VoidCallback? onClickCloseBtn,
  VoidCallback? onClickSecondBtn,
  required String errorMessage,
}) {
  final PrefsService prefs = locator<PrefsService>();
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => FadeInUp(
      child: AppDialog(
        pngImage: AppAssets.logoPng,
        buttonsAlignment: ButtonsAlignment.center,
        firstBtnTxt: prefs.appLanguage == 'ar' ? 'حسنا' : 'OK',
        firstBtnTxtColor: Colors.white,
        firstBtnColor: AppStyle.appColor,
        onClickFirstBtn: onClickConfirmBtn,
        // secondBtnTxt: 'الاستمرار',
        secondBtnTxtColor: Colors.black,
        secondBtnColor: AppStyle.grey,
        onClickSecondBtn: onClickSecondBtn,

        hasCloseButton: true,
        closeIconColor: AppStyle.appColor,

        onClickCloseBtn: onClickCloseBtn,
        child: WillPopScope(
          onWillPop: () async => false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Text(
                  // errorMessage,
                  prefs.appLanguage == 'ar' ? 'خطأ' : 'Error',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                    // color: AppStyle.appColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 5),
              Center(
                child: Text(
                  errorMessage,
                  style: TextStyle(
                    fontSize: 13.sp,
                    // color: AppStyle.appColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    ),
  );
}

//******************************************************************************

//******************************************************************************
