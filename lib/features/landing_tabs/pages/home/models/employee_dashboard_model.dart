class EmployeeDashboardModel {
  final int? allStudentRequest;
  final int? allStudentRequestRequested;
  final int? allStudentRequestPending;
  final int? allStudentRequestInterviewed;
  final int? allStudentRequestAccepted;
  final int? allStudentRequestApproved;
  final int? allStudentRequestRejected;
  final int? allStudentRequestWaited;
  final int? notSeenNotificationsCount;

  EmployeeDashboardModel({
    this.allStudentRequest = 0,
    this.allStudentRequestRequested = 0,
    this.allStudentRequestPending = 0,
    this.allStudentRequestInterviewed = 0,
    this.allStudentRequestAccepted = 0,
    this.allStudentRequestApproved = 0,
    this.allStudentRequestRejected = 0,
    this.allStudentRequestWaited = 0,
    this.notSeenNotificationsCount = 0,
  });

  factory EmployeeDashboardModel.fromJson(Map<String, dynamic> json) {
    return EmployeeDashboardModel(
      allStudentRequest: json["allStudentRequest"] as int? ?? 0,
      allStudentRequestRequested: json["aLLStudentRequestRequested"] as int? ?? 0,
      allStudentRequestPending: json["allStudentRequestPending"] as int? ?? 0,
      allStudentRequestInterviewed: json["allStudentRequestInterviewed"] as int? ?? 0,
      allStudentRequestAccepted: json["allStudentRequestAccepted"] as int? ?? 0,
      allStudentRequestApproved: json["allStudentRequestApproved"] as int? ?? 0,
      allStudentRequestRejected: json["allStudentRequestRejected"] as int? ?? 0,
      allStudentRequestWaited: json["aLLStudentRequestWaited"] as int? ?? 0,
      notSeenNotificationsCount: json["notSeenNotificationsCount"] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "allStudentRequest": allStudentRequest,
      "aLLStudentRequestRequested": allStudentRequestRequested,
      "allStudentRequestPending": allStudentRequestPending,
      "allStudentRequestInterviewed": allStudentRequestInterviewed,
      "allStudentRequestAccepted": allStudentRequestAccepted,
      "allStudentRequestApproved": allStudentRequestApproved,
      "allStudentRequestRejected": allStudentRequestRejected,
      "aLLStudentRequestWaited": allStudentRequestWaited,
      "notSeenNotificationsCount": notSeenNotificationsCount,
    };
  }
}
