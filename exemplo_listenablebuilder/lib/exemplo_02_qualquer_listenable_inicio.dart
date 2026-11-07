// exemplo_02_qualquer_listenable_inicio.dart
// Ponto de partida: um catálogo rolável, com dois indicadores que deveriam
// acompanhar a rolagem — e nenhum dos dois acompanha.
//
//   a barra do topo   deveria mostrar quanto do catálogo já passou
//   o botão flutuante deveria acender depois que você desce um pouco
//
// Rode e role a lista até o fim: a barra fica travada em 0% e o botão continua
// apagado. Os dois leem um número que nunca é lido de novo — o primeiro build
// leu, e ninguém avisou que mudou.
//
// ? O `ScrollController` aqui embaixo não é uma classe sua. Você não escreveu
// ? `notifyListeners()` em lugar nenhum deste arquivo — e mesmo assim ele já
// ? avisa quem quiser ouvir, a cada pixel rolado, desde a primeira lista que
// ? você montou lá em Scrollables.
// ?
// ?   **o que ele tem em comum com o `Contador` do exemplo anterior?**
// ?
// ? A resposta é o tipo que dá nome ao widget de hoje.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaCatalogo()));

class TelaCatalogo extends StatefulWidget {
  const TelaCatalogo({super.key});

  @override
  State<TelaCatalogo> createState() => _TelaCatalogoState();
}

class _TelaCatalogoState extends State<TelaCatalogo> {
  // Não é uma classe nossa, e mesmo assim já é um observável.
  final _rolagem = ScrollController();

  static const _frutas = [
    'Abacate',
    'Abacaxi',
    'Acerola',
    'Ameixa',
    'Banana',
    'Caju',
    'Caqui',
    'Carambola',
    'Cereja',
    'Coco',
    'Damasco',
    'Figo',
    'Framboesa',
    'Goiaba',
    'Graviola',
    'Jabuticaba',
    'Jaca',
    'Kiwi',
    'Laranja',
    'Limão',
    'Maçã',
    'Mamão',
    'Manga',
    'Maracujá',
    'Melancia',
    'Melão',
    'Morango',
    'Nectarina',
    'Pera',
    'Pêssego',
    'Pitaya',
    'Romã',
    'Tangerina',
    'Uva',
  ];

  @override
  void dispose() {
    // Quem cria, descarta — vale para os controllers do Flutter também.
    _rolagem.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Catálogo')),
      body: Column(
        children: [
          // A barra nasce em 0% e fica lá: ninguém a avisa de que a lista andou.
          const _BarraDeLeitura(progresso: 0),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              controller: _rolagem,
              itemCount: _frutas.length,
              itemBuilder: (_, index) => ListTile(
                leading: Text('${index + 1}'),
                title: Text(_frutas[index]),
              ),
            ),
          ),
        ],
      ),
      // O botão existe, mas nasce apagado e nunca acende.
      floatingActionButton: const _BotaoVoltarAoTopo(aoTocar: null),
    );
  }
}

class const _BarraDeLeitura({required final double progresso})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '${(progresso * 100).round()}% do catálogo',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: progresso),
        ],
      ),
    );
  }
}

class const _BotaoVoltarAoTopo({required final VoidCallback? aoTocar})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: aoTocar,
      tooltip: 'Voltar ao topo',
      child: const Icon(Icons.arrow_upward),
    );
  }
}
