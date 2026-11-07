// exemplo_02_estados_no_tempo_inicio.dart
// Ponto de partida: um stream que conta até 3 e fecha, ligado a um
// `StreamBuilder` que olha só o `data`.
//
// Rode e observe: o número sobe de 1 a 3, um por segundo. Funciona.
//
// ! Mas repare no primeiro segundo, antes do 1 chegar: a tela mostra `-`. E
// ! depois que a contagem para no 3, ela continua mostrando 3 — parada. Nos dois
// ! momentos o `StreamBuilder` sabe exatamente o que está acontecendo (ainda não
// ! emitiu nada / o stream fechou), e este código não pergunta.
//
// O `snapshot` não guarda só o valor: ele guarda em que FASE a conexão está.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaEstados()));

// Gerador de stream: emite 1, 2, 3... até 'n', com uma pausa entre cada.
// Ao terminar o corpo do async*, o stream completa.
Stream<int> contarAte(int n) async* {
  for (var i = 1; i <= n; i++) {
    await Future.delayed(const Duration(seconds: 2));
    yield i; // emite um valor
  }
}

class TelaEstados extends StatefulWidget {
  const TelaEstados({super.key});

  @override
  State<TelaEstados> createState() => _TelaEstadosState();
}

class _TelaEstadosState extends State<TelaEstados> {
  late final Stream<int> _contagem;

  @override
  void initState() {
    super.initState();
    _contagem = contarAte(3);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Estados no tempo')),
      body: Center(
        child: StreamBuilder<int>(
          stream: _contagem,
          builder: (context, snapshot) {
            // ! A única coisa que perguntamos ao snapshot. O `-` do começo e o
            // ! número parado do fim saem os dois daqui, e a tela não sabe
            // ! distinguir "ainda não começou" de "já acabou".
            final estado = snapshot.connectionState;
            final valor = snapshot.hasData ? '${snapshot.data}' : '-';

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'connectionState: $estado',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  'ultimo valor: $valor',
                  style: const TextStyle(fontSize: 32),
                ),

                if (estado == .done) Text('Stream Fechou (done)'),
              ],
            );
          },
        ),
      ),
    );
  }
}
