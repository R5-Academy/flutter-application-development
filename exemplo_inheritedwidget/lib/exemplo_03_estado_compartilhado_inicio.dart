// exemplo_03_estado_compartilhado_inicio.dart
// Ponto de partida: o `CarrinhoScope` do bloco anterior, agora entregando
// **duas** coisas — o total e o método `adicionar`. O botão lá no fundo já
// consegue chamá-lo pelo contexto.
//
// * Toque no "+". O botão de baixo relê a mesma variável e mostra o total
// * subindo: 1, 2, 3...
//
// ! E o badge lá em cima continua em **0**. Dois números na mesma tela,
// ! discordando.
//
// ! É o problema do bloco 1 de novo — e a causa é a mesma, por um motivo que
// ! vale enunciar com clareza: **`InheritedWidget` é imutável**. Ele é um
// ! widget; seus campos são `final`. O `total: 0` foi fixado quando esta
// ! instância foi construída, e ela não muda nunca.
//
// ! Guardar o número num campo mutável fora dele (como está aqui) não ajuda: o
// ! `CarrinhoScope` que está na árvore continua sendo **aquele**, com o valor
// ! **daquele momento**.
//
// ? Então como o total muda?
// ?
// ? A resposta está no que um `InheritedWidget` é: **um widget**. E widgets não
// ? mudam — eles são **substituídos** por instâncias novas. Quem faz isso, no
// ? Flutter, é sempre a mesma coisa.

import 'package:material_ui/material_ui.dart';

class const CarrinhoScope({
  super.key,
  required final int total,
  required final VoidCallback adicionar,
  required super.child,
}) extends InheritedWidget {
  static CarrinhoScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<CarrinhoScope>();
    assert(scope != null, 'Nenhum CarrinhoScope encontrado no contexto');
    return scope!;
  }

  @override
  bool updateShouldNotify(CarrinhoScope oldWidget) => total != oldWidget.total;
}

// ! Estado num campo mutável fora da árvore: o Scope não fica sabendo.
int _total = 0;

void main() => runApp(
  MaterialApp(
    home: CarrinhoScope(
      total: _total,
      adicionar: () {
        // ! O número sobe, mas nenhuma instância nova do Scope é criada.
        _total++;
      },
      child: const Home(),
    ),
  ),
);

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loja'),
        actions: const [BadgeCarrinho(), SizedBox(width: 12)],
      ),
      body: const Corpo(),
      floatingActionButton: const _EspiaDoTotal(),
    );
  }
}

class BadgeCarrinho extends StatelessWidget {
  const BadgeCarrinho({super.key});

  @override
  Widget build(BuildContext context) {
    final total = CarrinhoScope.of(context).total;

    return Center(
      child: Badge(
        label: Text('$total'),
        child: const Icon(Icons.shopping_cart),
      ),
    );
  }
}

class Corpo extends StatelessWidget {
  const Corpo({super.key});

  @override
  Widget build(BuildContext context) => const ListaProdutos();
}

class ListaProdutos extends StatelessWidget {
  const ListaProdutos({super.key});

  static const _produtos = ['Café', 'Pão', 'Leite'];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _produtos.length,
      itemBuilder: (_, index) {
        final nome = _produtos[index];
        return CardProduto(nome: nome);
      },
    );
  }
}

class const CardProduto({super.key, required final String nome})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(nome),
      trailing: IconButton(
        icon: const Icon(Icons.add),
        // O botão lá no fundo chama o método que veio do topo.
        onPressed: CarrinhoScope.of(context).adicionar,
      ),
    );
  }
}

// A prova de que o dado está lá. Este botão reconstrói **a si mesmo** quando
// tocado, então mostra o total de verdade — enquanto o badge, que depende do
// Scope, continua parado: nenhuma instância nova do CarrinhoScope foi criada.
class _EspiaDoTotal extends StatefulWidget {
  const _EspiaDoTotal();

  @override
  State<_EspiaDoTotal> createState() => _EspiaDoTotalState();
}

class _EspiaDoTotalState extends State<_EspiaDoTotal> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => setState(() {}),
      label: Text('total real: $_total — toque para reler'),
    );
  }
}
