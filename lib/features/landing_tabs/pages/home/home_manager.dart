import 'package:flutter/foundation.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:ghars_school/app_core/app_core.dart';
import 'package:ghars_school/features/landing_tabs/pages/home/home_repo.dart';
import 'package:ghars_school/features/landing_tabs/pages/home/models/home_dashboard_data.dart';
import 'package:rxdart/rxdart.dart';

class HomeManager extends Manager {
  final HomeRepo _repo = HomeRepo();
  final PrefsService _prefs = locator<PrefsService>();

  final BehaviorSubject<ManagerState> _stateSubject =
      BehaviorSubject<ManagerState>.seeded(ManagerState.idle);

  // Expose the combined dashboard data stream. It is NOT seeded so that Observer
  // shows the loading skeleton/spinner during the initial API load.
  final BehaviorSubject<HomeDashboardData> _dashboardDataSubject =
      BehaviorSubject<HomeDashboardData>();

  Stream<ManagerState> get state$ => _stateSubject.stream;
  Sink<ManagerState> get inState => _stateSubject.sink;

  Stream<HomeDashboardData> get dashboardData$ => _dashboardDataSubject.stream;

  String? errorDescription;

  Future<void> initDashboard({bool isRefresh = false}) async {
    if (_stateSubject.value == ManagerState.loading) return;

    bool hasCache = false;
    errorDescription = null;

    final user = _prefs.userObj;
    final isLoggedIn = user != null && user.token != null;
    final isParent = isLoggedIn && user.userType == 'Parent';
    final isEmployee = isLoggedIn && user.userType == 'Employee';

    // 1. Instant Cache Fetch (Phase 1)
    if (!isRefresh) {
      try {
        final cacheData = await _fetchData(isLoggedIn, isParent, isEmployee, CachePolicy.forceCache);
        if (cacheData != null) {
          _dashboardDataSubject.add(cacheData);
          inState.add(ManagerState.success);
          hasCache = true;
        }
      } catch (_) {
        // Ignore cache misses
      }
    }

    if (!hasCache && !isRefresh) {
      inState.add(ManagerState.loading);
    }

    // 2. Network Sync (Phase 2)
    try {
      final netData = await _fetchData(isLoggedIn, isParent, isEmployee, CachePolicy.refreshForceCache);
      if (netData != null) {
        _dashboardDataSubject.add(netData);
        if (!hasCache || _stateSubject.value != ManagerState.success) {
          inState.add(ManagerState.success);
        }
      } else if (!hasCache) {
        throw Exception("Failed to load dashboard data");
      }
    } catch (e) {
      if (!hasCache) {
        errorDescription = e.toString();
        _dashboardDataSubject.addError(e);
        inState.add(ManagerState.error);
      } else {
        debugPrint("Background sync failed for home: $e");
      }
    }
  }

  Future<HomeDashboardData?> _fetchData(
    bool isLoggedIn, 
    bool isParent, 
    bool isEmployee, 
    CachePolicy policy
  ) async {
    HomeDashboardData data = HomeDashboardData(images: []);
    
    if (isLoggedIn) {
      if (isParent) {
        final parentRes = await _repo.getParentDashboard(cachePolicy: policy);
        if (parentRes == null || parentRes.data == null) throw Exception("Failed to load");
        data = data.copyWith(parentData: parentRes.data);
      } else if (isEmployee) {
        final employeeRes = await _repo.getEmployeeDashboard(cachePolicy: policy);
        if (employeeRes == null || employeeRes.data == null) throw Exception("Failed to load");
        data = data.copyWith(employeeData: employeeRes.data);
      }
      
      // Fetch gallery images non-blockingly
      try {
        final imagesRes = await _repo.getDashboardImages(cachePolicy: policy);
        if (imagesRes != null && imagesRes.data != null) {
          data = data.copyWith(images: imagesRes.data);
        }
      } catch (e) {
        debugPrint("Gallery fetch failed: $e");
      }
    } else {
      // Guest user
      final imagesRes = await _repo.getDashboardImages(cachePolicy: policy);
      if (imagesRes == null || imagesRes.data == null) throw Exception("Failed to load images");
      data = data.copyWith(images: imagesRes.data);
    }

    return data;
  }

  Future<void> refreshDashboard() async {
    await initDashboard(isRefresh: true);
  }

  @override
  void dispose() {
    _stateSubject.close();
    _dashboardDataSubject.close();
  }
}
