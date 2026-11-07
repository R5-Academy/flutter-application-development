import 'package:exemplo_setstate/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('abre o launcher com os exemplos', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Launcher()));

    expect(find.text('01 · Mínimo'), findsOneWidget);
    expect(find.text('05 · Armadilha após dispose'), findsOneWidget);
  });
}
