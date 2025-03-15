import 'dart:convert';

class SSEResponse<T> {
  final String id;
  final String event;
  final String comment;
  final dynamic data;
  final String rawResponse;

  const SSEResponse(this.id, this.event, this.comment, this.data, this.rawResponse);

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

    T? parsedData;
    final jsonData = dataBuffer.toString();
    if (jsonData.isNotEmpty) {
      try {
        parsedData = json.decode(jsonData) as T;
      } catch (e) {
        return SSEResponse.raw(rawResponse);
      }
    }

    return SSEResponse(id ?? '', event ?? '', comment ?? '', parsedData, rawResponse);
  }

  factory SSEResponse.empty() {
    return SSEResponse('', '', '', null, '');
  }

  factory SSEResponse.raw(String rawResponse) {
    return SSEResponse('', '', '', rawResponse as T, rawResponse);
  }

  @override
  String toString() {
    return 'SSEResponse{id: $id, event: $event, comment: $comment, data: $data, rawResponse: $rawResponse}';
  }
}