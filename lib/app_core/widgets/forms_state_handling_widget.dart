import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../app_core.dart';

// ignore: must_be_immutable
class FormsStateHandling extends StatefulWidget {
  final ManagerState? managerState;
  final VoidCallback? onClickCloseErrorBtn;
  final Widget child;
  final String? errorMsg;
  final Color? loaderColor;
  final error;

  const FormsStateHandling({
    super.key,
    this.managerState = ManagerState.idle,
    required this.child,
    this.onClickCloseErrorBtn,
    this.errorMsg = '',
    this.loaderColor,
    this.error,
  });

  @override
  _FormsStateHandlingState createState() => _FormsStateHandlingState();
}

class _FormsStateHandlingState extends State<FormsStateHandling> {
  @override
  Widget build(BuildContext context) {
    if (widget.managerState == ManagerState.loading) {
      return Stack(
        children: [
          AbsorbPointer(child: widget.child),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            // color: Colors.black12.withOpacity(0.34),
            color: Colors.transparent,
            child: Center(
              child: Flash(
                infinite: true,
                duration: const Duration(seconds: 5),
                child: Container(
                  width: 90.sp,
                  height: 90.sp,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    // color: AppStyle.appColor,
                    color: AppStyle.appColor.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Image.asset(
                          AppAssets.logoPng,
                          fit: BoxFit.contain,
                          color: Colors.white,
                          width: 50.sp,
                          height: 50.sp,
                        ),
                      ),
                      SpinKitThreeBounce(color: Colors.white, size: 15.sp),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    } else if (widget.managerState == ManagerState.error) {
      return WillPopScope(
        onWillPop: () async {
          widget.onClickCloseErrorBtn!();
          return false;
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            GestureDetector(
              onTap: widget.onClickCloseErrorBtn,
              child: AbsorbPointer(child: widget.child),
            ),
            _errorWidget(
              context,
              DialogRequest(description: widget.errorMsg),
              widget.error,
            ),
          ],
        ),
      );
    } else if (widget.managerState == ManagerState.unknownError) {
      return WillPopScope(
        onWillPop: () async {
          widget.onClickCloseErrorBtn!();
          return false;
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            GestureDetector(
              onTap: widget.onClickCloseErrorBtn,
              child: AbsorbPointer(child: widget.child),
            ),
            _errorWidget(context, DialogRequest(description: widget.errorMsg)),
          ],
        ),
      );
    } else if (widget.managerState == ManagerState.socketError) {
      return WillPopScope(
        onWillPop: () async {
          widget.onClickCloseErrorBtn!();
          return false;
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            GestureDetector(
              onTap: widget.onClickCloseErrorBtn,
              child: AbsorbPointer(child: widget.child),
            ),
            _errorWidget(context, DialogRequest(description: widget.errorMsg)),
          ],
        ),
      );
    } else {
      return widget.child;
    }
  }

  Widget _errorWidget(BuildContext context, DialogRequest request, [error]) {
    return FadeInUp(
      child: CustomDialog(
        titleColor: const Color(0xff042464),
        title: request.title,
        description: request.description,
        descriptionColor: const Color(0xff042464),
        imageUrl: AppAssets.logoPng,
        logoColor: AppStyle.appColor,
        // imageInBodyUrl: AppAssets.appbarLogo,
        // imageInBodyUrl: AppAssets.DIALOG_CONFIRM,
        // onCloseBtn: widget.onClickCloseErrorBtn,
        // confirmBtnTxt: "RETRY",
        confirmBtnTxt: error?.response?.statusCode == 401
            ? locator<PrefsService>().appLanguage == 'en'
                  ? 'Login'
                  : 'تسجيل الدخول'
            : locator<PrefsService>().appLanguage == 'en'
            ? 'Retry'
            : "أعد المحاولة",
        onClickConfirmBtn: error?.response?.statusCode == 401
            ? () {
                locator<NavigationService>().pushNamedAndRemoveUntil(
                  AppRoutesNames.loginPage,
                );
              }
            : widget.onClickCloseErrorBtn,
        confirmBtnColor: const Color(0xff0081FD),
      ),
    );
  }
}
