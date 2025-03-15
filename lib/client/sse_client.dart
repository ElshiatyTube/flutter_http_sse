import 'dart:convert';

class SSEResponse<T> {
  final String id;
  final String event;
  final String comment;
  final T? data;
  final String rawResponse;

  const SSEResponse(
      this.id, this.event, this.comment, this.data, this.rawResponse);

  /// Parses an SSE event string into an SSEResponse object
  factory SSEResponse.parse(String rawResponse, {Function(dynamic)? fromJson}) {
    String? id;
    String? event;
    String? comment;
    StringBuffer jsonDataBuffer = StringBuffer();

    // Splitting the SSE response into lines
    for (final line in rawResponse.split('\n')) {
      if (line.startsWith('id: ')) {
        id = line.substring(4).trim();
      } else if (line.startsWith('event: ')) {
        event = line.substring(7).trim();
      } else if (line.startsWith('data: ')) {
        if (jsonDataBuffer.isNotEmpty) jsonDataBuffer.write('\n');
        jsonDataBuffer.write(line.substring(6).trim());
      } else if (line.startsWith(':')) {
        comment = line.substring(1).trim();
      }
    }

    // Ensure non-nullable fields have default values
    id ??= '';
    event ??= '';
    comment ??= '';

    // Convert buffered data into JSON object if available
    T? parsedData;
    final jsonData = jsonDataBuffer.toString();
    if (jsonData.isNotEmpty) {
      try {
        final decodedData = json.decode(jsonData);
        parsedData = fromJson != null ? fromJson(decodedData) : decodedData as T;
      } catch (e) {
        return SSEResponse.raw(rawResponse);
      }
    }

    return SSEResponse(id, event, comment, parsedData, rawResponse);
  }

  factory SSEResponse.empty() {
    return SSEResponse('', '', '', null, '');
  }

  factory SSEResponse.raw(String rawResponse) {
    return SSEResponse('', '', '', rawResponse as T, rawResponse);
  }

  @override
  String toString() {
    return 'SSEResponse{id: $id, event: $event, comment: $comment, data: ${data.toString()}, rawResponse: $rawResponse}';
  }
}
