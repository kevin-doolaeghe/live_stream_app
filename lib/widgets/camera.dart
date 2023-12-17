import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:live_stream_app/global.dart';

class CameraWidget extends StatefulWidget {
  const CameraWidget({super.key});

  @override
  State<StatefulWidget> createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<StatefulWidget> {
  late CameraController controller;

  void _startLiveStream({required CameraController camera}) {
    camera.startImageStream((image) {
      // send live stream to Facebook
    });
  }

  void _stopLiveStream({required CameraController camera}) {
    camera.stopImageStream();
  }

  @override
  void initState() {
    super.initState();

    controller = CameraController(cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
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
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) return Container();
    return CameraPreview(controller);
  }
}
