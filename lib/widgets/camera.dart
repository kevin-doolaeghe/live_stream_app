import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
// import 'package:live_stream_app/global.dart';
import 'package:tflite/tflite.dart';

class CameraWidget extends StatefulWidget {
  const CameraWidget({super.key});

  @override
  State<StatefulWidget> createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<StatefulWidget> {
  late CameraController _controller;
  late List<CameraDescription> _cameras;
  late bool _isDetecting;

  Widget? _overlay;

  /*
  void _startLiveStream({required CameraController camera}) {
    camera.startImageStream((image) {
      // send live stream to Facebook
    });
  }

  void _stopLiveStream({required CameraController camera}) {
    camera.stopImageStream();
  }
  */

  @override
  void initState() {
    super.initState();

    _isDetecting = false;
    _initializeCamera();
    _loadModel();

    /*
    _controller = CameraController(cameras[0], ResolutionPreset.max);
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
    */
  }

  @override
  void dispose() {
    _controller.dispose();
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) return Container();
    return Stack(
      children: [
        CameraPreview(_controller),
        _overlay ?? Container(),
      ],
    );
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    _controller = CameraController(_cameras[0], ResolutionPreset.medium);
    await _controller.initialize();
    if (!mounted) {
      return;
    }
    setState(() {});
    _controller.startImageStream(_processCameraImage);
  }

  Future<void> _loadModel() async {
    await Tflite.loadModel(
      model: 'assets/models/model.tflite',
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
        // Convertir la taille de l'image de la caméra à la taille de l'écran
        var screen = MediaQuery.of(context).size;
        var scale = screen.aspectRatio * cameraImage.height / screen.width;

        // Dessiner les rectangles autour des objets détectés
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
