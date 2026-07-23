import 'package:ghars_school/app_core/app_core.dart';
import 'package:ghars_school/features/landing_tabs/pages/home/home_repo.dart';
import 'package:ghars_school/features/landing_tabs/pages/home/models/gallery_image_model.dart';
import 'package:ghars_school/features/landing_tabs/pages/home/models/parent_dashboard_model.dart';
import 'package:ghars_school/features/landing_tabs/pages/home/models/employee_dashboard_model.dart';
import 'package:ghars_school/features/landing_tabs/pages/home/models/home_dashboard_data.dart';
import 'package:ghars_school/app_core/networking/base_response.dart';
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
          // Parallel execution of gallery and parent dashboard
          final results = await Future.wait([
            _repo.getDashboardImages(),
            _repo.getParentDashboard(),
          ]);

          final imagesRes = results[0] as ListResult<List<ImagesGallery>>?;
          final parentRes = results[1] as ListResult<ParentDashboardModel>?;

          if (imagesRes == null || parentRes == null) {
            throw Exception("Failed to load dashboard data");
          }

          final data = HomeDashboardData(
            images: imagesRes.data ?? [],
            parentData: parentRes.data,
          );
          _dashboardDataSubject.add(data);
        } else if (user.userType == 'Employee') {
          // Parallel execution of gallery and employee dashboard
          final results = await Future.wait([
            _repo.getDashboardImages(),
            _repo.getEmployeeDashboard(),
          ]);

          final imagesRes = results[0] as ListResult<List<ImagesGallery>>?;
          final employeeRes = results[1] as ListResult<EmployeeDashboardModel>?;

          if (imagesRes == null || employeeRes == null) {
            throw Exception("Failed to load dashboard data");
          }

          final data = HomeDashboardData(
            images: imagesRes.data ?? [],
            employeeData: employeeRes.data,
          );
          _dashboardDataSubject.add(data);
        } else {
          // Fallback if role is unknown but logged in
          final imagesRes = await _repo.getDashboardImages();
          final data = HomeDashboardData(
            images: imagesRes?.data ?? [],
          );
          _dashboardDataSubject.add(data);
        }
      } else {
        // Guest user - only load gallery images
        final imagesRes = await _repo.getDashboardImages();
        final data = HomeDashboardData(
          images: imagesRes?.data ?? [],
        );
        _dashboardDataSubject.add(data);
      }

      inState.add(ManagerState.success);
    } catch (e) {
      errorDescription = e.toString();
      _dashboardDataSubject.addError(e);
      inState.add(ManagerState.error);
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
