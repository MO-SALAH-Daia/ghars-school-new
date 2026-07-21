import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghars_school/app_core/resources/app_style/app_style.dart';

/*
Created by: Mohammad Salah
Date: Monday 07 March 2022
*/
class DrawerItemWidget extends StatelessWidget {
  final String title;
  final Widget icon;
  final VoidCallback onClick;
  const DrawerItemWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minLeadingWidth: 20,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
          color: AppStyle.twilight,
        ),
      ),
      leading: icon,
      onTap: onClick,
    );
  }
}
