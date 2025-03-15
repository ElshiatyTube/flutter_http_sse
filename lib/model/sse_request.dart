import '../enum/request_method_type_enum.dart';
import 'base_request.dart';

class SSERequest extends BaseRequest {
  final dynamic _body;
  final RequestMethodType _requestType;
  final bool _retry;
  final int _retryInterval;

  final Function(String) _onData;
  final Function(String)? _onError;
  final Function? _onDone;

  SSERequest(
      {required super.url,
      required super.contentType,
       super.headers,
      required dynamic body,
      required RequestMethodType requestType,
      bool retry = true,
      int retryInterval = 1000,
      required Function(String) onData,
       Function(String)? onError,
       Function? onDone})
      : _body = body,
        _requestType = requestType,
        _retry = retry,
        _retryInterval = retryInterval,
        _onData = onData,
        _onError = onError,
        _onDone = onDone;

  RequestMethodType get requestType => _requestType;

  Function(String) get onData => _onData;

  Function(String)? get onError => _onError;

  Function? get onDone => _onDone;

  dynamic get body => _body;

  bool get retry => _retry;

  int get retryInterval => _retryInterval;
}
