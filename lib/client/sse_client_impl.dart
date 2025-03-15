import 'dart:async';
import 'dart:convert';

import 'package:fluttersse/client/i_sse_client.dart';
import 'package:fluttersse/model/sse_response.dart';
import 'package:http/http.dart' as http;

import '../model/sse_request.dart';

class SSEClientImpl<T> extends ISSEClient {
  final Map<String, _SSEConnection<T>> _connections = {};

  @override
  void close({String? connectionId}) {
    if (connectionId != null) {
      _connections[connectionId]?.close();
      _connections.remove(connectionId);
    } else {
      for (var connection in _connections.values) {
        connection.close();
      }
      _connections.clear();
    }
  }

  @override
  Stream<SSEResponse<T>> connect(String connectionId,SSERequest request, {Function(dynamic)? fromJson}) {
    return subscribeToSSE(connectionId, request, fromJson: fromJson);
  }

  Stream<SSEResponse<T>> subscribeToSSE(String connectionId, SSERequest request, {Function(dynamic)? fromJson}) {
    if (_connections.containsKey(connectionId)) {
      return _connections[connectionId]!.stream;
    }

    final connection = _SSEConnection<T>(request, fromJson);
    _connections[connectionId] = connection;
    return connection.stream;
  }
}

class _SSEConnection<T> {
  final SSERequest request;
  final Function(dynamic p1)? fromJson;
  final StreamController<SSEResponse<T>> _controller = StreamController.broadcast();
  http.Client? _client;

  _SSEConnection(this.request, this.fromJson) {
    _client = http.Client();
    var httpRequest = http.Request(request.requestType.value, request.getRequestUri);
    if(request.headers != null){
      httpRequest.headers.addAll(request.headers!);
    }
    if(request.body != null){
      httpRequest.body = json.encode(request.body);
    }
    _client!.send(httpRequest).then((response) {
      if (response.statusCode >= 400) {
        _controller.addError("Failed to connect to server. Status code: ${response.statusCode}");
        close();
        return;
      }
      response.stream.transform(utf8.decoder).transform(const LineSplitter()).listen(
            (String line) {
          if (_controller.isClosed) return;
          if (line.isEmpty) {
            _controller.add(SSEResponse<T>.empty());
          } else {
            final data = json.decode(line);
            _controller.add(SSEResponse<T>.parse(data, fromJson: fromJson));
          }
          request.onData(line);
        },
        onDone: close,
        onError: (error) {
          _controller.addError(error);
          close();
        },
        cancelOnError: true,
      );
    });
  }

  Stream<SSEResponse<T>> get stream => _controller.stream;

  void close() {
    if (_controller.isClosed) return;
    _controller.close();
    _client?.close();
  }
}
