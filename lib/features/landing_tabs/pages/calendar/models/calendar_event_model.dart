class CalendarEventModel {
  int? id;
  String? nameAr;
  String? nameEn;
  String? fromDate;
  String? toDate;

  CalendarEventModel({
    this.id,
    this.nameAr,
    this.nameEn,
    this.fromDate,
    this.toDate,
  });

  factory CalendarEventModel.fromJson(Map<String, dynamic> json) {
    return CalendarEventModel(
      id: json['id'] as int?,
      nameAr: json['namear'] as String?,
      nameEn: json['nameen'] as String?,
      fromDate: json['fromdate'] as String?,
      toDate: json['todate'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'namear': nameAr,
      'nameen': nameEn,
      'fromdate': fromDate,
      'todate': toDate,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalendarEventModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          nameAr == other.nameAr &&
          nameEn == other.nameEn &&
          fromDate == other.fromDate &&
          toDate == other.toDate;

  @override
  int get hashCode => Object.hash(id, nameAr, nameEn, fromDate, toDate);
}
