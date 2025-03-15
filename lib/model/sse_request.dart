import 'package:flutter_http_sse/model/sse_response.dart';

import '../enum/request_content_type_enum.dart';
import '../enum/request_method_type_enum.dart';
import 'base_request.dart';

class SSERequest extends BaseRequest {
  final dynamic _body;
  final RequestMethodType _requestType;
  final bool _retry;

  final Function(SSEResponse) _onData;
  final Function(String)? _onError;
  final Function? _onDone;

  SSERequest(
      {required super.url,
      super.contentType = RequestContentType.textEventStreamValue,
      super.headers,
      dynamic body,
      RequestMethodType requestType = RequestMethodType.get,
      bool retry = false,
      required Function(SSEResponse) onData,
      Function(String)? onError,
      Function? onDone})
      : _body = body,
        _requestType = requestType,
        _retry = retry,
        _onData = onData,
        _onError = onError,
        _onDone = onDone;

  RequestMethodType get requestType => _requestType;

  Function(SSEResponse) get onData => _onData;

  Function(String)? get onError => _onError;

  Function? get onDone => _onDone;

  dynamic get body => _body;

  bool get retry => _retry;
}
