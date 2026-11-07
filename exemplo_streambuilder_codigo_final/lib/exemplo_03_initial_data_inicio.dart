// exemplo_03_initial_data_inicio.dart
// Ponto de partida: um stream que só começa a emitir depois de 3 segundos.
//
// Rode e conte: por três segundos inteiros a tela mostra "(ainda sem dado)".
// Só então o primeiro número aparece.
//
// ? Esse "vazio inicial" é real e tem explicação: o `builder` sempre roda ANTES
// ? de o listener processar o primeiro evento, então o primeiro build vem com
// ? `hasData == false`. Num app, isso é o campo que pisca vazio, o saldo que
// ? aparece como "--" antes de virar número.
// ?
// ?   **e se eu já souber um valor razoável para mostrar enquanto espero?**
// ?
// ? O `StreamBuilder` tem um parâmetro exatamente para isso, e ele muda também
// ? o formato do seu `builder`.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaComparaInitial()));

class TelaComparaInitial extends StatefulWidget {
  const TelaComparaInitial({super.key});

  @override
  State<TelaComparaInitial> createState() => _TelaComparaInitialState();
}

class _TelaComparaInitialState extends State<TelaComparaInitial> {
  // O stream só começa a emitir depois de 3 segundos; assim dá tempo de ver a
  // diferença no primeiro frame.
  late final Stream<int> _ticks;

  @override
  void initState() {
    super.initState();
    // ! O .asBroadcastStream() é obrigatório AQUI porque dois StreamBuilder vão
    // ! ouvir o mesmo stream. Sem ele: Bad state: Stream has already been
    // ! listened to. Com um StreamBuilder só (exemplos 01, 02 e 05) não precisa.
    // O .take(5) faz o stream TERMINAR depois de 5 eventos. Sem ele, o
    // Stream.periodic mantém um Timer vivo para sempre — inclusive depois de a
    // tela sair da árvore, porque ninguém cancela a fonte de um broadcast.
    _ticks = Stream.periodic(
      const Duration(seconds: 3),
      (count) => count + 1,
    ).take(5).asBroadcastStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('initialData')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('O que a tela mostra nos 3 primeiros segundos:'),
            StreamBuilder<int>(
              stream: _ticks,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Text(
                    '(ainda sem dado)',
                    style: TextStyle(fontSize: 24),
                  );
                }
                return Text(
                  '${snapshot.data}',
                  style: const TextStyle(fontSize: 24),
                );
              },
            ),

            const SizedBox(height: 20),
            Text('Com initiData: 0'),
            StreamBuilder<int>(
              stream: _ticks,
              initialData: 0,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Text(
                    '(ainda sem dado)',
                    style: TextStyle(fontSize: 24),
                  );
                }
                return Text(
                  '${snapshot.data} ${snapshot.connectionState}',
                  style: const TextStyle(fontSize: 24),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
