import 'package:flutter/foundation.dart';
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

  Future<void> initDashboard() async {
    if (_stateSubject.value == ManagerState.loading) return;

    inState.add(ManagerState.loading);
    errorDescription = null;

    try {
      final user = _prefs.userObj;
      final isLoggedIn = user != null && user.token != null;

      if (isLoggedIn) {
        if (user.userType == 'Parent') {
          // Fetch parent stats first (very fast)
          final parentRes = await _repo.getParentDashboard();
          if (parentRes == null) {
            throw Exception("Failed to load dashboard data");
          }

          final data = HomeDashboardData(
            images: [],
            parentData: parentRes.data,
          );
          _dashboardDataSubject.add(data);
          inState.add(ManagerState.success);

          // Fetch gallery images in the background
          _loadGalleryImagesBackground();
        } else if (user.userType == 'Employee') {
          // Fetch employee stats first (very fast)
          final employeeRes = await _repo.getEmployeeDashboard();
          if (employeeRes == null) {
            throw Exception("Failed to load dashboard data");
          }

          final data = HomeDashboardData(
            images: [],
            employeeData: employeeRes.data,
          );
          _dashboardDataSubject.add(data);
          inState.add(ManagerState.success);

          // Fetch gallery images in the background
          _loadGalleryImagesBackground();
        } else {
          // Fallback if role is unknown but logged in
          final data = HomeDashboardData(images: []);
          _dashboardDataSubject.add(data);
          inState.add(ManagerState.success);
          _loadGalleryImagesBackground();
        }
      } else {
        // Guest user - only load gallery images
        final imagesRes = await _repo.getDashboardImages();
        final data = HomeDashboardData(
          images: imagesRes?.data ?? [],
        );
        _dashboardDataSubject.add(data);
        inState.add(ManagerState.success);
      }
    } catch (e) {
      errorDescription = e.toString();
      _dashboardDataSubject.addError(e);
      inState.add(ManagerState.error);
    }
  }

  Future<void> _loadGalleryImagesBackground() async {
    try {
      final imagesRes = await _repo.getDashboardImages();
      if (imagesRes != null && imagesRes.data != null) {
        final currentData = _dashboardDataSubject.valueOrNull ?? HomeDashboardData(images: []);
        final updatedData = currentData.copyWith(images: imagesRes.data);
        _dashboardDataSubject.add(updatedData);
      }
    } catch (e) {
      // Background image loading failures shouldn't crash the home screen
      debugPrint("Background gallery images fetch failed: $e");
    }
  }

  Future<void> refreshDashboard() async {
    await initDashboard();
  }

  @override
  void dispose() {
    _stateSubject.close();
    _dashboardDataSubject.close();
  }
}
