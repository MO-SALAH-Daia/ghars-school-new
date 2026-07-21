import 'package:ghars_school/app_core/resources/app_style/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainButtonWidget extends StatelessWidget {
  final double? width, marginTop, buttonHeight, marginBottom, borderRadius;
  final double horizontalPadding;
  final Color? color, borderColor, boxShadowColor;

  // final List<Color> gradientColors;
  final String title;
  final TextStyle? textStyle;
  final VoidCallback? onClick;

  const MainButtonWidget({
    super.key,
    this.width,
    this.borderRadius = 10,
    this.marginTop,
    this.marginBottom,
    this.textStyle,
    this.buttonHeight = 60,
    this.color = AppStyle.bayZeroColor,
    // this.shadowColor,
    this.borderColor,
    this.boxShadowColor = Colors.transparent,
    required this.title,
    this.onClick,
    this.horizontalPadding = 0,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        width: width == 0 ? null : width ?? MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          border: Border.all(color: borderColor ?? AppStyle.appColor),
          borderRadius: BorderRadius.circular(borderRadius!),
          boxShadow: [
            BoxShadow(
              color: boxShadowColor ?? Colors.grey.withValues(alpha: 0.5),
              spreadRadius: .1,
              blurRadius: .1,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
          color: color,
        ),
        height: buttonHeight,
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        margin: EdgeInsets.only(top: marginTop ?? 0, bottom: marginBottom ?? 8),
        child: Center(
          child: Text(
            title,
            style:
                textStyle ??
                TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  // height: 1,
                ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
