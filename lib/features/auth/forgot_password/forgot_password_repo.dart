import 'package:ghars_school/app_core/networking/base_repository.dart';
import 'package:ghars_school/app_core/networking/base_response.dart';
import 'package:ghars_school/features/auth/forgot_password/forgot_password_request.dart';

class ForgotPasswordRepo extends BaseRepository {
  Future<ListResult<bool>?> forgotPassword({
    required ForgotPasswordRequest request,
  }) async {
    return await postRequest<bool>(
      path: 'Account/ForgotPassword', // Placeholder API endpoint
      body: request.toJson(),
      mapper: (dynamic json) {
        if (json is bool) return json;
        return true; // Default success if response is successfully parsed
      },
    );
  }
}
