import 'dart:convert';

class SseEvent {
  final String? event;
  final String? id;
  final String? retry;
  final String data;
  final List<String> rawLines;
  final DateTime receivedAt;

  const SseEvent({
    this.event,
    this.id,
    this.retry,
    required this.data,
    required this.rawLines,
    required this.receivedAt,
  });

  Map<String, dynamic>? tryParseJson() {
    if (data.isEmpty) return null;
    try {
      return jsonDecode(data) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  bool get isDone => data.trim() == '[DONE]';
}

class SseFrameAssembler {
  final List<int> _buffer = [];
  String _pendingText = '';
  final List<SseEvent> _events = [];
  final List<String> _currentEventLines = [];
  String? _currentEventField;
  String? _currentIdField;
  String? _currentRetryField;
  final StringBuffer _currentDataBuffer = StringBuffer();

  void addBytes(List<int> bytes) {
    _buffer.addAll(bytes);

    String? text;
    try {
      text = utf8.decode(_buffer, allowMalformed: true);
    } catch (e) {
      text = String.fromCharCodes(_buffer);
    }

    final fullText = _pendingText + text;
    _buffer.clear();

    final lines = fullText.split('\n');
    _pendingText = lines.removeLast();

    for (final line in lines) {
      _processLine(line);
    }
  }

  void _processLine(String line) {
    if (line.isEmpty) {
      if (_currentDataBuffer.isNotEmpty || _currentEventLines.isNotEmpty) {
        _emitEvent();
      }
      return;
    }

    if (line.startsWith(':')) {
      return;
    }

    final colonIndex = line.indexOf(':');
    String field;
    String value;

    if (colonIndex == -1) {
      field = line;
      value = '';
    } else {
      field = line.substring(0, colonIndex);
      value = line.substring(colonIndex + 1);
      if (value.startsWith(' ')) {
        value = value.substring(1);
      }
    }

    switch (field) {
      case 'event':
        _currentEventField = value;
        break;
      case 'id':
        _currentIdField = value;
        break;
      case 'retry':
        _currentRetryField = value;
        break;
      case 'data':
        if (_currentDataBuffer.isNotEmpty) {
          _currentDataBuffer.write('\n');
        }
        _currentDataBuffer.write(value);
        break;
      default:
        break;
    }

    _currentEventLines.add(line);
  }

  void _emitEvent() {
    final data = _currentDataBuffer.toString();
    _events.add(
      SseEvent(
        event: _currentEventField,
        id: _currentIdField,
        retry: _currentRetryField,
        data: data,
        rawLines: List.from(_currentEventLines),
        receivedAt: DateTime.now(),
      ),
    );

    _currentEventField = null;
    _currentIdField = null;
    _currentRetryField = null;
    _currentDataBuffer.clear();
    _currentEventLines.clear();
  }

  List<SseEvent> drainEvents() {
    final result = List<SseEvent>.from(_events);
    _events.clear();
    return result;
  }

  void reset() {
    _buffer.clear();
    _pendingText = '';
    _events.clear();
    _currentEventLines.clear();
    _currentEventField = null;
    _currentIdField = null;
    _currentRetryField = null;
    _currentDataBuffer.clear();
  }
}
