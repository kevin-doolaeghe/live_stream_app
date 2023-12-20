import 'package:flutter_test/flutter_test.dart';
import 'package:live_stream_app/main.dart';

void main() {
  testWidgets('Application test', (WidgetTester tester) async {
    await tester.pumpWidget(const App());
  });
}
