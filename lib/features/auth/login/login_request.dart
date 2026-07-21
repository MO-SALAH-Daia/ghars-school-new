class LoginRequest {
  String? username;
  String? password;
  bool? loginAsEmp;
  String? FireBaseToken;

  LoginRequest({
    this.username,
    this.password,
    this.loginAsEmp = false,
    this.FireBaseToken = '',
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['password'] = password;
    data['loginAsEmp'] = loginAsEmp;
    data['FireBaseToken'] = FireBaseToken;
    return data;
  }
}
