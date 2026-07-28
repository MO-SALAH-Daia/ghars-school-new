import 'package:flutter/foundation.dart';
import 'package:ghars_school/app_core/app_core.dart';
import 'package:ghars_school/features/landing_tabs/pages/calendar/calendar_repo.dart';
import 'package:ghars_school/features/landing_tabs/pages/calendar/models/calendar_event_model.dart';
import 'package:rxdart/rxdart.dart';

class CalendarManager extends Manager {
  final CalendarRepo _repo = CalendarRepo();

  final BehaviorSubject<ManagerState> _stateSubject =
      BehaviorSubject<ManagerState>.seeded(ManagerState.idle);

  final BehaviorSubject<Map<DateTime, List<CalendarEventModel>>> _eventsSubject =
      BehaviorSubject<Map<DateTime, List<CalendarEventModel>>>.seeded({});

  Stream<ManagerState> get state$ => _stateSubject.stream;
  Sink<ManagerState> get inState => _stateSubject.sink;

  Stream<Map<DateTime, List<CalendarEventModel>>> get events$ => _eventsSubject.stream;

  String? errorDescription;

  Future<void> initCalendar() async {
    if (_stateSubject.value == ManagerState.loading) return;

    inState.add(ManagerState.loading);
    errorDescription = null;

    try {
      final res = await _repo.getCalendarEvents();
      if (res != null && res.data != null) {
        _groupEvents(res.data!);
        inState.add(ManagerState.success);
      } else {
        throw Exception(res?.message ?? "Failed to load calendar events");
      }
    } catch (e) {
      errorDescription = e.toString();
      _eventsSubject.addError(e);
      inState.add(ManagerState.error);
    }
  }

  void _groupEvents(List<CalendarEventModel> eventsList) {
    Map<DateTime, List<CalendarEventModel>> eventsByDate = {};
    for (var event in eventsList) {
      if (event.fromDate != null) {
        try {
          final DateTime fromDate = DateTime.parse(event.fromDate!).toLocal();
          final DateTime toDate = event.toDate != null
              ? DateTime.parse(event.toDate!).toLocal()
              : fromDate;

          // Normalize both dates to midnight to iterate correctly
          DateTime current = DateTime(fromDate.year, fromDate.month, fromDate.day);
          DateTime end = DateTime(toDate.year, toDate.month, toDate.day);

          while (!current.isAfter(end)) {
            if (eventsByDate[current] == null) {
              eventsByDate[current] = [];
            }
            eventsByDate[current]!.add(event);
            // Move to next day
            current = current.add(const Duration(days: 1));
          }
        } catch (e) {
          debugPrint("Error parsing dates for event ${event.id}: $e");
        }
      }
    }
    _eventsSubject.add(eventsByDate);
  }

  List<CalendarEventModel> getEventsForDay(DateTime day) {
    DateTime normalizedDay = DateTime(day.year, day.month, day.day);
    return _eventsSubject.value[normalizedDay] ?? [];
  }

  Future<void> refreshCalendar() async {
    await initCalendar();
  }

  @override
  void dispose() {
    _stateSubject.close();
    _eventsSubject.close();
  }
}
