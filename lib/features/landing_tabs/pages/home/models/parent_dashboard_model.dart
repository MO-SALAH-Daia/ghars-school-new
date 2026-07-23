class ParentDashboardModel {
  final ParentDashboardDto? parentDashboardDto;
  final List<ParentInvoiceDetailDto>? parentInvoiceDetailDtos;
  final List<StudentDto>? studentDtos;
  final List<StudentRequestDto>? studentRequestDtos;
  final List<ParentInvoiceDetailDto>? paidParentInvoiceDetailDtos;
  final int? notSeenNotificationsCount;

  ParentDashboardModel({
    this.parentDashboardDto,
    this.parentInvoiceDetailDtos,
    this.studentDtos,
    this.studentRequestDtos,
    this.paidParentInvoiceDetailDtos,
    this.notSeenNotificationsCount,
  });

  factory ParentDashboardModel.fromJson(Map<String, dynamic> json) {
    return ParentDashboardModel(
      parentDashboardDto: json["parentDashboardDto"] == null
          ? null
          : ParentDashboardDto.fromJson(json["parentDashboardDto"]),
      parentInvoiceDetailDtos: json["parentInvoiceDetailDtos"] == null
          ? null
          : List<ParentInvoiceDetailDto>.from(
              (json["parentInvoiceDetailDtos"] as List)
                  .map((x) => ParentInvoiceDetailDto.fromJson(x))),
      studentDtos: json["studentDtos"] == null
          ? null
          : List<StudentDto>.from(
              (json["studentDtos"] as List).map((x) => StudentDto.fromJson(x))),
      studentRequestDtos: json["studentRequestDtos"] == null
          ? null
          : List<StudentRequestDto>.from(
              (json["studentRequestDtos"] as List)
                  .map((x) => StudentRequestDto.fromJson(x))),
      paidParentInvoiceDetailDtos: json["paidParentInvoiceDetailDtos"] == null
          ? null
          : List<ParentInvoiceDetailDto>.from(
              (json["paidParentInvoiceDetailDtos"] as List)
                  .map((x) => ParentInvoiceDetailDto.fromJson(x))),
      notSeenNotificationsCount: json["notSeenNotificationsCount"] as int?,
    );
  }
}

class ParentDashboardDto {
  final int? allStudent;
  final int? allInvoice;
  final int? allInvoiceDetail;
  final int? allInvoiceDetailPaid;
  final int? allStudentRequest;

  ParentDashboardDto({
    this.allStudent,
    this.allInvoice,
    this.allInvoiceDetail,
    this.allInvoiceDetailPaid,
    this.allStudentRequest,
  });

  factory ParentDashboardDto.fromJson(Map<String, dynamic> json) {
    return ParentDashboardDto(
      allStudent: json["allStudent"] as int?,
      allStudentRequest: json["allStudentRequest"] as int?,
      allInvoice: json["allInvoice"] as int?,
      allInvoiceDetailPaid: json["allInvoiceDetailPaid"] as int?,
      allInvoiceDetail: json["allInvoiceDetail"] as int?,
    );
  }
}

class ParentInvoiceDetailDto {
  final int? saleInvoiceId;
  final String? number;
  final DateTime? date;
  final double? amount;
  final String? notes;
  final int? studentId;
  final String? studentArabicName;
  final String? studentEnglishName;
  final int? detailId;
  final String? itemArabicName;
  final String? itemEnglishName;
  final int? installmentNo;
  final double? detailDiscount;
  final int? saleInvoiceTypeId;
  double? detailAmount;
  double? detailAmountWanted;
  final double? totalPaid;

  ParentInvoiceDetailDto({
    this.saleInvoiceId,
    this.number,
    this.date,
    this.amount,
    this.notes,
    this.studentId,
    this.studentArabicName,
    this.studentEnglishName,
    this.detailId,
    this.itemArabicName,
    this.itemEnglishName,
    this.installmentNo,
    this.detailDiscount,
    this.saleInvoiceTypeId,
    this.detailAmount,
    this.detailAmountWanted,
    this.totalPaid,
  });

