class StudentProfilesModel {
  int? status;
  String? message;
  Result? result;

  StudentProfilesModel({this.status, this.message, this.result});

  StudentProfilesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (result != null) {
      data['result'] = result!.toJson();
    }
    return data;
  }
}

class Result {
  StudentDto? studentDto;

  Result({this.studentDto});

  Result.fromJson(Map<String, dynamic> json) {
    studentDto = json['studentDto'] != null
        ? StudentDto.fromJson(json['studentDto'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (studentDto != null) {
      data['studentDto'] = studentDto!.toJson();
    }
    return data;
  }
}

class StudentDto {
  int? id;
  String? code;
  String? name11;
  String? name12;
  String? name13;
  String? name14;
  String? name15;
  String? name1;
  String? name21;
  String? name22;
  String? name23;
  String? name24;
  String? name25;
  String? name2;
  String? tel1;
  String? tel2;
  String? fax;
  String? address1;
  String? address2;
  String? birthDate;
  String? idNo;
  String? photo1Fullpath;
  String? regStageName1;
  String? regStageName2;
  int? gradeId;
  String? studntGradeName1;
  String? studntGradeName2;
  String? studntClassName1;
  String? studntClassName2;
  String? photo1;
  String? responsibileName1;
  String? responsibileName2;
  List<StudentAttendenceAbsenceLate>? studentAttendenceAbsenceLate;
  List<StudentGradeTimetable>? studentGradeTimetable;
  List<StudentEmails>? studentEmails;
  String? sickLeaveArEnVersion;
  String? travelPermission;

  StudentDto({
    this.id,
    this.code,
    this.name11,
    this.name12,
    this.name13,
    this.name14,
    this.name15,
    this.name1,
    this.name21,
    this.name22,
    this.name23,
    this.name24,
    this.name25,
    this.name2,
    this.tel1,
    this.tel2,
    this.fax,
    this.address1,
    this.address2,
    this.birthDate,
    this.idNo,
    this.photo1Fullpath,
    this.regStageName1,
    this.regStageName2,
    this.gradeId,
    this.studntGradeName1,
    this.studntGradeName2,
    this.studntClassName1,
    this.studntClassName2,
    this.photo1,
    this.responsibileName1,
    this.responsibileName2,
    this.studentAttendenceAbsenceLate,
    this.studentGradeTimetable,
    this.sickLeaveArEnVersion,
    this.travelPermission,
    this.studentEmails,
  });

  StudentDto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name11 = json['name_1_1'];
    name12 = json['name_1_2'];
    name13 = json['name_1_3'];
    name14 = json['name_1_4'];
    name15 = json['name_1_5'];
    name1 = json['name_1'];
    name21 = json['name_2_1'];
    name22 = json['name_2_2'];
    name23 = json['name_2_3'];
    name24 = json['name_2_4'];
    name25 = json['name_2_5'];
    name2 = json['name_2'];
    tel1 = json['tel_1'];
    tel2 = json['tel_2'];
    fax = json['fax'];
    address1 = json['address_1'];
    address2 = json['address_2'];
    birthDate = json['birth_date'];
    idNo = json['id_no'];
    photo1Fullpath = json['photo_1_fullpath'];
    regStageName1 = json['reg_stage_name_1'];
    regStageName2 = json['reg_stage_name_2'];
    gradeId = json['grade_id'];
    studntGradeName1 = json['studnt_grade_name_1'];
    studntGradeName2 = json['studnt_grade_name_2'];
    studntClassName1 = json['studnt_class_name_1'];
    studntClassName2 = json['studnt_class_name_2'];
    photo1 = json['photo_1'];
    responsibileName1 = json['responsibile_name_1'];
    responsibileName2 = json['responsibile_name_2'];
    sickLeaveArEnVersion = json['sickLeaveArEnVersion'];
    travelPermission = json['travelPermission'];
    if (json['student_attendence_absence_late'] != null) {
      studentAttendenceAbsenceLate = <StudentAttendenceAbsenceLate>[];
      json['student_attendence_absence_late'].forEach((v) {
        studentAttendenceAbsenceLate!.add(
          StudentAttendenceAbsenceLate.fromJson(v),
        );
      });
    }
    if (json['student_GradeTimetable'] != null) {
      studentGradeTimetable = <StudentGradeTimetable>[];
      json['student_GradeTimetable'].forEach((v) {
        studentGradeTimetable!.add(StudentGradeTimetable.fromJson(v));
      });
    }
    if (json['studentEmails'] != null) {
      studentEmails = <StudentEmails>[];
      json['studentEmails'].forEach((v) {
        studentEmails!.add(StudentEmails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['name_1_1'] = name11;
    data['name_1_2'] = name12;
    data['name_1_3'] = name13;
    data['name_1_4'] = name14;
    data['name_1_5'] = name15;
    data['name_1'] = name1;
    data['name_2_1'] = name21;
    data['name_2_2'] = name22;
    data['name_2_3'] = name23;
    data['name_2_4'] = name24;
    data['name_2_5'] = name25;
    data['name_2'] = name2;
    data['tel_1'] = tel1;
    data['tel_2'] = tel2;
    data['fax'] = fax;
    data['address_1'] = address1;
    data['address_2'] = address2;
    data['birth_date'] = birthDate;
    data['id_no'] = idNo;
    data['photo_1_fullpath'] = photo1Fullpath;
    data['reg_stage_name_1'] = regStageName1;
    data['reg_stage_name_2'] = regStageName2;
    data['grade_id'] = gradeId;
    data['studnt_grade_name_1'] = studntGradeName1;
    data['studnt_grade_name_2'] = studntGradeName2;
    data['studnt_class_name_1'] = studntClassName1;
    data['studnt_class_name_2'] = studntClassName2;
    data['photo_1'] = photo1;
    data['responsibile_name_1'] = responsibileName1;
    data['responsibile_name_2'] = responsibileName2;
    data['sickLeaveArEnVersion'] = sickLeaveArEnVersion;
    data['travelPermission'] = travelPermission;
    if (studentAttendenceAbsenceLate != null) {
      data['student_attendence_absence_late'] = studentAttendenceAbsenceLate!
          .map((v) => v.toJson())
          .toList();
    }
    if (studentGradeTimetable != null) {
      data['student_GradeTimetable'] = studentGradeTimetable!
          .map((v) => v.toJson())
          .toList();
    }
    if (studentEmails != null) {
      data['studentEmails'] = studentEmails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StudentAttendenceAbsenceLate {
  int? studentId;
  String? extStudentId;
  int? attYear;
  int? attMonth;
  String? attDate;
  int? attLateMins;
  int? dayNo;
  bool? isAbsence;
  String? absence;
  String? day_namear;
  String? studntName1;
  String? studntName2;
  String? studntGradeName1;
  String? studntGradeName2;
  int? studntGradeId;
  int? studntClassId;
  String? studntClassName1;
  String? studntClassName2;
  bool? isAvailableToUploadFile;
  bool? attLateWithPermission;
  dynamic attLateFile;
  String? dayAbsenceFile;
  bool? absenceApproved;
  int? status;

  StudentAttendenceAbsenceLate({
    this.studentId,
    this.extStudentId,
    this.attYear,
    this.attMonth,
    this.attDate,
    this.attLateMins,
    this.dayNo,
    this.isAbsence,
    this.absence,
    this.day_namear,
    this.studntName1,
    this.studntName2,
    this.studntGradeName1,
    this.studntGradeName2,
    this.studntGradeId,
    this.studntClassId,
    this.studntClassName1,
    this.studntClassName2,
    this.isAvailableToUploadFile,
    this.attLateWithPermission,
    this.attLateFile,
    this.dayAbsenceFile,
    this.absenceApproved,
    this.status,
  });

  StudentAttendenceAbsenceLate.fromJson(Map<String, dynamic> json) {
    studentId = json['student_id'];
    extStudentId = json['ext_student_id'];
    attYear = json['att_year'];
    attMonth = json['att_month'];
    attDate = json['att_date'];
    attLateMins = (json['att_late_mins'] as num?)?.toInt();
    dayNo = json['day_no'];
    isAbsence = json['isAbsence'];
    absence = json['absence'];
    day_namear = json['day_namear'];
    studntName1 = json['studnt_name_1'];
    studntName2 = json['studnt_name_2'];
    studntGradeName1 = json['studnt_grade_name_1'];
    studntGradeName2 = json['studnt_grade_name_2'];
    studntGradeId = json['studnt_grade_id'];
    studntClassId = json['studnt_class_id'];
    studntClassName1 = json['studnt_class_name_1'];
    studntClassName2 = json['studnt_class_name_2'];
    isAvailableToUploadFile = json['isAvailableToUploadFile'];
    attLateWithPermission = json['att_late_with_permission'];
    attLateFile = json['att_late_file'];
    dayAbsenceFile = json['day_absence_file'];
    absenceApproved = json['absence_approved'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['student_id'] = studentId;
    data['ext_student_id'] = extStudentId;
    data['att_year'] = attYear;
    data['att_month'] = attMonth;
    data['att_date'] = attDate;
    data['att_late_mins'] = attLateMins;
    data['day_no'] = dayNo;
    data['isAbsence'] = isAbsence;
    data['absence'] = absence;
    data['day_namear'] = day_namear;
    data['studnt_name_1'] = studntName1;
    data['studnt_name_2'] = studntName2;
    data['studnt_grade_name_1'] = studntGradeName1;
    data['studnt_grade_name_2'] = studntGradeName2;
    data['studnt_grade_id'] = studntGradeId;
    data['studnt_class_id'] = studntClassId;
    data['studnt_class_name_1'] = studntClassName1;
    data['studnt_class_name_2'] = studntClassName2;
    data['isAvailableToUploadFile'] = isAvailableToUploadFile;
    data['att_late_with_permission'] = attLateWithPermission;
    data['att_late_file'] = attLateFile;
    data['day_absence_file'] = dayAbsenceFile;
    data['absence_approved'] = absenceApproved;
    data['status'] = status;
    return data;
  }
}

class StudentGradeTimetable {
  int? id;
  int? gradeId;
  int? timetableTypeId;
  String? dayNameAr;
  String? dayNameEn;
  int? dayNo;
  dynamic bolckId;
  String? bolck1TimeFrom;
  String? bolck1TimeTill;
  int? bolck1AttAllowTime;
  bool? bolck1AtStart;
  String? bolck2TimeFrom;
  String? bolck2TimeTill;
  int? bolck2AttAllowTime;
  bool? bolck2AtStart;
  String? bolck3TimeFrom;
  String? bolck3TimeTill;
  int? bolck3AttAllowTime;
  bool? bolck3AtStart;
  String? bolck4TimeFrom;
  String? bolck4TimeTill;
  int? bolck4AttAllowTime;
  bool? bolck4AtStart;
  String? bolck5TimeFrom;
  String? bolck5TimeTill;
  int? bolck5AttAllowTime;
  bool? bolck5AtStart;
  String? bolck6TimeFrom;
  String? bolck6TimeTill;
  int? bolck6AttAllowTime;
  bool? bolck6AtStart;
  String? bolck7TimeFrom;
  String? bolck7TimeTill;
  int? bolck7AttAllowTime;
  bool? bolck7AtStart;
  String? bolck8TimeFrom;
  String? bolck8TimeTill;
  int? bolck8AttAllowTime;
  bool? bolck8AtStart;
  dynamic bolck0TimeFrom;
  dynamic bolck0TimeTill;
  dynamic bolck0AttAllowTime;
  bool? bolck0AtStart;
  dynamic bolck9TimeFrom;
  dynamic bolck9TimeTill;
  dynamic bolck9AttAllowTime;
  bool? bolck9AtStart;
  dynamic assemblyTimeFrom;
  dynamic assemblyTimeTill;
  dynamic assemblyAttAllowTime;
  bool? assemblyAtStart;
  dynamic quranSessionTimeFrom;
  dynamic quranSessionTimeTill;
  dynamic quranSessionAttAllowTime;
  dynamic quranSessionAtStart;
  dynamic creationBy;
  dynamic creationDate;
  dynamic modifyBy;
  String? modifyDate;
  dynamic deleteBy;
  dynamic deleteDate;
  dynamic isDeleted;
  dynamic dayNoList;

  StudentGradeTimetable({
    this.id,
    this.gradeId,
    this.timetableTypeId,
    this.dayNameAr,
    this.dayNameEn,
    this.dayNo,
    this.bolckId,
    this.bolck1TimeFrom,
    this.bolck1TimeTill,
    this.bolck1AttAllowTime,
    this.bolck1AtStart,
    this.bolck2TimeFrom,
    this.bolck2TimeTill,
    this.bolck2AttAllowTime,
    this.bolck2AtStart,
    this.bolck3TimeFrom,
    this.bolck3TimeTill,
    this.bolck3AttAllowTime,
    this.bolck3AtStart,
    this.bolck4TimeFrom,
    this.bolck4TimeTill,
    this.bolck4AttAllowTime,
    this.bolck4AtStart,
    this.bolck5TimeFrom,
    this.bolck5TimeTill,
    this.bolck5AttAllowTime,
    this.bolck5AtStart,
    this.bolck6TimeFrom,
    this.bolck6TimeTill,
    this.bolck6AttAllowTime,
    this.bolck6AtStart,
    this.bolck7TimeFrom,
    this.bolck7TimeTill,
    this.bolck7AttAllowTime,
    this.bolck7AtStart,
    this.bolck8TimeFrom,
    this.bolck8TimeTill,
    this.bolck8AttAllowTime,
    this.bolck8AtStart,
    this.bolck0TimeFrom,
    this.bolck0TimeTill,
    this.bolck0AttAllowTime,
    this.bolck0AtStart,
    this.bolck9TimeFrom,
    this.bolck9TimeTill,
    this.bolck9AttAllowTime,
    this.bolck9AtStart,
    this.assemblyTimeFrom,
    this.assemblyTimeTill,
    this.assemblyAttAllowTime,
    this.assemblyAtStart,
    this.quranSessionTimeFrom,
    this.quranSessionTimeTill,
    this.quranSessionAttAllowTime,
    this.quranSessionAtStart,
    this.creationBy,
    this.creationDate,
    this.modifyBy,
    this.modifyDate,
    this.deleteBy,
    this.deleteDate,
    this.isDeleted,
    this.dayNoList,
  });

  StudentGradeTimetable.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    gradeId = json['grade_id'];
    timetableTypeId = json['timetableTypeId'];
    dayNameAr = json['day_name_ar'];
    dayNameEn = json['day_name_en'];
    dayNo = json['day_no'];
    bolckId = json['bolck_id'];
    bolck1TimeFrom = json['bolck1_time_from'];
    bolck1TimeTill = json['bolck1_time_till'];
    bolck1AttAllowTime = json['bolck1_att_allow_time'];
    bolck1AtStart = json['bolck1_at_start'];
    bolck2TimeFrom = json['bolck2_time_from'];
    bolck2TimeTill = json['bolck2_time_till'];
    bolck2AttAllowTime = json['bolck2_att_allow_time'];
    bolck2AtStart = json['bolck2_at_start'];
    bolck3TimeFrom = json['bolck3_time_from'];
    bolck3TimeTill = json['bolck3_time_till'];
    bolck3AttAllowTime = json['bolck3_att_allow_time'];
    bolck3AtStart = json['bolck3_at_start'];
    bolck4TimeFrom = json['bolck4_time_from'];
    bolck4TimeTill = json['bolck4_time_till'];
    bolck4AttAllowTime = json['bolck4_att_allow_time'];
    bolck4AtStart = json['bolck4_at_start'];
    bolck5TimeFrom = json['bolck5_time_from'];
    bolck5TimeTill = json['bolck5_time_till'];
    bolck5AttAllowTime = json['bolck5_att_allow_time'];
    bolck5AtStart = json['bolck5_at_start'];
    bolck6TimeFrom = json['bolck6_time_from'];
    bolck6TimeTill = json['bolck6_time_till'];
    bolck6AttAllowTime = json['bolck6_att_allow_time'];
    bolck6AtStart = json['bolck6_at_start'];
    bolck7TimeFrom = json['bolck7_time_from'];
    bolck7TimeTill = json['bolck7_time_till'];
    bolck7AttAllowTime = json['bolck7_att_allow_time'];
    bolck7AtStart = json['bolck7_at_start'];
    bolck8TimeFrom = json['bolck8_time_from'];
    bolck8TimeTill = json['bolck8_time_till'];
    bolck8AttAllowTime = json['bolck8_att_allow_time'];
    bolck8AtStart = json['bolck8_at_start'];
    bolck0TimeFrom = json['bolck0_time_from'];
    bolck0TimeTill = json['bolck0_time_till'];
    bolck0AttAllowTime = json['bolck0_att_allow_time'];
    bolck0AtStart = json['bolck0_at_start'];
    bolck9TimeFrom = json['bolck9_time_from'];
    bolck9TimeTill = json['bolck9_time_till'];
    bolck9AttAllowTime = json['bolck9_att_allow_time'];
    bolck9AtStart = json['bolck9_at_start'];
    assemblyTimeFrom = json['assembly_time_from'];
    assemblyTimeTill = json['assembly_time_till'];
    assemblyAttAllowTime = json['assembly_att_allow_time'];
    assemblyAtStart = json['assembly_at_start'];
    quranSessionTimeFrom = json['quranSession_time_from'];
    quranSessionTimeTill = json['quranSession_time_till'];
    quranSessionAttAllowTime = json['quranSession_att_allow_time'];
    quranSessionAtStart = json['quranSession_at_start'];
    creationBy = json['creation_by'];
    creationDate = json['creation_date'];
    modifyBy = json['modify_by'];
    modifyDate = json['modify_date'];
    deleteBy = json['delete_by'];
    deleteDate = json['delete_date'];
    isDeleted = json['is_deleted'];
    dayNoList = json['day_no_list'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['grade_id'] = gradeId;
    data['timetableTypeId'] = timetableTypeId;
    data['day_name_ar'] = dayNameAr;
    data['day_name_en'] = dayNameEn;
    data['day_no'] = dayNo;
    data['bolck_id'] = bolckId;
    data['bolck1_time_from'] = bolck1TimeFrom;
    data['bolck1_time_till'] = bolck1TimeTill;
    data['bolck1_att_allow_time'] = bolck1AttAllowTime;
    data['bolck1_at_start'] = bolck1AtStart;
    data['bolck2_time_from'] = bolck2TimeFrom;
    data['bolck2_time_till'] = bolck2TimeTill;
    data['bolck2_att_allow_time'] = bolck2AttAllowTime;
    data['bolck2_at_start'] = bolck2AtStart;
    data['bolck3_time_from'] = bolck3TimeFrom;
    data['bolck3_time_till'] = bolck3TimeTill;
    data['bolck3_att_allow_time'] = bolck3AttAllowTime;
    data['bolck3_at_start'] = bolck3AtStart;
    data['bolck4_time_from'] = bolck4TimeFrom;
    data['bolck4_time_till'] = bolck4TimeTill;
    data['bolck4_att_allow_time'] = bolck4AttAllowTime;
    data['bolck4_at_start'] = bolck4AtStart;
    data['bolck5_time_from'] = bolck5TimeFrom;
    data['bolck5_time_till'] = bolck5TimeTill;
    data['bolck5_att_allow_time'] = bolck5AttAllowTime;
    data['bolck5_at_start'] = bolck5AtStart;
    data['bolck6_time_from'] = bolck6TimeFrom;
    data['bolck6_time_till'] = bolck6TimeTill;
    data['bolck6_att_allow_time'] = bolck6AttAllowTime;
    data['bolck6_at_start'] = bolck6AtStart;
    data['bolck7_time_from'] = bolck7TimeFrom;
    data['bolck7_time_till'] = bolck7TimeTill;
    data['bolck7_att_allow_time'] = bolck7AttAllowTime;
    data['bolck7_at_start'] = bolck7AtStart;
    data['bolck8_time_from'] = bolck8TimeFrom;
    data['bolck8_time_till'] = bolck8TimeTill;
    data['bolck8_att_allow_time'] = bolck8AttAllowTime;
    data['bolck8_at_start'] = bolck8AtStart;
    data['bolck0_time_from'] = bolck0TimeFrom;
    data['bolck0_time_till'] = bolck0TimeTill;
    data['bolck0_att_allow_time'] = bolck0AttAllowTime;
    data['bolck0_at_start'] = bolck0AtStart;
    data['bolck9_time_from'] = bolck9TimeFrom;
    data['bolck9_time_till'] = bolck9TimeTill;
    data['bolck9_att_allow_time'] = bolck9AttAllowTime;
    data['bolck9_at_start'] = bolck9AtStart;
    data['assembly_time_from'] = assemblyTimeFrom;
    data['assembly_time_till'] = assemblyTimeTill;
    data['assembly_att_allow_time'] = assemblyAttAllowTime;
    data['assembly_at_start'] = assemblyAtStart;
    data['quranSession_time_from'] = quranSessionTimeFrom;
    data['quranSession_time_till'] = quranSessionTimeTill;
    data['quranSession_att_allow_time'] = quranSessionAttAllowTime;
    data['quranSession_at_start'] = quranSessionAtStart;
    data['creation_by'] = creationBy;
    data['creation_date'] = creationDate;
    data['modify_by'] = modifyBy;
    data['modify_date'] = modifyDate;
    data['delete_by'] = deleteBy;
    data['delete_date'] = deleteDate;
    data['is_deleted'] = isDeleted;
    data['day_no_list'] = dayNoList;
    return data;
  }
}

class StudentEmails {
  int? studentId;
  int? fKEmailTypeID;
  String? email;
  String? password;
  String? emailTypeNameAR;
  String? emailTypeNameEN;

  StudentEmails({
    this.studentId,
    this.fKEmailTypeID,
    this.email,
    this.password,
    this.emailTypeNameAR,
    this.emailTypeNameEN,
  });

  StudentEmails.fromJson(Map<String, dynamic> json) {
    studentId = json['student_Id'];
    fKEmailTypeID = json['fK_EmailTypeID'];
    email = json['email'];
    password = json['password'];
    emailTypeNameAR = json['emailType_NameAR'];
    emailTypeNameEN = json['emailType_NameEN'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['student_Id'] = studentId;
    data['fK_EmailTypeID'] = fKEmailTypeID;
    data['email'] = email;
    data['password'] = password;
    data['emailType_NameAR'] = emailTypeNameAR;
    data['emailType_NameEN'] = emailTypeNameEN;
    return data;
  }
}
