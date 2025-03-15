import '../enum/request_content_type_enum.dart';

abstract class BaseRequest {
  final String _url;
  final RequestContentType _sseMediaType;
  final Map<String, String>? _header;

  BaseRequest({
    required String url,
    required RequestContentType contentType,
    Map<String, String>? headers,
  })  : _url = url,
        _sseMediaType = contentType,
        _header = headers;

  Uri get getRequestUri => Uri.parse(_url);

  RequestContentType get contentType => _sseMediaType;

  Map<String, String>? get headers => {
        'Content-Type': contentType.value,
        if (_header != null) ..._header!,
      };
}
