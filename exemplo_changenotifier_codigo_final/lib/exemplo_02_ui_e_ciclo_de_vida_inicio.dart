// exemplo_02_ui_e_ciclo_de_vida_inicio.dart
// Ponto de partida: o Contador do exemplo anterior, agora dentro de uma tela.
//
// O notifier é campo do State: criado uma vez no initState e liberado no
// dispose. Esse é o lugar dele — quem cria, descarta. (O que acontece quando
// se erra esse lugar tem exemplo próprio nesta aula, o exemplo_05.)
//
// Rode e toque no botão algumas vezes.
//
// ! O texto continua em "Cliques: 0". Medido: três toques deixam o campo
// ! `_contador.valor` em 3 e o `Text` em "Cliques: 0".
//
// ? O `incrementar()` roda, o campo muda e o `notifyListeners()` dispara — o
// ? exemplo anterior provou isso no console. O que falta aqui não é do lado do
// ? modelo:
// ?
// ?   **quem, do lado da tela, está registrado para ouvir?**
// ?
// ? Ninguém. O `build` leu `_contador.valor` uma vez, quando montou a tela, e
// ? nunca mais foi chamado.

import 'package:material_ui/material_ui.dart';

class Contador extends ChangeNotifier {
  int _valor = 0;

  int get valor => _valor;

  void incrementar() {
    _valor++;
    notifyListeners();
  }
}

void main() => runApp(const MaterialApp(home: TelaContador()));

class TelaContador extends StatefulWidget {
  const TelaContador({super.key});

  @override
  State<TelaContador> createState() => _TelaContadorState();
}

class _TelaContadorState extends State<TelaContador> {
  // late porque criamos no initState. Este State é o "dono" do notifier.
  late final Contador _contador;

  @override
  void initState() {
    super.initState();
    _contador = Contador();
  }

  @override
  void dispose() {
    _contador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Build da pagina');
    return Scaffold(
      appBar: AppBar(title: const Text('ChangeNotifier na tela')),
      body: Center(
        child: ListenableBuilder(
          listenable: _contador,
          builder: (context, child) {
            debugPrint('Build do Texto');
            return Text(
              'Cliques: ${_contador.valor}',
              style: Theme.of(context).textTheme.headlineMedium,
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // A UI só chama métodos de negócio. Ela NUNCA chama notifyListeners().
        onPressed: _contador.incrementar,
        child: const Icon(Icons.add),
      ),
    );
  }
}
