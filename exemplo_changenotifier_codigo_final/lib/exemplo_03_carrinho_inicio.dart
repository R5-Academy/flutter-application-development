// exemplo_03_carrinho_inicio.dart
// Ponto de partida: a cafeteria montada, com o carrinho ainda mudo.
//
// A classe Carrinho já estende ChangeNotifier e já tem a lista privada, mas
// ela não expõe nada e não faz nada: os botões de + e - estão apagados, e o
// rodapé mostra o estado vazio.
//
// Rode e olhe a tela. Esta é a diferença que a aula vai atacar: até agora o
// estado era UM número. Um carrinho não é um número — é uma lista de itens,
// uma quantidade total e um valor total, que precisam andar juntos.
//
// ? Antes de escrever, decida duas coisas:
// ?
// ?   1. o rodapé precisa do total e da quantidade. Guardo um campo para cada
// ?      um e atualizo a cada mudança, ou calculo na hora a partir de `_itens`?
// ?   2. se eu expuser `_itens` direto, o que impede alguém de fora dar
// ?      `.add()` na lista sem passar pelos meus métodos?

import 'package:material_ui/material_ui.dart';

class const Produto(final String nome, final double preco);

class ItemCarrinho(final Produto produto, [var int quantidade = 1]) {
  double get subtotal => produto.preco * quantidade;
}

// O esqueleto do modelo: a lista privada e UM getter derivado, de amostra.
// O resto — o que ele expõe, o que ele calcula e o que ele avisa — é o que a
// gente escreve nesta aula.
class Carrinho extends ChangeNotifier {
  // Campo privado: ninguém de fora mexe na lista sem passar pelos meus métodos.
  final List<ItemCarrinho> _itens = [];

  List<ItemCarrinho> get itens => List.unmodifiable(_itens);
  int get quantidadeTotal => _itens.fold(0, (s, i) => s + i.quantidade);
  double get total => _itens.fold(0, (s, i) => s + i.subtotal);

  // Getter DERIVADO: a resposta é calculada a partir de _itens, não guardada
  // num campo à parte. Os outros dois seguem o mesmo princípio.
  bool get vazio => _itens.isEmpty;

  void adicionar(Produto produto) {
    final existente = _itens.where((i) => i.produto == produto).firstOrNull;
    if (existente != null) {
      existente.quantidade++;
    } else {
      _itens.add(ItemCarrinho(produto));
    }
    notifyListeners();
  }

  void diminuir(Produto produto) {
    final existente = _itens.where((i) => i.produto == produto).firstOrNull;
    if (existente == null) return;

    existente.quantidade--;

    if (existente.quantidade <= 0) {
      _itens.remove(existente);
    }
    notifyListeners();
  }

  void limpar() {
    if (_itens.isEmpty) return;
    _itens.clear();
    notifyListeners();
  }
}

const _catalogo = [
  Produto('Café', 8.50),
  Produto('Pão de queijo', 5.00),
  Produto('Suco', 7.00),
];

void main() => runApp(const MaterialApp(home: TelaLoja()));

class TelaLoja extends StatefulWidget {
  const TelaLoja({super.key});

  @override
  State<TelaLoja> createState() => _TelaLojaState();
}

class _TelaLojaState extends State<TelaLoja> {
  late final Carrinho _carrinho;

  @override
  void initState() {
    super.initState();
    _carrinho = Carrinho();
  }

  @override
  void dispose() {
    _carrinho.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cafeteria'),
        actions: [
          IconButton(
            onPressed: _carrinho.limpar,
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Limpar carrinho',
          ),
        ],
      ),
      body: Column(
        children: [
          for (final produto in _catalogo)
            ListTile(
              title: Text(produto.nome),
              subtitle: Text('R\$ ${produto.preco.toStringAsFixed(2)}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => _carrinho.diminuir(produto),
                    icon: const Icon(Icons.remove),
                  ),
                  IconButton(
                    onPressed: () => _carrinho.adicionar(produto),
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ),
          const Divider(),
          Expanded(
            child: ListenableBuilder(
              listenable: _carrinho,
              builder: (_, _) {
                if (_carrinho.vazio) {
                  return Center(child: Text('Carrinho vazio'));
                }
                return Column(
                  mainAxisAlignment: .center,
                  children: [
                    Text('Itens: ${_carrinho.quantidadeTotal}'),
                    Text(
                      'Total R\$ ${_carrinho.total.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
