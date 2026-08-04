import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/foundation.dart';
import 'package:ghars_school/app_core/app_core.dart';
import 'package:ghars_school/features/landing_tabs/pages/services/models/inv_group_stage_model.dart';
import 'package:ghars_school/features/landing_tabs/pages/services/services_repo.dart';
import 'package:rxdart/rxdart.dart';

class ServicesManager extends Manager {
  final ServicesRepo _repo = ServicesRepo();
  final PrefsService _prefs = locator<PrefsService>();

  final BehaviorSubject<ManagerState> _stateSubject =
      BehaviorSubject<ManagerState>.seeded(ManagerState.idle);

  final BehaviorSubject<List<INVGroupStageModel>> _stagesSubject =
      BehaviorSubject<List<INVGroupStageModel>>.seeded([]);

  Stream<ManagerState> get state$ => _stateSubject.stream;
  Sink<ManagerState> get inState => _stateSubject.sink;

  Stream<List<INVGroupStageModel>> get stages$ => _stagesSubject.stream;

  String? errorDescription;

  Future<void> initServices() async {
    if (_stateSubject.value == ManagerState.loading) return;

    final user = _prefs.userObj;
    final isLoggedIn = user != null && user.token != null;
    final isParent = isLoggedIn && user.userType == 'Parent';

    if (!isParent) {
      _stagesSubject.add([]);
      inState.add(ManagerState.success);
      return;
    }

    bool hasCache = false;
    errorDescription = null;
    
    // 1. Instant Cache Fetch
    try {
      final cacheData = await _repo.getInvGroupStages(cachePolicy: CachePolicy.forceCache);
      if (cacheData != null && cacheData.data != null) {
        _stagesSubject.add(cacheData.data!);
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
      final netData = await _repo.getInvGroupStages(cachePolicy: CachePolicy.refreshForceCache);
      if (netData != null && netData.data != null) {
        _stagesSubject.add(netData.data!);
        if (!hasCache || _stateSubject.value != ManagerState.success) {
          inState.add(ManagerState.success);
        }
      } else if (!hasCache) {
        _stagesSubject.add([]);
        inState.add(ManagerState.success);
      }
    } catch (e) {
      if (!hasCache) {
        errorDescription = e.toString();
        _stagesSubject.addError(e);
        inState.add(ManagerState.error);
      } else {
        debugPrint("Background sync failed for services: $e");
      }
    }
  }

  @override
  void dispose() {
    _stateSubject.close();
    _stagesSubject.close();
  }
}
