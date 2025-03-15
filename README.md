# Flutter HTTP SSE Client

A Flutter package for handling Server-Sent Events (SSE) connections over the `http` package. This package allows you to establish SSE connections, receive real-time updates from the server, and handle automatic reconnections.

## Features
- Establish SSE connections with custom request parameters.
- Automatically parses SSE responses.
- Supports retrying on connection failures.
- Handles stream disconnections gracefully.
- Allow multiple connections.
- Allows dynamic deserialization of received data.

## Installation

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_http_sse:
    path: https://github.com/ElshiatyTube/flutter_http_sse.git
```

## Usage

### 1. Create an SSE Request
```dart
import 'package:flutter_http_sse/model/sse_request.dart';

final request = SSERequest(
  requestType: SSERequestType.GET,
  url: Uri.parse("https://your-sse-endpoint.com/stream"),
  headers: {"Authorization": "Bearer YOUR_TOKEN"},
  onData: (data) => print("Received: $data"),
  onError: (error) => print("Error: $error"),
  onDone: () => print("Stream closed"),
  retry: true, // Enables automatic reconnection
);
```

### 2. Connect to SSE Server
```dart
import 'package:flutter_http_sse/service/sse_client.dart';

final sseClient = SSEClient();
final Stream<SSEResponse> stream = sseClient.connect("connectionId", request);

stream.listen(
  (SSEResponse response) {
    print("Received event: ${response.event}, data: ${response.data}");
  },
  onError: (error) => print("SSE Error: $error"),
  onDone: () => print("SSE Connection Closed"),
);
```

### 3. Close SSE Connection
```dart
sseClient.close(connectionId: "connectionId");
```

## SSEResponse Structure
```dart
class SSEResponse {
  final String id;
  final String event;
  final String comment;
  final dynamic data;
  final String rawResponse;
}
```

## Error Handling & Retries
- If the server responds with a `5xx` status code, the client will attempt to reconnect automatically.
- Retry attempts follow an exponential backoff strategy with a maximum of 5 retries.
- If retries are disabled, the connection will be closed on failure.

## Contributions
Contributions are welcome! Feel free to submit issues and pull requests.

## License
This project is licensed under the MIT License.
