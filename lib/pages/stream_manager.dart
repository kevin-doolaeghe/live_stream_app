import 'package:flutter/material.dart';
import 'package:live_stream_app/pages/home.dart';
import 'package:live_stream_app/widgets/camera.dart';

class StreamManagerPage extends StatefulWidget {
  const StreamManagerPage({super.key});

  @override
  State<StatefulWidget> createState() => _StreamManagerPageState();
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
        const Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 24, 0, 24),
            child: CameraWidget(),
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
