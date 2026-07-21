// import 'dart:developer';
//
// import 'package:debla/app_core/app_core.dart';
// import 'package:debla/app_core/resources/app_routes_names/app_routes_names.dart';
// import 'package:debla/features/product_details/product_details_page.dart';
// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
//
// class DynamicLinkService {
//   final NavigationService _navigationService = locator<NavigationService>();
//
//   Future handleDynamicLinks() async {
//     await Future.delayed(const Duration(seconds: 5));
//
//     // Register a link callback to fire if the app is opened up from the background
//     // using a dynamic link.
//     FirebaseDynamicLinks.instance.onLink
//         .listen((PendingDynamicLinkData dynamicLink) async {
//       // handle link that has been retrieved
//       _handleDeepLink(dynamicLink);
//     }).onError((error) async {
//       log('Link Failed: ${error.message}');
//     });
//
//     // Get the initial dynamic link if the app is opened with a dynamic link
//     final PendingDynamicLinkData? data =
//         await FirebaseDynamicLinks.instance.getInitialLink();
//     log('PendingDynamicLinkData: ${data?.link}');
//
//     // handle link that has been retrieved
//     _handleDeepLink(data);
//   }
//
//   void _handleDeepLink(PendingDynamicLinkData? data) {
//     final Uri? deepLink = data?.link;
//     if (deepLink != null) {
//       log('_handleDeepLink | deeplink: $deepLink');
//
//       /// 1. product
//       if (deepLink.pathSegments.contains('product')) {
//         var productId = deepLink.pathSegments.last;
//         if (productId.isNotEmpty) {
//           _navigationService.pushNamedTo(
//             AppRoutesNames.productDetailsPage,
//             arguments: ProductDetailsPageArgs(
//               productId: productId,
//             ),
//           );
//         }
//       }
//     }
//   }
//
//   /// 1. createProductLink
//   Future<String> createProductLink(
//       {required String productId,
//       String? title,
//       String? description,
//       Uri? uri}) async {
//     final DynamicLinkParameters parameters = DynamicLinkParameters(
//       uriPrefix: 'https://debla.page.link',
//       link: Uri.parse('https://debla.com/product/$productId'),
//       // 'https://linkalintest.com/bego/product/$productId?ofl=https://play.google.com/store'),
//
//       androidParameters: const AndroidParameters(
//         packageName: 'com.spark.debla',
//         minimumVersion: 1,
//       ),
//
//       // Other things to add as an example. We don't need it now
//       iosParameters: const IOSParameters(
//         bundleId: 'com.spark-cloud.Deblaa',
//         minimumVersion: '1',
//         appStoreId: '123456789',
//       ),
//       // googleAnalyticsParameters: const GoogleAnalyticsParameters(
//       //   campaign: 'example-promo',
//       //   medium: 'social',
//       //   source: 'orkut',
//       // ),
//       // itunesConnectAnalyticsParameters: ItunesConnectAnalyticsParameters(
//       //   providerToken: '123456',
//       //   campaignToken: 'example-promo',
//       // ),
//       socialMetaTagParameters: SocialMetaTagParameters(
//         title: title,
//         imageUrl: uri,
//         description: description,
//       ),
//     );
//
//     // final Uri dynamicUrl = await parameters.buildUrl();
//     // final Uri longLink =
//     //     await FirebaseDynamicLinks.instance.buildLink(parameters);
//
//     final ShortDynamicLink shortDynamicLink =
//         await FirebaseDynamicLinks.instance.buildShortLink(parameters);
//
//     final Uri dynamicUrl = shortDynamicLink.shortUrl;
//
//     return dynamicUrl.toString();
//   }
// }
