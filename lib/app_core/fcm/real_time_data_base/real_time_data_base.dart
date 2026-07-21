// import 'dart:developer';
//
// import 'package:debla/app_core/locator.dart';
// import 'package:debla/features/general/live_prices/live_prices.dart';
// import 'package:debla/features/general/live_prices/live_prices_manager.dart';
// import 'package:debla/shared/app_widget/app_widget.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_database/firebase_database.dart';
//
// class FirebaseLiveDataBase {
//   void getData() {
//     log("FirebaseLiveDataBase");
//     DatabaseReference databaseReference = FirebaseDatabase.instanceFor(
//       app: Firebase.app(), // Optional, defaults to the default Firebase app
//       databaseURL:
//           'https://debla-19a4d-default-rtdb.europe-west1.firebasedatabase.app',
//     ).ref();
//     // .child('latest_prices');
//
//     // Listening to real-time updates from the 'users' node
//     databaseReference.onValue.listen((DatabaseEvent event) {
//       DataSnapshot dataSnapshot = event.snapshot;
//
//       if (dataSnapshot.value != null) {
//         Map<dynamic, dynamic> values =
//             dataSnapshot.value as Map<dynamic, dynamic>;
//         log('FirebaseLiveDataBase Values: $values');
//         LivePrices livePrices = LivePrices.fromJson(values);
//         locator<LivePricesManager>().pricesList =
//             locator<LivePricesManager>().prices(livePrices);
//         locator<LivePricesManager>()
//           ..charts18(livePrices)
//           ..charts21(livePrices)
//           ..charts22(livePrices)
//           ..charts24(livePrices)
//           ..chartsLira(livePrices);
//         locator<LivePricesManager>().inLivePrices = livePrices;
//
//         log('FirebaseLiveDataBase=========================>${livePrices.latestPrices}');
//         log('FirebaseLiveDataBase=========================>${livePrices.percentageChanges?.i24k}');
//
//         AppWidgetConfig.updateAppWidget(
//             locator<LivePricesManager>().pricesList);
//
//         // values.forEach((key, value) {
//         //   log('FirebaseLiveDataBase Key: $key / Value: $value');
//         //   if (value is Map<dynamic, dynamic>) {
//         //     log('Name: ${value['18k']}');
//         //     log('Email: ${value['22k']}');
//         //     log('Age: ${value['24k']}');
//         //   }
//         // });
//       } else {
//         log('No data found');
//       }
//     });
//   }
// }
