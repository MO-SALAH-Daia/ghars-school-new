import 'package:ghars_school/app_core/domain/user.dart';
import 'package:ghars_school/app_core/networking/base_repository.dart';
import 'package:ghars_school/app_core/networking/base_response.dart';
import 'package:ghars_school/features/auth/login/login_request.dart';

class LoginRepo extends BaseRepository {
  Future<ListResult<User>?> login({required LoginRequest request}) async {
    return await postRequest<User>(
      path: 'Account/ParentLogin',
      body: request.toJson(),
      mapper: (dynamic json) {
        return User.fromJson(json as Map<String, dynamic>);
      },
    );
  }
}
