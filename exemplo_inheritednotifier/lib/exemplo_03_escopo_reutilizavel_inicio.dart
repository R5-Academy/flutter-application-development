// exemplo_03_escopo_reutilizavel_inicio.dart
// Ponto de partida: o escopo funcionando de verdade, com três pontos DISTANTES
// da árvore lendo o mesmo carrinho — o badge no AppBar, o total no meio e os
// botões no fundo da lista. Ninguém passou parâmetro para ninguém.
//
// Rode e adicione itens: os três reagem juntos, e a `ListaProdutos` — que não
// chamou `of()` — fica parada.
//
// ? Agora olhe para a `TelaCarrinho` abaixo. Ela acumula dois papéis: é a tela
// ? E é a dona do notifier (cria, monta o escopo, descarta). Amanhã, para
// ? colocar um carrinho numa segunda tela, esse trio de responsabilidades seria
// ? copiado inteiro.
// ?
// ?   **como transformar "ser dono do notifier" num widget que se reusa?**

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaCarrinho()));

// O modelo do carrinho. O dispose() ja vem pronto do ChangeNotifier - quem cria
// o notifier e quem o descarta, regra da aula de ValueNotifier (seção anterior).
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

// A tela é a dona do notifier: cria no State (não no build, senão nasce um
// notifier novo a cada rebuild), monta o escopo e descarta no fim.
class TelaCarrinho extends StatefulWidget {
  const TelaCarrinho({super.key});

  @override
  State<TelaCarrinho> createState() => _TelaCarrinhoState();
}

class _TelaCarrinhoState extends State<TelaCarrinho> {
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
        appBar: AppBar(
          title: const Text('Loja'),
          actions: const [BadgeCarrinho()],
        ),
        body: const Column(
          children: [
            TotalDestaque(),
            Expanded(child: ListaProdutos()),
          ],
        ),
      ),
    );
  }
}

// Badge no AppBar: ponto distante nº 1. Depende do escopo -> reconstrói.
class BadgeCarrinho extends StatelessWidget {
  const BadgeCarrinho({super.key});

  @override
  Widget build(BuildContext context) {
    final itens = CarrinhoScope.of(context).itens;
    debugPrint('BadgeCarrinho reconstruiu: itens=$itens');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Center(
        child: Text('Carrinho: $itens', style: const TextStyle(fontSize: 18)),
      ),
    );
  }
}

// Total em destaque no meio: ponto distante nº 2. Também depende -> reconstrói.
class TotalDestaque extends StatelessWidget {
  const TotalDestaque({super.key});

  @override
  Widget build(BuildContext context) {
    final itens = CarrinhoScope.of(context).itens;
    debugPrint('TotalDestaque reconstruiu: itens=$itens');
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Text(
        'Itens no carrinho: $itens',
        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      ),
    );
  }
}

// * A lista NÃO reconstroi quando o carrinho muda - e não e por ser const.
//   Quando o notifier avisa, quem se marca para reconstruir e o ELEMENTO do
//   CarrinhoScope; o build dele devolve o MESMO child de sempre, e o framework
//   corta a árvore ali. Medido: tirando o const daqui, o número de builds
//   continua 1. Quem reconstroi e só quem chamou of().
class ListaProdutos extends StatelessWidget {
  const ListaProdutos({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint(
      'ListaProdutos reconstruiu (so no inicio - nao depende do escopo)',
    );
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (_, index) {
        final i = index + 1;
        return Card(
          child: ListTile(
            title: Text('Produto $i'),
            trailing: const BotaoAdicionar(),
          ),
        );
      },
    );
  }
}

class BotaoAdicionar extends StatelessWidget {
  const BotaoAdicionar({super.key});

  @override
  Widget build(BuildContext context) {
    // Só dispara a ação: lê sem depender. Os botões não reconstroem a cada item.
    return IconButton(
      onPressed: () => CarrinhoScope.espiar(context).adicionar(),
      icon: const Icon(Icons.add_shopping_cart),
    );
  }
}