  factory ParentInvoiceDetailDto.fromJson(Map<String, dynamic> json) {
    final double amt = (json["amount"] != null) ? double.parse(json["amount"].toString()) : 0.0;
    final double detAmt = (json["detailAmount"] != null) ? double.parse(json["detailAmount"].toString()) : 0.0;
    final double totPaid = (json["totalPaid"] != null) ? double.parse(json["totalPaid"].toString()) : 0.0;

    return ParentInvoiceDetailDto(
      saleInvoiceId: json["saleInvoiceId"] as int?,
      number: json["number"] as String?,
      date: json["date"] != null ? DateTime.tryParse(json["date"].toString()) : null,
      amount: amt,
      notes: json["notes"] as String?,
      studentId: json["studentId"] as int?,
      studentArabicName: json["studentArabicName"] as String?,
      studentEnglishName: json["studentEnglishName"] as String?,
      detailId: json["detailId"] as int?,
      itemArabicName: json["itemArabicName"] as String?,
      itemEnglishName: json["itemEnglishName"] as String?,
      installmentNo: json["installmentNo"] as int?,
      detailDiscount: (json["detailDiscount"] != null) ? double.parse(json["detailDiscount"].toString()) : 0.0,
      saleInvoiceTypeId: json["saleInvoiceTypeId"] as int?,
      detailAmount: detAmt,
      detailAmountWanted: detAmt - totPaid,
      totalPaid: totPaid,
    );
  }
}

class StudentDto {
  final int? id;
  final String? code;
  final String? name1;
  final String? name2;
  final String? name_1_1;
  final String? name_2_1;
  final String? imageUrl;
  final String? active;
  final String? stuStatus;
  final String? regStageName1;
  final String? regStageName2;
  final String? regGreadName1;
  final String? regGreadName2;
  final String? regYearsName1;
  final String? regYearsName2;

  StudentDto({
    this.id,
    this.code,
    this.name1,
    this.name2,
    this.name_1_1,
    this.name_2_1,
    this.imageUrl,
    this.active,
    this.stuStatus,
    this.regStageName1,
    this.regStageName2,
    this.regGreadName1,
    this.regGreadName2,
    this.regYearsName1,
    this.regYearsName2,
  });

  factory StudentDto.fromJson(Map<String, dynamic> json) {
    return StudentDto(
      id: json["id"] as int?,
      code: json["code"] as String?,
      name1: json["name_1"] as String?,
      name2: json["name_2"] as String?,
      name_1_1: json["name_1_1"] as String?,
      name_2_1: json["name_2_1"] as String?,
      imageUrl: json["imageUrl"] as String?,
      active: json["active"]?.toString(),
      stuStatus: json["stu_status"]?.toString(),
      regStageName1: json["reg_stage_name_1"] as String?,
      regStageName2: json["reg_stage_name_2"] as String?,
      regGreadName1: json["reg_gread_name_1"] as String?,
      regGreadName2: json["reg_gread_name_2"] as String?,
      regYearsName1: json["reg_years_name_1"] as String?,
      regYearsName2: json["reg_years_name_2"] as String?,
    );
  }
}

class StudentRequestDto {
  final int? id;
  final String? code;
  final String? name_1_1;
  final String? name_2_1;
  final String? regGreadName1;
  final String? regGreadName2;
  final String? regYearsName1;
  final String? regYearsName2;
  final String? status;
  final String? statusAr;
  final String? statusEn;
  final DateTime? lastInterviewDate;
  final String? lastInterviewTimeFrom;
  final String? lastInterviewTimeTo;

  StudentRequestDto({
    this.id,
    this.code,
    this.name_1_1,
    this.name_2_1,
    this.regGreadName1,
    this.regGreadName2,
    this.regYearsName1,
    this.regYearsName2,
    this.status,
    this.statusAr,
    this.statusEn,
    this.lastInterviewDate,
    this.lastInterviewTimeFrom,
    this.lastInterviewTimeTo,
  });

  factory StudentRequestDto.fromJson(Map<String, dynamic> json) {
    return StudentRequestDto(
      id: json["id"] as int?,
      code: json["code"] as String?,
      name_1_1: json["name_1_1"] as String?,
      name_2_1: json["name_2_1"] as String?,
      regGreadName1: json["regGreadName1"] as String?,
      regGreadName2: json["regGreadName2"] as String?,
      regYearsName1: json["regYearsName1"] as String?,
      regYearsName2: json["regYearsName2"] as String?,
      status: json["status"]?.toString(),
      statusAr: json["statusAr"] as String?,
      statusEn: json["statusEn"] as String?,
      lastInterviewDate: json["last_interview_date"] != null
          ? DateTime.tryParse(json["last_interview_date"].toString())
          : null,
      lastInterviewTimeFrom: json["last_interview_time_from"] as String?,
      lastInterviewTimeTo: json["last_interview_time_to"] as String?,
    );
  }
}
