import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../app_core.dart';
import 'base_response.dart';

enum HttpMethod { get, post, put, delete }

abstract class BaseRepository {
  static final interceptors = [
    CustomInterceptor(),
    PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      compact: true,
      logPrint: (object) => log(object.toString()),
    ),
  ];

  // Configure your Dio instance once
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://78.89.175.73:2085/api/', // Target Ghars School API port 2085
      connectTimeout: const Duration(minutes: 1),
      receiveTimeout: const Duration(minutes: 1),
    ),
  )..interceptors.addAll(interceptors);

  /// The master execution method
  Future<ListResult<T>?> _execute<T>({
    required HttpMethod method,
    required String path,
    required T Function(dynamic) mapper,
    dynamic body,
    Map<String, dynamic>? queryParameters,
  }) async {
    Response? response;
    try {
      switch (method) {
        case HttpMethod.get:
          response = await _dio.get(path, queryParameters: queryParameters);
          break;
        case HttpMethod.post:
          response = await _dio.post(
            path,
            data: body,
            queryParameters: queryParameters,
          );
          break;
        case HttpMethod.put:
          response = await _dio.put(
            path,
            data: body,
            queryParameters: queryParameters,
          );
          break;
        case HttpMethod.delete:
          response = await _dio.delete(
            path,
            data: body,
            queryParameters: queryParameters,
          );
          break;
      }

      // 1. Parse into BaseResponse
      final base = BaseResponse<T>.fromJson(response.data, mapper);

      // 2. Logic check: If API says success
      if (base.status == null || base.status == 200 || base.status == 201) {
        return ListResult<T>(
          data: base.result,
          message: base.message,
          token: base.token,
          status: base.status,
          result: true,
        );
      } else {
        // Throw a DioException with the response attached
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: base.message ?? 'Server returned an error without a message.',
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: response?.requestOptions ?? RequestOptions(path: path),
        response: response,
        error: e,
        type: DioExceptionType.unknown,
      );
    }
  }

  // --- Exposed Public API ---

  Future<ListResult<T>?> getRequest<T>({
    required String path,
    required T Function(dynamic) mapper,
    Map<String, dynamic>? queryParameters,
  }) => _execute(
    method: HttpMethod.get,
    path: path,
    mapper: mapper,
    queryParameters: queryParameters,
  );

  Future<ListResult<T>?> postRequest<T>({
    required String path,
    required T Function(dynamic) mapper,
    dynamic body,
  }) =>
      _execute(method: HttpMethod.post, path: path, mapper: mapper, body: body);

  Future<ListResult<T>?> putRequest<T>({
    required String path,
    required T Function(dynamic) mapper,
    dynamic body,
  }) =>
      _execute(method: HttpMethod.put, path: path, mapper: mapper, body: body);

  Future<ListResult<T>?> deleteRequest<T>({
    required String path,
    required T Function(dynamic) mapper,
    dynamic body,
  }) =>
      _execute(method: HttpMethod.delete, path: path, mapper: mapper, body: body);
}
