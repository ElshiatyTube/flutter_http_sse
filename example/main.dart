import 'package:flutter/material.dart';
import 'package:flutter_http_sse/client/sse_client.dart';
import 'package:flutter_http_sse/model/sse_request.dart';
import 'package:flutter_http_sse/model/sse_response.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SSE Client Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SSEPage(),
    );
  }
}

class SSEPage extends StatefulWidget {
  @override
  _SSEPageState createState() => _SSEPageState();
}

class _SSEPageState extends State<SSEPage> {
  late SSEClient _sseClient;
  late Stream<SSEResponse> _stream;
  final List<String> _messages = [];

  @override
  void initState() {
    super.initState();
    _sseClient = SSEClient();
    _connectToSSE();
  }

  void _connectToSSE() {
    final request = SSERequest(
      url: 'https://your-sse-server.com/events',
      onData: (response) {
        print("New SSE Event: ${response.data}");
      },
      onError: (error) {
        print("SSE Error: $error");
      },
      onDone: () {
        print("SSE Connection Closed");
      },
      retry: true,
    );

    _stream = _sseClient.connect('sse_connection', request);

    _stream.listen(
      (event) {
        setState(() {
          _messages.add(event.data.toString());
        });
      },
      onError: (error) {
        print("Stream Error: $error");
      },
      onDone: () {
        print("Stream Closed");
      },
    );
  }

  @override
  void dispose() {
    _sseClient.close(connectionId: 'sse_connection');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SSE Client Example')),
      body: ListView.builder(
        itemCount: _messages.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_messages[index]),
          );
        },
      ),
    );
  }
}
