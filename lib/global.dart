import 'package:camera/camera.dart';

late List<CameraDescription> cameras;

void logError(String code, String? message) {
  // ignore: avoid_print
  print('Error: $code${message == null ? '' : '\nError Message: $message'}');
}
