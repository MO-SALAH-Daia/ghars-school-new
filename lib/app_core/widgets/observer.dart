import 'dart:async';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rxdart/rxdart.dart';

import '../app_core.dart';
import 'skeleton_factory.dart';

typedef OnSuccessFunction<T> = Widget Function(BuildContext context, T data);
// typedef _OnErrorFunction = Widget Function(BuildContext context, Object error);
typedef OnErrorFunction = Widget Function(BuildContext context, dynamic error);
typedef OnWaitingFunction = Widget Function(BuildContext context);

class Observer<T> extends StatelessWidget {
  final Stream<T>? stream;

  final OnSuccessFunction<T> onSuccess;
  final OnWaitingFunction? onWaiting;
  final OnErrorFunction? onError;

  final double errorWidgetMargin;
  final VoidCallback? onRetryClicked;

  final ObserverSkeletonType? skeletonType;
  final List<ObserverSkeletonType>? skeletonTypes;
  final List<SkeletonConfig>? skeletonConfigs;
  final int skeletonItemCount;

  final Widget? parentWidget;

  Observer({
    super.key,
    required this.stream,
    required this.onSuccess,
    this.onWaiting,
    this.onError,
    this.errorWidgetMargin = 0.0,
    this.onRetryClicked,
    this.parentWidget,
    this.skeletonType,
    this.skeletonTypes,
    this.skeletonConfigs,
    this.skeletonItemCount = 6,
  });

  final _retryManager = RetryManager();

  Function get _defaultOnWaiting =>
      (context) => Center(
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
      );

