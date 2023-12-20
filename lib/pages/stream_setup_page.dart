import 'package:flutter/material.dart';
import 'package:live_stream_app/pages/home_page.dart';
import 'package:live_stream_app/pages/stream_manager_page.dart';

class StreamSetupPage extends StatefulWidget {
  const StreamSetupPage({super.key});

  @override
  State<StreamSetupPage> createState() => _StreamSetupPageState();
}

class _StreamSetupPageState extends State<StreamSetupPage> {
  void _closeSetup() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  void _startStream() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const StreamManagerPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: FloatingActionButton(
              onPressed: _closeSetup,
              child: const Icon(Icons.arrow_back),
            ),
          ),
        ),
        Flexible(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                color: Theme.of(context).primaryColorLight,
              ),
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
              child: FloatingActionButton(
                onPressed: _startStream,
                child: const Icon(Icons.play_arrow),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
