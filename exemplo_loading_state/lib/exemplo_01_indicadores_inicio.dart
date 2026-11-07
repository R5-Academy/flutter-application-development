// exemplo_01_indicadores_inicio.dart
// Ponto de partida: a tela montada, com dois espaços reservados no lugar dos
// indicadores.
//
// ? O Material já traz os dois widgets prontos, e a escolha entre eles não é de
// ? gosto — é de contexto: um ocupa o centro de uma tela vazia, o outro é uma
// ? linha fina que cabe no topo de um card.
// ?
// ?   **quanto espaço cada um ocupa, e onde cada um cabe?**
// ?
// ? Troque os `Placeholder` pelos widgets de verdade e meça na tela.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaIndicadores()));

class TelaIndicadores extends StatelessWidget {
  const TelaIndicadores({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Indicadores de loading')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('CircularProgressIndicator'),
            SizedBox(height: 12),
            Placeholder(fallbackHeight: 36, fallbackWidth: 36),

            SizedBox(height: 48),

            Text('LinearProgressIndicator'),
            SizedBox(height: 12),
            Placeholder(fallbackHeight: 4),
          ],
        ),
      ),
    );
  }
}
