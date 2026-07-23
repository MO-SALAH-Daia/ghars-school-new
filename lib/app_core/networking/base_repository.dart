import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

import '../app_core.dart';
import 'base_response.dart';

enum HttpMethod { get, post, put, delete }

abstract class BaseRepository {
  static final interceptors = [
    CustomInterceptor(),
    AppLoggerInterceptor(),
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
        message: e.toString(),
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

class AppLoggerInterceptor extends Interceptor {
  final JsonEncoder _encoder = const JsonEncoder.withIndent('  ');

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log('╔══════════════════════════════════════════════════════════════════════════════════════════╗');
    log('║ HTTP REQUEST: [${options.method}] ${options.uri}');
    log('╟ Headers: ${options.headers}');
    if (options.data != null) {
      String requestBody = '';
      try {
        requestBody = _encoder.convert(options.data);
      } catch (_) {
        requestBody = options.data.toString();
      }
      if (requestBody.isNotEmpty) {
        log('╟ Body:');
        final lines = requestBody.split('\n');
        for (final line in lines) {
          if (line.length > 1000) {
            log('║ ${line.substring(0, 1000)}... [TRUNCATED]');
          } else {
            log('║ $line');
          }
        }
      }
    }
    log('╚══════════════════════════════════════════════════════════════════════════════════════════╝');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log('╔══════════════════════════════════════════════════════════════════════════════════════════╗');
    log('║ HTTP RESPONSE [${response.statusCode}] ${response.requestOptions.method} ${response.requestOptions.uri}');
    log('╟ Headers: ${response.headers.map}');
    if (response.data != null) {
      String responseBody = '';
      try {
        responseBody = _encoder.convert(response.data);
      } catch (_) {
        responseBody = response.data.toString();
      }

      if (responseBody.isNotEmpty) {
        // Capping total body string to 3,000 characters to prevent console logs flooding on Base64
        if (responseBody.length > 3000) {
          responseBody = '${responseBody.substring(0, 3000)}\n... [TRUNCATED due to length: ${responseBody.length}]';
        }

        log('╟ Body:');
        final lines = responseBody.split('\n');
        for (final line in lines) {
          log('║ $line');
        }
      }
    }
    log('╚══════════════════════════════════════════════════════════════════════════════════════════╝');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log('╔══════════════════════════════════════════════════════════════════════════════════════════╗');
    final errDetail = err.message ?? err.error?.toString() ?? err.toString();
    log('║ HTTP ERROR: $errDetail');
    if (err.response != null) {
      log('╟ Status: [${err.response?.statusCode}]');
      if (err.response?.data != null) {
        String errorBody = '';
        try {
          errorBody = _encoder.convert(err.response?.data);
        } catch (_) {
          errorBody = err.response?.data.toString() ?? '';
        }
        if (errorBody.isNotEmpty) {
          log('╟ Body:');
          final lines = errorBody.split('\n');
          for (final line in lines) {
            log('║ $line');
          }
        }
      }
    }
    log('╚══════════════════════════════════════════════════════════════════════════════════════════╝');
    handler.next(err);
  }
}
