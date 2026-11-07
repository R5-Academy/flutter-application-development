// exemplo_02_compartilhado_entre_telas_inicio.dart
// Ponto de partida: o provedor do bloco anterior, agora com um carrinho de
// verdade — lista de produtos, itens e total.
//
// A tela de produtos funciona: adicione e o número no topo acompanha.
//
// ? Só que um carrinho não vive numa tela só. Falta a segunda rota — a que
// ? mostra o que foi comprado — e com ela chegam duas decisões que esta aula
// ? existe para resolver:
// ?
// ?   1. o botão de adicionar precisa RECONSTRUIR quando o carrinho muda?
// ?   2. e o badge do topo, precisa arrastar a tela inteira junto?
// ?
// ? As duas têm a mesma resposta: **não** — e as duas ferramentas para isso já
// ? estão na sua mão.

import 'package:material_ui/material_ui.dart';

class const Produto(final String nome, final double preco);

const catalogo = [
  Produto('Camiseta', 79.90),
  Produto('Boné', 49.90),
  Produto('Meia', 19.90),
];

class CarrinhoModel extends ChangeNotifier {
  final _itens = <Produto>[];

  // Lista somente-leitura: a UI lê, mas não altera por fora do modelo.
  List<Produto> get itens => List.unmodifiable(_itens);
  int get quantidade => _itens.length;
  double get total => _itens.fold(0, (soma, p) => soma + p.preco);

  void adicionar(Produto p) {
    _itens.add(p);
    notifyListeners();
  }

  void remover(Produto p) {
    _itens.remove(p);
    notifyListeners();
  }
}

class CarrinhoProvider extends InheritedNotifier<CarrinhoModel> {
  const CarrinhoProvider({
    super.key,
    required CarrinhoModel super.notifier,
    required super.child,
  });

  // of: CRIA dependência. Use para LER e MOSTRAR o dado (rebuilda quando muda).
  static CarrinhoModel of(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<CarrinhoProvider>();
    assert(provider != null, 'CarrinhoProvider não encontrado na árvore');
    return provider!.notifier!;
  }
}

void main() {
  runApp(
    // * Provedor acima do MaterialApp/Navigator: as duas rotas veem o MESMO
    // * carrinho, e o dado sobrevive ao push/pop.
    CarrinhoProvider(notifier: CarrinhoModel(), child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: TelaProdutos());
  }
}

class TelaProdutos extends StatelessWidget {
  const TelaProdutos({super.key});

  @override
  Widget build(BuildContext context) {
    // Lê criando dependência: este build roda de novo a cada mudança.
    final carrinho = CarrinhoProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(child: Text('Carrinho: ${carrinho.quantidade}')),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: catalogo.length,
        itemBuilder: (_, index) {
          final p = catalogo[index];
          return ListTile(
            title: Text(p.nome),
            subtitle: Text('R\$ ${p.preco.toStringAsFixed(2)}'),
            trailing: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => carrinho.adicionar(p),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: null,
        label: const Text('Ver carrinho'),
        icon: const Icon(Icons.shopping_cart),
      ),
    );
  }
}
