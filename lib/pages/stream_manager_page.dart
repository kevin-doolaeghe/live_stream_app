import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:live_stream_app/pages/home_page.dart';
import 'package:live_stream_app/widgets/camera_widget.dart';

class StreamManagerPage extends StatefulWidget {
  const StreamManagerPage({super.key});

  @override
  State<StreamManagerPage> createState() => _StreamManagerPageState();
}

class _StreamManagerPageState extends State<StreamManagerPage> {
  void _stopStream() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 24, 0, 24),
            child: Center(
              child: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    await availableCameras().then(
                      (value) => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CameraWidget(cameras: value),
                        ),
                      ),
                    );
                  },
                  child: const Text("Start"),
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: FloatingActionButton(
              onPressed: _stopStream,
              child: const Icon(Icons.stop),
            ),
          ),
        ),
      ],
    );
  }
}
