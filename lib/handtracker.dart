import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HandTrackingPage extends StatefulWidget {
  @override
  _HandTrackingPageState createState() => _HandTrackingPageState();
}

class _HandTrackingPageState extends State<HandTrackingPage> {
  CameraController? _controller;
  late Future<void> _initializeControllerFuture;
  static const platform = MethodChannel('com.example.hand_tracking/channel');

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();
    // Select the first camera (usually the back camera).
    final firstCamera = cameras.first;

    // Create a CameraController.
    _controller = CameraController(
      firstCamera,
      ResolutionPreset.high,
    );

    // Initialize the controller.
    _initializeControllerFuture = _controller!.initialize();

    // Start the camera stream.
    _controller!.startImageStream((CameraImage image) {
      // Convert CameraImage to Uint8List
      Uint8List bytes = image.planes[0].bytes;

      // Call the method channel to detect hand landmarks
      _detectHandLandmarks(bytes);
    });
  }

  Future<void> _detectHandLandmarks(Uint8List imageBytes) async {
    try {
      final result = await platform.invokeMethod('detectHandLandmarks', {
        'frameData': imageBytes,
      });
      print("Hand landmarks: $result");
    } on PlatformException catch (e) {
      print("Failed to detect hand: ${e.message}");
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hand Tracking'),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the controller is done initializing, display the preview.
            return CameraPreview(_controller!);
          } else {
            // Otherwise, show a loading indicator.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
