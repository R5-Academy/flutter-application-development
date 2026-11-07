// exemplo_03_floating_shape_inicio.dart
// Ponto de partida: o aviso de "foto adicionada", no comportamento **padrão**
// do SnackBar.
//
// Repare na tela: há um FAB no canto inferior direito.
//
// ! Toque no botão e observe o FAB: ele **pula para cima** para dar lugar à
// ! barra, e volta quando ela some. A cada aviso, um elemento da interface se
// ! mexe.
//
// ! E a barra em si: largura total, colada na base, cantos retos. Ela parece
// ! parte da moldura do app, não uma mensagem passageira.
//
// ? O Material 3 tem outro comportamento para o SnackBar — e ele resolve as
// ? duas coisas.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaAparencia()));

class TelaAparencia extends StatelessWidget {
  const TelaAparencia({super.key});

  void _mostrarFixed(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Foto adicionada ao álbum'),
        behavior: SnackBarBehavior.fixed,
      ),
    );
  }

  void _mostrarFloating(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Foto adicionada ao álbum'),
        behavior: SnackBarBehavior.floating,
        margin: .all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.indigo,
        duration: Duration(seconds: 2),
        showCloseIcon: true,
        persist: false,
        action: SnackBarAction(label: 'Ver álbum', onPressed: () {}),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SnackBar: aparência')),
      body: Center(
        child: Column(
          children: [
            FilledButton(
              onPressed: () => _mostrarFloating(context),
              child: const Text('Mostrar floating'),
            ),
            OutlinedButton(
              onPressed: () => _mostrarFixed(context),
              child: Text('Mostrar Fixed'),
            ),
          ],
        ),
      ),
      // O FAB deixa a diferença visível: o fixed empurra ele para cima.
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
