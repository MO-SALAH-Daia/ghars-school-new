import 'dart:async';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'skeleton_factory.dart';

import '../app_core.dart';

typedef OnSuccessFunction<T> = Widget Function(BuildContext context, T data);
typedef OnErrorFunction = Widget Function(BuildContext context, dynamic error);
typedef OnWaitingFunction = Widget Function(BuildContext context);

class FutureObserver<T> extends StatelessWidget {
  final Future<T>? future;

  final OnSuccessFunction<T> onSuccess;
  final OnWaitingFunction? onWaiting;
  final OnErrorFunction? onError;

  final double errorWidgetMargin;
  final VoidCallback? onRetryClicked;

  final ObserverSkeletonType? skeletonType;
  final List<ObserverSkeletonType>? skeletonTypes;
  final List<SkeletonConfig>? skeletonConfigs;
  final int skeletonItemCount;

  FutureObserver({
    super.key,
    required this.future,
    required this.onSuccess,
    this.onWaiting,
    this.onError,
    this.errorWidgetMargin = 0.0,
    this.onRetryClicked,
    this.skeletonType,
    this.skeletonTypes,
    this.skeletonConfigs,
    this.skeletonItemCount = 6,
  });

  final ValueNotifier<bool> _retryNotifier = ValueNotifier<bool>(false);

  Function get _defaultOnWaiting =>
      (context) => Center(
        child: SpinKitSpinningLines(
          color: AppStyle.bayZeroColor,
          itemCount: 5,
          size: 70.sp,
        ),
      );

  Function get _defaultOnError => (context, error) {
    String errorMsg;
    if (error.error is SocketException) {
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
                      color: AppStyle.bayZeroColor,
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
                        backgroundColor: AppStyle.bayZeroColor,
                        shadowColor: AppStyle.bayZeroColor,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: onRetryClicked,
                      child: Text(
                        locator<PrefsService>().appLanguage == 'en'
                            ? 'Retry'
                            : 'أعد المحاولة',
                        style: TextStyle(
                          color: Colors.black,
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
                      color: AppStyle.bayZeroColor,
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
                        backgroundColor: AppStyle.bayZeroColor,
                        shadowColor: AppStyle.bayZeroColor,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: onRetryClicked,
                      child: Text(
                        locator<PrefsService>().appLanguage == 'en'
                            ? 'Retry'
                            : 'أعد المحاولة',
                        style: TextStyle(
                          color: Colors.black,
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
    return ValueListenableBuilder<bool>(
      valueListenable: _retryNotifier,
      builder: (context, bool retryValue, _) {
        return retryValue
            ? _defaultOnWaiting(context)
            : FutureBuilder(
                future: future,
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