  Function get _defaultOnError => (context, error) {
    String errorMsg;
    // 1. Create a safety flag
    bool isNetworkError = false;
    // 1. Determine if it's a Network Error safely
    if (error is DioException) {
      // It is safe to access .error here
      // Check for timeout or explicit connection errors
      isNetworkError =
          error.type == DioExceptionType.connectionError ||
          error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.error is SocketException;
    } else if (error is SocketException) {
      isNetworkError = true;
    } else {
      // String-based fallback (Case-insensitive check)
      final errStr = error.toString().toLowerCase();
      isNetworkError =
          errStr.contains('socketexception') ||
          errStr.contains('connection failed') ||
          errStr.contains('network_unreachable') ||
          errStr.contains('host lookup');
    }
    // if (error.error is SocketException) {
    // errorMsg = context.translate(AppStrings.NO_INTERNET_CONNECTION);
    // 2. Handle the UI based on the error type
    if (isNetworkError) {
      errorMsg = locator<PrefsService>().appLanguage == 'en'
          ? 'No Internet Connection'
          : 'لا يوجد إتصال بالشبكة';
      return Center(
        child: FittedBox(
          child: Container(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height,
            margin: EdgeInsets.only(top: errorWidgetMargin),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FadeInDown(
                  duration: const Duration(seconds: 2),
                  child: Flash(
                    infinite: true,
                    duration: const Duration(seconds: 5),
                    child: Icon(
                      Icons.network_check,
                      // color: AppStyle.beige,
                      color: AppStyle.appColor,
                      size: 300.w,
                    ),
                  ),
                ),
                FadeInDown(
                  duration: const Duration(seconds: 2),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      errorMsg,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        height: 1.3,
                        fontSize: 25.sp,
                        fontWeight: FontWeight.w900,
                        color: AppStyle.appColor,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                FadeInUp(
                  duration: const Duration(seconds: 2),
                  child: SizedBox(
                    height: 55,
                    // width: MediaQuery.of(context).size.width * 0.5,
                    width: 225.w,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11.0),
                        ),
                        backgroundColor: AppStyle.appColor,
                        shadowColor: AppStyle.appColor,
                        // fixedSize: Size.fromWidth(width ?? MediaQuery.of(context).size.width),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed:
                          onRetryClicked ??
                          () async {
                            // manager.streamDataObj();
                            // _retryManager.inRetry.add(true);
                            // await Future.delayed(const Duration(seconds: 1), () {
                            //   manager.streamDataObj();
                            //   _retryManager.inRetry.add(false);
                            // });
                            // manager.streamDataObj();
                          },
                      child: Text(
                        // context.translate(AppStrings.RETRY),
                        locator<PrefsService>().appLanguage == 'en'
                            ? 'Retry'
                            : 'أعد المحاولة',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          height: 1.3,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 100.h),
              ],
            ),
          ),
        ),
      );
    } else {
      // errorMsg = context.translate(AppStrings.SOMETHING_WENT_WRONG);
      errorMsg = locator<PrefsService>().appLanguage == 'en'
          ? 'Something Went Wrong Try Again Later'
          : 'حدث خطأ ما حاول مرة أخرى لاحقاً';

      return Center(
        child: FittedBox(
          child: Container(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height,
            margin: EdgeInsets.only(top: errorWidgetMargin),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FadeInDown(
                  duration: const Duration(seconds: 2),
                  child: Flash(
                    infinite: true,
                    duration: const Duration(seconds: 5),
                    child: Icon(
                      Icons.error_outline_sharp,
                      color: AppStyle.appColor,
                      size: 300.w,
                    ),
                  ),
                ),
                FadeInDown(
                  duration: const Duration(seconds: 2),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      errorMsg,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        height: 1.3,
                        fontSize: 25.sp,
                        fontWeight: FontWeight.w900,
                        color: AppStyle.appColor,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                FadeInUp(
                  duration: const Duration(seconds: 2),
                  child: SizedBox(
                    height: 55,
                    width: 225.w,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11.0),
                        ),
                        backgroundColor: AppStyle.appColor,
                        shadowColor: AppStyle.appColor,
                        // fixedSize: Size.fromWidth(width ?? MediaQuery.of(context).size.width),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed:
                          onRetryClicked ??
                          () async {
                            // manager.streamDataObj();
                            // _retryManager.inRetry.add(true);
                            // await Future.delayed(const Duration(seconds: 1), () {
                            //   manager.streamDataObj();
                            //   _retryManager.inRetry.add(false);
                            // });
                            // manager.streamDataObj();
                          },
                      child: Text(
                        // context.translate(AppStrings.RETRY),
                        locator<PrefsService>().appLanguage == 'en'
                            ? 'Retry'
                            : 'أعد المحاولة',

                        style: TextStyle(
                          color: Colors.white,
                          height: 1.3,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 100.h),
              ],
            ),
          ),
        ),
      );
    }
  };

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context);

    return StreamBuilder<bool>(
      initialData: false,
      stream: _retryManager.retry$,
      builder: (context, AsyncSnapshot<bool> retrySnapshot) {
        return retrySnapshot.data!
            ? _defaultOnWaiting(context)
            : StreamBuilder(
                stream: stream,
                builder: (context, AsyncSnapshot<T>? snapshot) {
                  if (snapshot!.hasError) {
                    return (onError != null)
                        ? onError!(context, snapshot.error!)
                        : _defaultOnError(context, snapshot.error);
                  }

                  if (snapshot.hasData) {
                    T data = snapshot.data as T;
                    return onSuccess(context, data);
                  } else {
                    if (skeletonType != null ||
                        skeletonTypes != null ||
                        skeletonConfigs != null) {
                      return SkeletonFactory(
                        configs:
                            skeletonConfigs ??
                            (skeletonTypes != null
                                ? skeletonTypes!
                                      .map(
                                        (t) => SkeletonConfig(
                                          type: t,
                                          itemCount: skeletonItemCount,
                                        ),
                                      )
                                      .toList()
                                : [
                                    SkeletonConfig(
                                      type: skeletonType!,
                                      itemCount: skeletonItemCount,
                                    ),
                                  ]),
                      );
                    }
                    return (onWaiting != null)
                        ? onWaiting!(context)
                        : _defaultOnWaiting(context);
                  }
                },
              );
      },
    );
  }
}

class RetryManager extends Manager {
  final BehaviorSubject<bool> _retrySubject = BehaviorSubject<bool>.seeded(
    false,
  );

  Stream<bool> get retry$ => _retrySubject.stream;

  Sink<bool> get inRetry => _retrySubject.sink;

  @override
  void dispose() {
    _retrySubject.close();
  }
}
