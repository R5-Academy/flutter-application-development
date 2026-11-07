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

  void _mostrar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Foto adicionada ao álbum'),
        // ! `fixed` é o padrão: largura total, sem cantos, empurra o FAB.
        behavior: SnackBarBehavior.fixed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SnackBar: aparência')),
      body: Center(
        child: FilledButton(
          onPressed: () => _mostrar(context),
          child: const Text('Adicionar foto'),
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
