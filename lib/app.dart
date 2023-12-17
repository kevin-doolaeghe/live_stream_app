import 'package:flutter/material.dart';
import 'package:live_stream_app/pages/home.dart';

class LiveStreamApp extends StatelessWidget {
  const LiveStreamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomePage(),
      theme: ThemeData(colorSchemeSeed: Theme.of(context).primaryColor),
      debugShowCheckedModeBanner: false,
    );
  }
}
