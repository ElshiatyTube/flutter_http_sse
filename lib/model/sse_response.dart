import 'dart:convert';

/// A class representing a Server-Sent Events (SSE) response.
class SSEResponse {
  /// The ID of the SSE event.
  final String id;

  /// The type of the SSE event.
  final String event;

  /// The comment associated with the SSE event.
  final String comment;

  /// The data payload of the SSE event.
  final dynamic data;

  /// The raw response string of the SSE event.
  final String rawResponse;

  /// Constructs an [SSEResponse] instance.
  ///
  /// [id] is the ID of the SSE event.
  /// [event] is the type of the SSE event.
  /// [comment] is the comment associated with the SSE event.
  /// [data] is the data payload of the SSE event.
  /// [rawResponse] is the raw response string of the SSE event.
  const SSEResponse(
      this.id, this.event, this.comment, this.data, this.rawResponse);

  /// Parses a raw SSE response string and returns an [SSEResponse] instance.
  ///
  /// [rawResponse] is the raw response string to parse.
  /// Returns an [SSEResponse] instance with the parsed data.
  factory SSEResponse.parse(String rawResponse) {
    String? id;
    String? event;
    String? comment;
    StringBuffer dataBuffer = StringBuffer();

    final RegExp regex = RegExp(r'^(id|event|data|:|comment):\s*(.*)$');

    for (String line in rawResponse.split('\n')) {
      final match = regex.firstMatch(line);
      if (match != null) {
        final key = match.group(1);
        final value = match.group(2)?.trim() ?? '';

        switch (key) {
          case 'id':
            id = value;
            break;
          case 'event':
            event = value;
            break;
          case 'data':
            if (dataBuffer.isNotEmpty) dataBuffer.write('\n');
            dataBuffer.write(value);
            break;
          case ':':
            comment = value;
            break;
        }
      }
    }

    dynamic parsedData;
    final jsonData = dataBuffer.toString();
    if (jsonData.isNotEmpty) {
      try {
        parsedData = json.decode(jsonData);
      } catch (e) {
        return SSEResponse.raw(rawResponse);
      }
    }

    return SSEResponse(
        id ?? '', event ?? '', comment ?? '', parsedData, rawResponse);
  }

  /// Creates an empty [SSEResponse] instance.
  ///
  /// Returns an [SSEResponse] instance with empty fields.
  factory SSEResponse.empty() {
    return SSEResponse('', '', '', null, '');
  }

  /// Creates an [SSEResponse] instance with the raw response string.
  ///
  /// [rawResponse] is the raw response string.
  /// Returns an [SSEResponse] instance with the raw response string.
  factory SSEResponse.raw(String rawResponse) {
    return SSEResponse('', '', '', null, rawResponse);
  }

  @override
  String toString() {
    return 'SSEResponse{id: $id, event: $event, comment: $comment, data: $data, rawResponse: $rawResponse}';
  }
}
