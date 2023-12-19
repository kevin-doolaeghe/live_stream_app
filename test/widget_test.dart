import 'package:flutter_test/flutter_test.dart';
import 'package:live_stream_app/app.dart';

void main() {
  testWidgets('Application test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const LiveStreamApp());
  });
}
