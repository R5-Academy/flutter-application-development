// exemplo_05_armadilha_inicio.dart
// Ponto de partida: um StreamBuilder cujo Stream nasce dentro do `build`.
//
// Rode, deixe o contador subir até uns 5, e aperte o botão "+" — que só muda um
// número na tela, nada a ver com o stream.
//
// ! O contador ZERA. E zera de novo a cada toque.
//
// ? Cada rebuild cria um Stream NOVO. O StreamBuilder vê um stream diferente,
// ? cancela a inscrição antiga e assina o novo — que começa do zero.
// ?
// ?   **onde esse Stream deveria nascer?**
// ?
// ? É a mesma resposta do Future, uma aula atrás. E repare no que este exemplo
// ? mostra a mais: aqui o estrago é VISÍVEL (o número zera), enquanto no Future
// ? era invisível. Streams reiniciam; Futures só refazem o trabalho calados.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaComparacao()));

class TelaComparacao extends StatefulWidget {
  const TelaComparacao({super.key});

  @override
  State<TelaComparacao> createState() => _TelaComparacaoState();
}

class _TelaComparacaoState extends State<TelaComparacao> {
  int _rebuilds = 0;
  late final _streamCerto = Stream.periodic(
    const Duration(seconds: 1),
    (count) => count,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Onde o Stream nasce')),
      floatingActionButton: FloatingActionButton(
        // Cada toque chama setState -> build roda de novo. E ai que a diferenca
        // aparece: o rebuild e o que reinicia o Stream criado no lugar errado.
        onPressed: () => setState(() => _rebuilds++),
        child: const Icon(Icons.add),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Rebuilds: $_rebuilds'),
            const SizedBox(height: 32),

            // ! ERRADO: o Stream nasce aqui, dentro do build. A cada rebuild um
            // ! Stream novo é criado, o StreamBuilder o vê como diferente,
            // ! cancela a inscrição antiga e assina o novo -- ou seja, recomeca
            // ! do zero. O contador volta para o começo a cada toque.
            const Text('O Stream nasce dentro do build:'),
            StreamBuilder<int>(
              stream: Stream.periodic(
                const Duration(seconds: 1),
                (count) => count,
              ),
              builder: (context, snapshot) {
                return Text(
                  '${snapshot.data ?? 0}',
                  style: const TextStyle(fontSize: 28),
                );
              },
            ),
            const SizedBox(height: 32),
            StreamBuilder<int>(
              stream: _streamCerto,
              builder: (context, snapshot) {
                return Text(
                  '${snapshot.data ?? 0}',
                  style: const TextStyle(fontSize: 28),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
