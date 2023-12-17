import 'package:flutter/material.dart';
import 'package:live_stream_app/pages/home.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void _closeSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
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
              onPressed: _closeSettings,
              child: const Icon(Icons.arrow_back),
            ),
          ),
        ),
        const Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 24, 0, 24),
            child: Text("Settings"),
          ),
        ),
      ],
    );
  }
}
