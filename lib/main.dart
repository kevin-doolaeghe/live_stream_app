import 'package:flutter/material.dart';
import 'package:live_stream_app/pages/home_page.dart';

Future<void> main() async {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(colorSchemeSeed: Theme.of(context).primaryColor),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
