// exemplo_02_depender_vs_so_ler_inicio.dart
// Ponto de partida: o escopo funcionando, com DOIS consumidores do mesmo
// contador — e os dois usando `of(context)`.
//
// O `Placar` mostra o valor. O botão só chama `incrementar()`.
//
// Rode e clique três vezes. Os dois placares de build sobem juntos:
//
//   Placar: 4 builds     (faz sentido — ele mostra o número)
//   botão:  4 builds     (e este, por quê?)
//
// ? O botão não desenha o valor em lugar nenhum. Ele só precisou do notifier por
// ? um instante, para chamar um método, e mesmo assim virou dependente do
// ? escopo — reconstrói toda vez que o contador avisa.
// ?
// ?   **dá para pegar o notifier SEM se inscrever para receber os avisos?**
// ?
// ? Dá, e o `ContadorScope` abaixo já tem os dois caminhos escritos. Repare no
// ? que muda entre eles: um chama `dependOnInheritedWidgetOfExactType`, o outro
// ? chama `getInheritedWidgetOfExactType`.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: Home()));

class Contador extends ChangeNotifier {
  int _valor = 0;
  int get valor => _valor;

  void incrementar() {
    _valor++;
    notifyListeners();
  }
}

class ContadorScope extends InheritedNotifier<Contador> {
  const ContadorScope({
    super.key,
    required Contador notifier,
    required super.child,
  }) : super(notifier: notifier);

  // DEPENDE: lê o notifier E registra o chamador como dependente. Reconstrói
  // quando o contador avisa. Use em quem MOSTRA o valor.
  static Contador of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ContadorScope>();
    assert(scope != null, 'Nenhum ContadorScope encontrado no contexto');
    return scope!.notifier!;
  }

  // SÓ LÊ: pega o mesmo notifier SEM registrar dependência. Não reconstrói
  // quando o valor muda. Bom para um onPressed, que só quer chamar um método.
  // Medido, 3 cliques: com of() no onPressed o botão reconstrói 3 vezes; com
  // espiar(), 0 vezes. O Placar reconstrói 3 nos dois casos.
  static Contador espiar(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<ContadorScope>();
    assert(scope != null, 'Nenhum ContadorScope encontrado no contexto');
    return scope!.notifier!;
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final contador = Contador();

  @override
  Widget build(BuildContext context) {
    return ContadorScope(
      notifier: contador,
      child: Scaffold(
        appBar: AppBar(title: const Text('Depender ou só ler')),
        body: const Center(child: Placar()),
        floatingActionButton: const BotaoAdicionar(),
      ),
    );
  }
}

class Placar extends StatefulWidget {
  const Placar({super.key});

  @override
  State<Placar> createState() => _PlacarState();
}

class _PlacarState extends State<Placar> {
  int _builds = 0;

  @override
  Widget build(BuildContext context) {
    // Depende via of(): reconstroi a cada aviso do contador.
    final valor = ContadorScope.of(context).valor;
    _builds++;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Valor: $valor', style: const TextStyle(fontSize: 32)),
        Text(
          'Placar: $_builds builds',
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ],
    );
  }
}

class BotaoAdicionar extends StatefulWidget {
  const BotaoAdicionar({super.key});

  @override
  State<BotaoAdicionar> createState() => _BotaoAdicionarState();
}

class _BotaoAdicionarState extends State<BotaoAdicionar> {
  int _builds = 0;

  @override
  Widget build(BuildContext context) {
    _builds++;

    return FloatingActionButton.extended(
      onPressed: () => ContadorScope.of(context).incrementar(),
      icon: const Icon(Icons.add),
      label: Text('botão: $_builds builds'),
    );
  }
}
