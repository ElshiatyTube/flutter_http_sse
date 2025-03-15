import 'package:fluttersse/model/sse_response.dart';

import '../model/sse_request.dart';

abstract class ISSEClient<T>{
  /// Establishes a connection with the server.
  Stream<SSEResponse<T>> connect(String connectionId,SSERequest request, {Function(dynamic)? fromJson});
  /// Closes the SSE connection.
  void close({String? connectionId});
}