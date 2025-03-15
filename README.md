# SSE Client for Flutter

A simple and efficient **Server-Sent Events (SSE) Client** for Flutter applications using `http` package.

## Features
- Establish and manage SSE connections.
- Automatic reconnection with exponential backoff.
- Parses SSE events into structured responses.
- Supports multiple connections.
- Customizable request headers and body.

## Installation
Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_http_sse:
    path: your_local_package_path # Update with actual path or publish it to pub.dev
```

## Usage
### Create an SSE Connection
```dart
final sseClient = SSEClient<YourDataModel>();

final request = SSERequest(
  url: 'https://your-sse-endpoint.com/stream',
  requestType: RequestMethodType.get,
  retry: true,
  onData: (SSEResponse response) {
    print('New Event: ${response.data}');
  },
  onError: (error) {
    print('Error: $error');
  },
  onDone: () {
    print('SSE Connection Closed');
  },
);

sseClient.connect('my_connection', request);
```

### Close a Connection
```dart
sseClient.close(connectionId: 'my_connection');
```

### Close All Connections
```dart
sseClient.close();
```

## Models
### `SSEResponse<T>`
Represents a structured SSE response.
```dart
class SSEResponse<T> {
  final String id;
  final String event;
  final String comment;
  final T data;
  final String rawResponse;
}
```

## License
This project is licensed under the MIT License.

