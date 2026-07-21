class User {
  int? id;
  String? name;
  String? nameAr;
  String? email;
  String? phone;

  int? coustomerType;
  int? customerId;
  String? snn;
  String? userName;
  String? password;
  String? token;

  int? allStudent;
  int? allStudentRequest;

  String? userType;
  String? emp_img;
  String? emp_role;
  String? roles;
  
  bool? isEmployee;

  User({
    this.id,
    this.name,
    this.nameAr,
    this.email,
    this.phone,
    this.coustomerType,
    this.customerId,
    this.snn,
    this.userName,
    this.password,
    this.token,
    this.allStudent,
    this.allStudentRequest,
    this.userType,
    this.emp_img,
    this.emp_role,
    this.roles,
    this.isEmployee,
  });

  // Getter for compatibility with custom interceptor
  int? get userID => id;

  factory User.fromJson(Map<String, dynamic> json) {
    final userType = (json['userType'] ?? json['UserType'])?.toString();
    final isEmp = json['isEmployee']?.toString() == 'true' || 
                  json['isEmployee'] == true ||
                  (json['userDto'] != null && 
                   (json['userDto']['isEmployee']?.toString() == 'true' || 
                    json['userDto']['isEmployee'] == true));

    // Check if it's the direct API login response (which might have nested userDto, or is the flat userDto map itself)
    final Map<String, dynamic> userMap = json.containsKey('userDto') && json['userDto'] != null
        ? json['userDto'] as Map<String, dynamic>
        : json;

    return User(
      id: userMap['id'] != null 
          ? int.tryParse(userMap['id'].toString()) 
          : (userMap['emp_id'] != null 
              ? int.tryParse(userMap['emp_id'].toString()) 
              : null),
      name: userType == 'Employee'
          ? '${userMap['emp_first_name_a'] ?? ''} ${userMap['emp_last_name_a'] ?? ''}'.trim()
          : (userMap['name_2']?.toString() ?? userMap['name']?.toString()),
      nameAr: userType == 'Employee'
          ? '${userMap['emp_first_name_a'] ?? ''} ${userMap['emp_last_name_a'] ?? ''}'.trim()
          : (userMap['name_1']?.toString() ?? userMap['nameAr']?.toString()),
      email: userMap['email']?.toString(),
      phone: (userMap['tel_1'] ?? userMap['phone'])?.toString(),
      coustomerType: userMap['coustomerType'] != null ? int.tryParse(userMap['coustomerType'].toString()) : null,
      customerId: (userMap['customerId'] ?? userMap['customerID']) != null 
          ? int.tryParse((userMap['customerId'] ?? userMap['customerID']).toString()) 
          : null,
      snn: userType == 'Employee' 
          ? (userMap['emp_unique_id']?.toString() ?? userMap['snn']?.toString()) 
          : (userMap['id_no']?.toString() ?? userMap['snn']?.toString()),
      userName: userMap['userName']?.toString(),
      password: userMap['password']?.toString(),
      token: (json['token'] ?? userMap['token'])?.toString(),
      allStudent: userMap['allStudent'] != null ? int.tryParse(userMap['allStudent'].toString()) : null,
      allStudentRequest: userMap['allStudentRequest'] != null ? int.tryParse(userMap['allStudentRequest'].toString()) : null,
      userType: userType,
      emp_img: userMap['emp_img_fullpath']?.toString() ?? userMap['emp_img']?.toString(),
      emp_role: userMap['emp_role']?.toString(),
      roles: userMap['roles']?.toString(),
      isEmployee: isEmp,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['nameAr'] = nameAr;
    data['email'] = email;
    data['phone'] = phone;
    data['coustomerType'] = coustomerType;
    data['customerId'] = customerId;
    data['snn'] = snn;
    data['userName'] = userName;
    data['password'] = password;
    data['token'] = token;
    data['allStudent'] = allStudent;
    data['allStudentRequest'] = allStudentRequest;
    data['userType'] = userType;
    data['emp_img'] = emp_img;
    data['emp_role'] = emp_role;
    data['roles'] = roles;
    data['isEmployee'] = isEmployee;
    return data;
  }
}
