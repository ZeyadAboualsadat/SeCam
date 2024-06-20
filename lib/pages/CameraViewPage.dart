
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
      routes: {
        '/camera_view': (context) => CameraViewPage(),
        '/stream_view': (context) => StreamViewer(),
        '/notifications': (context) => NotificationsPage(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: Center(child: Text("Welcome to the Home Screen")),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Cameras',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.popUntil(context, ModalRoute.withName('/'));
              break;
            case 1:
              Navigator.pushNamed(context, '/camera_view');
              break;
            case 2:
              Navigator.pushNamed(context, '/notifications');
              break;
          }
        },
      ),
    );
  }
}

class CameraViewPage extends StatefulWidget {
  @override
  _CameraViewPageState createState() => _CameraViewPageState();
}

class _CameraViewPageState extends State<CameraViewPage> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;

  int helmetCount = 0;
  int gloveCount = 0;
  int peopleCount = 0;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    _controller = CameraController(
      firstCamera,
      ResolutionPreset.low,
      imageFormatGroup: ImageFormatGroup.yuv420, // Set to a supported format
    );
    _initializeControllerFuture = _controller!.initialize();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Real-Time Camera View'),
        backgroundColor: Colors.yellow[800],
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey[400],
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 3,
                    child: AspectRatio(
                      aspectRatio: _controller!.value.aspectRatio,
                      child: CameraPreview(_controller!),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCountBox('Helmets', helmetCount),
                _buildCountBox('Gloves', gloveCount),
              ],
            ),
            SizedBox(height: 20),
            _buildCountBox('People', peopleCount),
          ],
        ),
      ),
    );
  }

  Widget _buildCountBox(String label, int count) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.orangeAccent[400],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text('$count', style: TextStyle(fontSize: 20)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}

class StreamViewer extends StatefulWidget {
  @override
  _StreamViewerState createState() => _StreamViewerState();
}

class _StreamViewerState extends State<StreamViewer> {
  Stream<Uint8List>? _stream;

  @override
  void initState() {
    super.initState();
    _stream = fetchMjpegStream("http://192.168.1.3:8080/onvif/device_service"); // Update this URL to your camera's IP address and port
  }

  Stream<Uint8List> fetchMjpegStream(String url) async* {
    var client = http.Client();
    var request = http.Request('GET', Uri.parse(url))
      ..headers['accept'] = 'multipart/x-mixed-replace';

    var response = await client.send(request);

    if (response.statusCode != 200) {
      throw Exception('Failed to load stream');
    }

    List<int> buffer = [];
    var boundary = utf8.encode('\r\n\r\n');

    await for (var chunk in response.stream) {
      buffer.addAll(chunk);
      int boundaryIndex = _findBoundaryIndex(buffer, boundary);
      while (boundaryIndex != -1) {
        var imageBytes = buffer.sublist(0, boundaryIndex);
        buffer = buffer.sublist(boundaryIndex + boundary.length);
        yield Uint8List.fromList(imageBytes);
        boundaryIndex = _findBoundaryIndex(buffer, boundary);
      }
    }
  }

  int _findBoundaryIndex(List<int> buffer, List<int> boundary) {
    for (int i = 0; i <= buffer.length - boundary.length; i++) {
      bool found = true;
      for (int j = 0; j < boundary.length; j++) {
        if (buffer[i + j] != boundary[j]) {
          found = false;
          break;
        }
      }
      if (found) return i;
    }
    return -1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MJPEG Stream Viewer"),
      ),
      body: Center(
        child: StreamBuilder<Uint8List>(
          stream: _stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else if (!snapshot.hasData) {
              return Text("No data");
            }

            var image = img.decodeImage(snapshot.data!);
            return image == null
                ? Text("Failed to decode image")
                : Image.memory(Uint8List.fromList(img.encodeJpg(image!)));
          },
        ),
      ),
    );
  }
}

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notifications")),
      body: Center(child: Text("This is the Notifications Page")),
    );
  }
}

void main() {
  runApp(MyApp());
}
