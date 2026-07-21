class BaseResponse<T> {
  int? status;
  String? message;
  dynamic token;
  T? result;

  BaseResponse({
    this.status,
    this.message,
    this.token,
    this.result,
  });

  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    // If the JSON contains 'result', parse it. Otherwise, parse the JSON itself (flat structure like login)
    final hasResult = json.containsKey('result');
    return BaseResponse<T>(
      status: json['status'] as int?,
      message: json['message'] as String?,
      token: json['token'],
      result: hasResult
          ? (json['result'] != null ? fromJsonT(json['result']) : null)
          : fromJsonT(json),
    );
  }
}

class ListResult<T> {
  T? data;
  String? message;
  dynamic token;
  int? status;
  bool? result; // For backward compatibility with bay_zero managers

  ListResult({
    this.data,
    this.message,
    this.token,
    this.status,
    this.result,
  });
}
