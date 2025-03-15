import '../model/sse_request.dart';
import '../model/sse_response.dart';

/// An abstract class representing an SSE (Server-Sent Events) client.
abstract class ISSEClient {
  /// Establishes a connection with the server.
  ///
  /// [connectionId] is the unique identifier for the connection.
  /// [request] is the SSE request containing the connection details.
  /// [fromJson] is an optional function to parse the JSON data.
  ///
  /// Returns a [Stream] of [SSEResponse] objects.
  Stream<SSEResponse> connect(String connectionId, SSERequest request,
      {Function(dynamic)? fromJson});

  /// Closes the SSE connection.
  ///
  /// [connectionId] is an optional unique identifier for the connection to close.
  void close({String? connectionId});
}