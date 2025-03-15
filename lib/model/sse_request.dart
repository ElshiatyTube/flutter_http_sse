import 'package:fluttersse/enum/request_content_type_enum.dart';
import 'package:fluttersse/enum/request_method_type_enum.dart';

import 'base_request.dart';


class SSERequest extends BaseRequest {
  final dynamic body;
  final RequestMethodType requestType;
  final bool retry;
  final int retryInterval;

  final Function(String) _onData;
  final Function(String)? _onError;
  final Function? _onDone;

  SSERequest(
      {this.body,
        this.retry = false,
        this.retryInterval = 1000,
        required this.requestType,
        required super.url,
        super.headers, super.sseMediaType = RequestContentType.textEventStreamValue,
        required super.onMessage,
        super.onDone,
        super.onError})
      : _onData = onMessage,
        _onError = onError,
        _onDone = onDone;

  RequestMethodType get requestMethodType => requestType;

  Function(String) get onData => _onData;

  Function(String)? get onError => _onError;

  Function? get onDone => _onDone;
}