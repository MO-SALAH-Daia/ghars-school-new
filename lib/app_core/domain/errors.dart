import 'package:ghars_school/app_core/domain/error.dart';

class Errors {
  List<ApiError>? validationError;
  ApiError? generalError;

  Errors({this.validationError, this.generalError});

  Errors.fromJson(Map<String, dynamic> json) {
    if (json['validation_error'] != null) {
      validationError = <ApiError>[];
      json['validation_error'].forEach((v) {
        validationError!.add(ApiError.fromJson(v));
      });
    }
    generalError = json['general_error'] != null
        ? ApiError.fromJson(json['general_error'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (validationError != null) {
      data['validation_error'] = validationError!
          .map((v) => v.toJson())
          .toList();
    }
    if (generalError != null) {
      data['general_error'] = generalError!.toJson();
    }
    return data;
  }
}
