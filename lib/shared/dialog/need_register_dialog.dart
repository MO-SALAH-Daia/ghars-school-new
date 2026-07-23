//
// import 'package:gtc/app_core/app_core.dart';
// import 'package:gtc/app_core/resources/app_routes_names/app_routes_names.dart';
// import 'package:gtc/app_core/resources/app_strings/app_strings.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
//
//
// void needRegisterDialog(BuildContext context) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return CupertinoAlertDialog(
//         title: Text('${context.translate(AppStrings.need_register)}'),
//         actions: [
//           CupertinoDialogAction(
//             child: Text('${context.translate(AppStrings.cancel)}',style: TextStyle(color: Colors.redAccent),),
//             onPressed: () {
//               Navigator.of(context).pop(); // Close the dialog
//             },
//           ),
//           CupertinoDialogAction(
//             isDefaultAction: true,
//             child: Text('${context.translate(AppStrings.signIn)}',style: TextStyle(color: Colors.black),),
//             onPressed: () {
//               Navigator.of(context).pop(); // C
//               Navigator.of(context).pushNamed(AppRoutesNames.loginPage);// lose the dialog
//             },
//           ),
//         ],
//       );
//     },
//   );
// }