import 'package:fluttersse/enum/request_content_type_enum.dart';

abstract class BaseRequest {
  final String _url;
  final RequestContentType _sseMediaType;
  final Map<String, String>? _header;

  BaseRequest({
    required String url,
    required RequestContentType sseMediaType,
    required Map<String, String>? headers,
    required Function(String) onMessage,
    Function(String)? onError,
    Function? onDone,
  })  : _url = url,
        _sseMediaType = sseMediaType,
        _header = headers;

  Uri get getRequestUri => Uri.parse(_url);

  RequestContentType get sseMediaType => _sseMediaType;

  Map<String, String>? get headers => {
        'Content-Type': sseMediaType.value,
        if (_header != null) ..._header!,
      };
}
