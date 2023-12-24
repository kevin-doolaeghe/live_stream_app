import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:live_stream_app/pages/home_page.dart';
import 'package:tflite/tflite.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late List<CameraDescription> _cameras;
  late CameraController _controller;
  bool _isRearCameraSelected = true;
  bool _isReady = false;

  bool _isDetecting = false;
  Widget? _overlay;

  @override
  void initState() {
    super.initState();
    _initCameras();
    _initModel();
  }

  @override
  void dispose() {
    _controller.dispose();
    Tflite.close();
    super.dispose();
  }

  Future<void> _initCameras() async {
    _cameras = await availableCameras();
    await _setupCamera(_cameras[0]);
  }

  Future<void> _setupCamera(CameraDescription camera) async {
    try {
      _controller = CameraController(camera, ResolutionPreset.medium);
      await _controller.initialize().then((_) {
        if (!mounted) return;
        setState(() {
          _isReady = true;
        });
      });
    } on CameraException catch (e) {
      debugPrint('Camera error: $e');
    }
  }

  Future<void> _initModel() async {
    await Tflite.loadModel(
      model: 'assets/models/model.tflite',
      labels: 'assets/models/labels.txt',
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isReady || !_controller.value.isInitialized) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Stack(children: [
      Positioned.fill(
        child: CameraPreview(_controller),
      ),
      Positioned.fill(
        child: _overlay ?? Container(),
      ),
      Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.18,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(24),
            ),
            color: Colors.black.withOpacity(0.5),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: IconButton(
                    iconSize: 30,
                    padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
                    icon: Icon(
                      _isRearCameraSelected
                          ? CupertinoIcons.switch_camera
                          : CupertinoIcons.switch_camera_solid,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _isRearCameraSelected = !_isRearCameraSelected;
                      });
                      _setupCamera(
                        _cameras[_isRearCameraSelected ? 0 : 1],
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: IconButton(
                    iconSize: 50,
                    padding: const EdgeInsets.all(12),
                    icon: const Icon(Icons.circle, color: Colors.white),
                    onPressed: _startStream,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: IconButton(
                    iconSize: 30,
                    padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
                    icon: const Icon(Icons.stop, color: Colors.white),
                    onPressed: _stopStream,
                  ),
                ),
              ),
              // const Spacer(),
            ],
          ),
        ),
      ),
    ]);
  }

  Future<void> _startStream() async {
    if (_controller.value.isInitialized) {
      _controller.startImageStream(_processCameraImage);
    }
  }

  Future<void> _stopStream() async {
    if (_controller.value.isStreamingImages) _controller.stopImageStream();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  void _processCameraImage(CameraImage cameraImage) async {
    if (!_isDetecting) {
      _isDetecting = true;

      try {
        var byteBuffer = cameraImage.planes[0].bytes;
        var imageBytes = Uint8List.fromList(byteBuffer);

        var recognitions = await Tflite.detectObjectOnBinary(
              binary: imageBytes,
            ) ??
            [];
        _updateUiWithRecognitions(recognitions, cameraImage);
      } finally {
        _isDetecting = false;
      }
    }
  }

  void _updateUiWithRecognitions(
    List<dynamic> recognitions,
    CameraImage cameraImage,
  ) {
    if (mounted) {
      setState(() {
        var screen = MediaQuery.of(context).size;
        var scale = screen.aspectRatio * cameraImage.height / screen.width;

        _overlay = CustomPaint(
          painter: ObjectDetectorPainter(recognitions, scale),
        );
      });
    }
  }
}

class ObjectDetectorPainter extends CustomPainter {
  final List<dynamic> recognitions;
  final double scale;

  ObjectDetectorPainter(this.recognitions, this.scale);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    for (var recognition in recognitions) {
      Rect rect = Rect.fromPoints(
        Offset(
            recognition['rect']['x'] * scale, recognition['rect']['y'] * scale),
        Offset((recognition['rect']['x'] + recognition['rect']['w']) * scale,
            (recognition['rect']['y'] + recognition['rect']['h']) * scale),
      );

      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
