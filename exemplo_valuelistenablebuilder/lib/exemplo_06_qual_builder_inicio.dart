// exemplo_06_qual_builder_inicio.dart
// Ponto de partida: dois estados na mesma tela, e um só jeito de observar.
//
//   _cliques     ValueNotifier<int>  — um valor
//   _termometro  ChangeNotifier      — dois campos (celsius e fahrenheit)
//
// Os dois estão escutados pelo `ListenableBuilder` da aula 05, que aceita
// qualquer `Listenable` — inclusive o `ValueNotifier`, porque ele É um
// `ChangeNotifier`. Rode: funciona nos dois.
//
// ? Repare no builder de cima. Ele recebe `(context, child)` e, para saber o
// ? número, precisa ir buscar em `_cliques.value`. O objeto tem UM valor e ainda
// ? assim a leitura é indireta.
// ?
// ?   **e o builder que você aprendeu hoje, que já entrega o valor na mão?**
// ?
// ? Ele serve para o de cima. A pergunta desta comparação é o de baixo.
//
// ! ATENÇÃO, REVISOR: este par renderiza A MESMA TELA nos dois lados, e isso é
// ! deliberado — a igualdade É a lição. Os dois builders produzem exatamente o
// ! mesmo resultado; o que muda é quem entrega o valor ao `builder`. Não
// ! "conserte" inventando uma diferença visual. Travado em teste:
// ! test/.../07-valuelistenablebuilder/pares_test.dart, grupo "bloco 6".

import 'package:material_ui/material_ui.dart';

// Estado com vários campos derivados: não existe um `value` único.
class Termometro extends ChangeNotifier {
  double _celsius = 20;

  double get celsius => _celsius;
  double get fahrenheit => _celsius * 9 / 5 + 32;

  void aquecer() {
    _celsius++;
    notifyListeners();
  }
}

void main() => runApp(const MaterialApp(home: TelaComparacao()));

class TelaComparacao extends StatefulWidget {
  const TelaComparacao({super.key});

  @override
  State<TelaComparacao> createState() => _TelaComparacaoState();
}

class _TelaComparacaoState extends State<TelaComparacao> {
  // Um valor único.
  final _cliques = ValueNotifier<int>(0);
  // Vários campos derivados.
  final _termometro = Termometro();

  @override
  void dispose() {
    _cliques.dispose();
    _termometro.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Um valor ou vários campos')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Um valor só:'),
          // Lido com o builder genérico: é preciso ir buscar em `.value`.
          ListenableBuilder(
            listenable: _cliques,
            builder: (context, child) => Text(
              'Cliques: ${_cliques.value}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          FilledButton(
            onPressed: () => _cliques.value++,
            child: const Text('Clicar'),
          ),
          const Divider(height: 40),
          const Text('Vários campos:'),
          // Não há `value`: lemos celsius E fahrenheit direto do notifier.
          ListenableBuilder(
            listenable: _termometro,
            builder: (context, child) => Text(
              '${_termometro.celsius.toStringAsFixed(0)} C  |  '
              '${_termometro.fahrenheit.toStringAsFixed(0)} F',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          FilledButton(
            onPressed: _termometro.aquecer,
            child: const Text('Aquecer'),
          ),
        ],
      ),
    );
  }
}
