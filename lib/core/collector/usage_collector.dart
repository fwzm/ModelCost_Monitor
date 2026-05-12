import 'dart:async';
import 'dart:collection';

import 'package:drift/drift.dart' show Value;

import '../../data/database/database.dart';

class PendingUsageLog {
  final UsageLogsCompanion companion;
  int retryCount;
  DateTime nextRetryAt;
  final DateTime createdAt;

  PendingUsageLog(this.companion)
      : retryCount = 0,
        nextRetryAt = DateTime.now(),
        createdAt = DateTime.now();

  bool get canRetry => retryCount < 5;

  Duration get retryDelay => Duration(milliseconds: 100 * (1 << retryCount));
}

class UsageCollector {
  final AppDatabase _db;
  final Queue<PendingUsageLog> _pendingQueue = Queue<PendingUsageLog>();
  Timer? _flushTimer;
  bool _isFlushing = false;
  final int _flushIntervalMs;
  final int _maxRetries;
  final int _retryBaseIntervalMs;
  int _totalWrites = 0;
  int _failedWrites = 0;

  UsageCollector({
    required AppDatabase db,
    int flushIntervalMs = 500,
    int maxRetries = 5,
    int retryBaseIntervalMs = 100,
  })  : _db = db,
        _flushIntervalMs = flushIntervalMs,
        _maxRetries = maxRetries,
        _retryBaseIntervalMs = retryBaseIntervalMs;

  void start() {
    _flushTimer = Timer.periodic(
      Duration(milliseconds: _flushIntervalMs),
      (_) => _flushPendingLogs(),
    );
  }

  void stop() {
    _flushTimer?.cancel();
    _flushTimer = null;
  }

  Future<void> flush() async {
    await _flushPendingLogs();
  }

  Future<void> submitUsageLog(UsageLogsCompanion companion) async {
    try {
      await _db.insertUsageLog(companion);
      _totalWrites++;
    } catch (e) {
      if (_isDatabaseLockedError(e)) {
        final pending = PendingUsageLog(companion);
        pending.retryCount = 0;
        _pendingQueue.add(pending);
      } else {
        final pending = PendingUsageLog(companion);
        _pendingQueue.add(pending);
        _failedWrites++;
      }
    }
  }

  Future<void> _flushPendingLogs() async {
    if (_isFlushing || _pendingQueue.isEmpty) return;

    _isFlushing = true;
    try {
      final batch = <PendingUsageLog>[];
      final iterator = _pendingQueue.iterator;
      while (iterator.moveNext() && batch.length < 20) {
        final item = iterator.current;
        if (item.canRetry && DateTime.now().isAfter(item.nextRetryAt)) {
          batch.add(item);
        }
      }

      for (final item in batch) {
        try {
          await _db.insertUsageLog(item.companion);
          _pendingQueue.remove(item);
          _totalWrites++;
        } catch (e) {
          item.retryCount++;
          if (item.canRetry) {
            item.nextRetryAt = DateTime.now().add(item.retryDelay);
          } else {
            _pendingQueue.remove(item);
            _failedWrites++;
          }
        }
      }
    } finally {
      _isFlushing = false;
    }
  }

  bool _isDatabaseLockedError(dynamic error) {
    final errorString = error.toString().toLowerCase();
    return errorString.contains('database is locked') ||
        errorString.contains('busy') ||
        errorString.contains('sqlite_error_busy');
  }

  int get pendingQueueLength => _pendingQueue.length;
  int get totalWrites => _totalWrites;
  int get failedWrites => _failedWrites;

  Future<Map<String, dynamic>> getStats() async {
    return {
      'pending_queue': _pendingQueue.length,
      'total_writes': _totalWrites,
      'failed_writes': _failedWrites,
    };
  }
}
