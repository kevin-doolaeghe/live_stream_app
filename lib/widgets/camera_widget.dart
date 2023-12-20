import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';

class CameraWidget extends StatefulWidget {
  final List<CameraDescription>? cameras;
  const CameraWidget({super.key, required this.cameras});

  @override
  State<CameraWidget> createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  late CameraController _cameraController;
  bool _isRearCameraSelected = true;

  bool _isDetecting = false;
  Widget? _overlay;

  @override
  void initState() {
    super.initState();
    _initCamera(widget.cameras![0]);
    _initModel();
  }

  Future<void> _initCamera(CameraDescription cameraDescription) async {
    _cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.high,
    );
    try {
      await _cameraController.initialize().then((_) {
        if (!mounted) return;
        setState(() {
          // _cameraController.startImageStream(_processCameraImage);
        });
      });
    } on CameraException catch (e) {
      debugPrint("Camera error: $e");
    }
  }

  Future<void> _initModel() async {
    await Tflite.loadModel(
      model: 'assets/models/model.tflite',
    );
  }

  @override
  void dispose() {
    // _cameraController.stopImageStream();
    _cameraController.dispose();
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          (_cameraController.value.isInitialized)
              ? Stack(
                  children: [
                    CameraPreview(_cameraController),
                    _overlay ?? Container(),
                  ],
                )
              : Container(
                  color: Colors.black,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.20,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                color: Colors.black,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      iconSize: 30,
                      icon: Icon(
                        _isRearCameraSelected
                            ? CupertinoIcons.switch_camera
                            : CupertinoIcons.switch_camera_solid,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() =>
                            _isRearCameraSelected = !_isRearCameraSelected);
                        _initCamera(
                          widget.cameras![_isRearCameraSelected ? 0 : 1],
                        );
                      },
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ]),
      ),
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
