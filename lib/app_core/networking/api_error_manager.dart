// import 'package:dio/dio.dart';
// import 'package:rxdart/rxdart.dart';
//
// import '../app_core.dart';
//
// class ApiErrorManager extends Manager {
//   final PublishSubject<DioException> _errorSubject =
//       PublishSubject<DioException>();
//
//   Stream<DioException> get error$ => _errorSubject.stream;
//   Sink<DioException> get inError => _errorSubject.sink;
//
//   @override
//   void dispose() {
//     _errorSubject.close();
//   }
// }
