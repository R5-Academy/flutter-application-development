// exemplo_05_ciclo_de_vida_inicio.dart
// Ponto de partida: duas telas montadas do jeito certo, para a gente quebrar
// de propósito e ver o sintoma.
//
// A) "Onde criar o notifier" — o Contador é campo do State, criado no
//    initState e liberado no dispose, como no exemplo_02. Rode, some alguns
//    cliques e toque em "Mudar só o título": o número FICA onde estava.
//
// B) "Usar depois do dispose" — a tela libera o notifier no botão 1, e os
//    botões 2 e 3 estão apagados de propósito.
//
// ? Existe um terceiro erro de ciclo de vida, e ele é o pior justamente porque
// ? não tem sintoma nenhum:
// ?
// ?   **o que o Flutter faz quando você simplesmente ESQUECE o dispose?**
// ?
// ? Guarde o palpite. A resposta está medida no _completo, e ela surpreende.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaMenu()));

class Contador extends ChangeNotifier {
  int _valor = 0;
  int get valor => _valor;

  void incrementar() {
    _valor++;
    if (hasListeners) notifyListeners();
  }
}

class TelaMenu extends StatelessWidget {
  const TelaMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ciclo de vida do notifier')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 16,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const TelaOndeCriar())),
              child: const Text('A) Onde criar o notifier'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const TelaDepoisDoDispose()),
              ),
              child: const Text('B) Usar depois do dispose'),
            ),
          ],
        ),
      ),
    );
  }
}

class TelaOndeCriar extends StatefulWidget {
  const TelaOndeCriar({super.key});

  @override
  State<TelaOndeCriar> createState() => _TelaOndeCriarState();
}

class _TelaOndeCriarState extends State<TelaOndeCriar> {
  var _titulo = 'Contador';

  // late final Contador _contador;

  @override
  void initState() {
    super.initState();
    // _contador = Contador();
  }

  @override
  void dispose() {
    // _contador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final contador = Contador();
    debugPrint('build: nasceu o notifier #${identityHashCode(contador)}');
    return Scaffold(
      appBar: AppBar(title: Text(_titulo)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 24,
          children: [
            ListenableBuilder(
              listenable: contador,
              builder: (context, child) => Text(
                '${contador.valor}',
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ),
            // Este botão não mexe no contador — só troca o título da AppBar,
            // forçando um rebuild.
            OutlinedButton(
              onPressed: () => setState(() {
                _titulo = _titulo == 'Contador'
                    ? 'Contador (rebuild)'
                    : 'Contador';
              }),
              child: const Text('Mudar só o título'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: contador.incrementar,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TelaDepoisDoDispose extends StatefulWidget {
  const TelaDepoisDoDispose({super.key});

  @override
  State<TelaDepoisDoDispose> createState() => _TelaDepoisDoDisposeState();
}

class _TelaDepoisDoDisposeState extends State<TelaDepoisDoDispose> {
  final _contador = Contador();
  var _liberado = false;

  @override
  void dispose() {
    // Se o botão já liberou, chamar de novo lança o mesmo erro: dispose() em
    // cima de um notifier já liberado não é permitido.
    if (!_liberado) {
      _contador.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Depois do dispose')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 16,
          children: [
            ListenableBuilder(
              listenable: _contador,
              builder: (context, child) => Text(
                '${_contador.valor}',
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ),
            ElevatedButton(
              onPressed: _liberado
                  ? null
                  : () => setState(() {
                      _contador.dispose();
                      _liberado = true;
                    }),
              child: const Text('1. Liberar o notifier (dispose)'),
            ),
            ElevatedButton(
              onPressed: () => _contador.incrementar(),
              child: Text('2. Somar 1'),
            ),
            const OutlinedButton(
              onPressed: null,
              child: Text('3. Ler o valor'),
            ),
          ],
        ),
      ),
    );
  }
}
