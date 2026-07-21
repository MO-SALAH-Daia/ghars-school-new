// import 'dart:developer';
//
// import 'package:dio/dio.dart';
// import 'package:pretty_dio_logger/pretty_dio_logger.dart';
//
// import '../app_core.dart';
//
// class ApiService {
//   static final interceptors = [
//     CustomInterceptor(
//       // requestRecall: DioConnectivityRequestRecall(),
//     ),
//
//     // LogInterceptor(
//     //   requestHeader: true,
//     //   request: true,
//     //   requestBody: true,
//     //   responseHeader: true,
//     //   responseBody: true,
//     // )
//     PrettyDioLogger(
//       requestHeader: true,
//       requestBody: true,
//       responseBody: true,
//       responseHeader: false,
//       compact: true,
//       logPrint: (object) => log(object.toString()),
//     ),
//   ];
//   final Dio dioClient = Dio(
//     BaseOptions(
//       baseUrl: 'http://78.89.175.73:2075/api/',
//       connectTimeout: const Duration(minutes: 1),
//       receiveTimeout: const Duration(minutes: 1),
//       // validateStatus: (status) => status < 500,
//     ),
//   )..interceptors.addAll(interceptors);
// }
