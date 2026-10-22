import 'package:flutter_test/flutter_test.dart';
import 'package:tmdb_flutter/bootstrap.dart';

void main() {
  testWidgets('missing access token shows setup instructions', (tester) async {
    await tester.pumpWidget(const AppBootstrap());

    expect(find.textContaining('не задан'), findsOneWidget);
    expect(
      find.textContaining(
        '--dart-define-from-file=config/dart_defines.json',
      ),
      findsOneWidget,
    );
  });
}
