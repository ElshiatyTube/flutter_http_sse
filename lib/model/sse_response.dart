import 'dart:convert';

class SSEResponse<T> {
  final String _id, _event, _comment;
  final T? _data;

  const SSEResponse(this._id, this._event, this._comment, this._data);

  String get id => _id;
  String get event => _event;
  String get comment => _comment;
  T? get data => _data;

  factory SSEResponse.parse(String rawEvent, {Function(dynamic)? fromJson}) {
    String? id;
    String? event;
    StringBuffer jsonDataBuffer = StringBuffer();

    // Splitting the SSE response into lines
    for (final line in rawEvent.split('\n')) {
      if (line.startsWith('id: ')) {
        id = line.substring(4).trim();
      } else if (line.startsWith('event: ')) {
        event = line.substring(7).trim();
      } else if (line.startsWith('data: ')) {
        if (jsonDataBuffer.isNotEmpty) jsonDataBuffer.write('\n');
        jsonDataBuffer.write(line.substring(6).trim());
      }
    }

    // Convert buffered data into JSON object
    final jsonData = jsonDataBuffer.toString();
    T parsedData;
    if (jsonData.isNotEmpty) {
      if (fromJson != null) {
        parsedData = fromJson(json.decode(jsonData));
      } else {
        parsedData = json.decode(jsonData);
      }
    } else {
      throw Exception("No data found");
    }
    return SSEResponse(id ?? '', event ?? '', '', parsedData);
  }

  factory SSEResponse.empty() {
    return SSEResponse('', '', '', null);
  }
}