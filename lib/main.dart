import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:live_stream_app/app.dart';
import 'package:live_stream_app/global.dart';

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException catch (e) {
    logError(e.code, e.description);
  }

  runApp(const LiveStreamApp());
}
