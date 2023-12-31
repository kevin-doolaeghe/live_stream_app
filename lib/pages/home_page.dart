import 'package:flutter/material.dart';
import 'package:live_stream_app/pages/settings_page.dart';
import 'package:live_stream_app/pages/setup_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _openSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsPage()),
    );
  }

  void _startStream() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SetupPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: FloatingActionButton(
              onPressed: _openSettings,
              child: const Icon(Icons.settings),
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 24, 0, 24),
            child: Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.fitHeight,
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
                child: const Icon(Icons.add),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
