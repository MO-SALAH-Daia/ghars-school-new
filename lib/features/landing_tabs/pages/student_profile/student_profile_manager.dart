import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/foundation.dart';
import 'package:ghars_school/app_core/app_core.dart';
import 'package:ghars_school/features/landing_tabs/pages/home/home_manager.dart';
import 'package:ghars_school/features/landing_tabs/pages/home/models/parent_dashboard_model.dart'
    as parent_model;
import 'package:ghars_school/features/landing_tabs/pages/student_profile/models/student_profile_model.dart';
import 'package:ghars_school/features/landing_tabs/pages/student_profile/student_profile_repo.dart';
import 'package:rxdart/rxdart.dart';

class StudentProfileManager extends Manager {
  final StudentProfileRepo _repo = StudentProfileRepo();

  final BehaviorSubject<ManagerState> _stateSubject =
      BehaviorSubject<ManagerState>.seeded(ManagerState.idle);
  Stream<ManagerState> get state$ => _stateSubject.stream;
  Sink<ManagerState> get inState => _stateSubject.sink;

  final BehaviorSubject<int> _selectedTabSubject = BehaviorSubject<int>.seeded(
    0,
  );
  Stream<int> get selectedTab$ => _selectedTabSubject.stream;
  int get currentTab => _selectedTabSubject.value;

  final BehaviorSubject<parent_model.StudentDto?> _selectedStudentSubject =
      BehaviorSubject<parent_model.StudentDto?>();
  Stream<parent_model.StudentDto?> get selectedStudent$ =>
      _selectedStudentSubject.stream;

  final BehaviorSubject<StudentProfilesModel?> _studentDetailsSubject =
      BehaviorSubject<StudentProfilesModel?>();
  Stream<StudentProfilesModel?> get studentDetails$ =>
      _studentDetailsSubject.stream;

  String? errorDescription;

  void init() {
    final homeManager = locator<HomeManager>();
    // Try to get the first student available in HomeManager
    final data = homeManager.currentDashboardData;
    if (data != null && data.parentData != null) {
      final students = data.parentData!.studentDtos;
      if (students != null && students.isNotEmpty) {
        selectStudent(students.first);
      }
    } else {
      // Also listen for data changes
      homeManager.dashboardData$.listen((newData) {
        if ((!_selectedStudentSubject.hasValue ||
                _selectedStudentSubject.value == null) &&
            newData.parentData != null) {
          final students = newData.parentData!.studentDtos;
          if (students != null && students.isNotEmpty) {
            selectStudent(students.first);
          }
        }
      });
    }
  }

  void selectTab(int index) {
    _selectedTabSubject.add(index);
  }

  Future<void> selectStudent(parent_model.StudentDto student) async {
    _selectedStudentSubject.add(student);
    _studentDetailsSubject.add(null);
    errorDescription = null;

    if (student.id == null) {
      inState.add(ManagerState.error);
      return;
    }

    bool hasCache = false;

    // 1. Instant Cache Fetch
    try {
      final cacheData = await _repo.getStudentDetails(
        studentId: student.id!,
        cachePolicy: CachePolicy.forceCache,
      );
      if (cacheData != null && cacheData.data != null) {
        _studentDetailsSubject.add(cacheData.data);
        inState.add(ManagerState.success);
        hasCache = true;
      }
    } catch (_) {
      // Ignore cache misses
    }

    if (!hasCache) {
      inState.add(ManagerState.loading);
    }

    // 2. Network Fetch
    try {
      final netData = await _repo.getStudentDetails(
        studentId: student.id!,
        cachePolicy: CachePolicy.refreshForceCache,
      );
      if (netData != null && netData.data != null) {
        _studentDetailsSubject.add(netData.data);
        if (!hasCache || _stateSubject.value != ManagerState.success) {
          inState.add(ManagerState.success);
        }
      } else if (!hasCache) {
        _studentDetailsSubject.add(null);
        inState.add(ManagerState.success);
      }
    } catch (e) {
      if (!hasCache) {
        errorDescription = e.toString();
        _studentDetailsSubject.addError(e);
        inState.add(ManagerState.error);
      } else {
        debugPrint("Background sync failed for student profile: $e");
      }
    }
  }

  @override
  void dispose() {
    _stateSubject.close();
    _selectedTabSubject.close();
    _selectedStudentSubject.close();
    _studentDetailsSubject.close();
  }
}
