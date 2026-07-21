import 'dart:developer';

import 'package:url_launcher/url_launcher.dart';

import '../../app_core.dart';

openURL(urlLink) async {
  final url = urlLink;
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  } else {
    locator<ToastTemplate>().show('Could not launch $url');
  }
}

class AppUtils {
  AppUtils._();

  static Future<void> openMap({required latitude, required longitude}) async {
    final String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    openURL(googleUrl);
  }

  static Future<void> openWhatsapp({
    required String phoneNumber,
    String text = '',
  }) async {
    // final String androidUrl = 'whatsapp://send?phone=$phoneNumber&text=$text';
    // final String iosUrl = 'https://wa.me/$phoneNumber?text=${Uri.parse(text)}';
    final String url = 'https://wa.me/$phoneNumber?text= ';

    // String webUrl = 'https://api.whatsapp.com/send/?phone=$contact&text=hi';

    try {
      // if (Platform.isIOS) {
      //   openURL(iosUrl);
      // } else {
      //   openURL(iosUrl);
      // }
      await openURL(url);
    } catch (e) {
      log('$e');
    }
  }
}
