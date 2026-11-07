// exemplo_04_alcance_builder_vs_escopo_inicio.dart
// Ponto de partida: a tela resolvida do jeito que você já sabia — com o
// `ListenableBuilder` da seção anterior.
//
// Funciona: adicione itens e o painel lá no fundo acompanha.
//
// ? Mas siga o carrinho com o dedo, de cima para baixo. Ele sai da tela, entra
// ? no `LadoBuilder`, atravessa o `PainelBuilder` e só então chega em quem
// ? realmente o usa. Dos três widgets no caminho, **dois não fazem nada com
// ? ele** — só repassam.
// ?
// ?   **e se o widget que precisa do carrinho estiver dez níveis abaixo?**
// ?
// ? Dez construtores com um parâmetro que não interessa a nenhum deles. É esse
// ? o problema que o `InheritedNotifier` resolve — e repare desde já: ele não
// ? vai reconstruir menos. Vai alcançar mais longe.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaComparacao()));

class Carrinho extends ChangeNotifier {
  int _itens = 0;
  int get itens => _itens;

  void adicionar() {
    _itens++;
    notifyListeners();
  }
}

class CarrinhoScope extends InheritedNotifier<Carrinho> {
  const CarrinhoScope({
    super.key,
    required Carrinho notifier,
    required super.child,
  }) : super(notifier: notifier);

  static Carrinho of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<CarrinhoScope>();
    assert(scope != null, 'Nenhum CarrinhoScope encontrado no contexto');
    return scope!.notifier!;
  }

  static Carrinho espiar(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<CarrinhoScope>();
    assert(scope != null, 'Nenhum CarrinhoScope encontrado no contexto');
    return scope!.notifier!;
  }
}

class TelaComparacao extends StatefulWidget {
  const TelaComparacao({super.key});

  @override
  State<TelaComparacao> createState() => _TelaComparacaoState();
}

class _TelaComparacaoState extends State<TelaComparacao> {
  final carrinho = Carrinho();

  @override
  void dispose() {
    carrinho.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CarrinhoScope(
      notifier: carrinho,
      child: Scaffold(
        appBar: AppBar(title: const Text('Como o objeto chega lá')),
        body: Column(
          children: [
            // * Metade de cima: o carrinho desce de parâmetro em parâmetro até
            //   o builder. Três widgets no caminho precisam conhecê-lo, e dois
            //   deles não usam o valor para nada — só repassam.
            Expanded(child: LadoBuilder(carrinho: carrinho)),
            Expanded(child: LadoEscopo()),
          ],
        ),
        floatingActionButton: const BotaoAdicionar(),
      ),
    );
  }
}

class LadoBuilder extends StatelessWidget {
  const LadoBuilder({super.key, required this.carrinho});

  final Carrinho carrinho;

  @override
  Widget build(BuildContext context) {
    // ! Repasse nº 1: este widget não usa o carrinho, só o entrega adiante.
    return PainelBuilder(carrinho: carrinho);
  }
}

class PainelBuilder extends StatelessWidget {
  const PainelBuilder({super.key, required this.carrinho});

  final Carrinho carrinho;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('ListenableBuilder', style: TextStyle(fontSize: 12)),
          // ! Repasse nº 2 chega aqui: so agora o objeto e usado.
          ListenableBuilder(
            listenable: carrinho,
            builder: (context, child) =>
                ContadorPintado(rotulo: 'itens: ${carrinho.itens}'),
          ),
        ],
      ),
    );
  }
}

// Bancada: o cartão que mostra o número e conta os próprios builds, para as
// duas metades poderem ser comparadas na tela.
class ContadorPintado extends StatefulWidget {
  const ContadorPintado({super.key, required this.rotulo});

  final String rotulo;

  @override
  State<ContadorPintado> createState() => _ContadorPintadoState();
}

class _ContadorPintadoState extends State<ContadorPintado> {
  int _builds = 0;

  @override
  Widget build(BuildContext context) {
    _builds++;
    return Column(
      children: [
        Text(widget.rotulo, style: const TextStyle(fontSize: 28)),
        Text('$_builds builds', style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

class BotaoAdicionar extends StatelessWidget {
  const BotaoAdicionar({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => CarrinhoScope.espiar(context).adicionar(),
      child: const Icon(Icons.add_shopping_cart),
    );
  }
}

class LadoEscopo extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return PainelEscopo();
  }
}

class PainelEscopo extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final itens = CarrinhoScope.of(context).itens;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('ListenableBuilder', style: TextStyle(fontSize: 12)),

        ContadorPintado(rotulo: 'itens: $itens'),
      ],
    );
  }
}
