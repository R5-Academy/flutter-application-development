// exemplo_02_inherited_minimo_inicio.dart
// Ponto de partida: o bloco anterior deixou uma pergunta em aberto — como pôr o
// dado **na árvore** sem passá-lo por parâmetro?
//
// * Aqui a árvore está montada e os intermediários já estão limpos: `Corpo` e
// * `ListaProdutos` não recebem nada. Só falta a peça que entrega o total.
//
// ! Hoje o `BadgeCarrinho` mostra um valor **fixo**, escrito nele mesmo. Ele não
// ! tem de onde ler.
//
// ? O Flutter tem um tipo de widget feito para isso: ele fica **acima** na
// ? árvore e qualquer descendente pega o valor dele pelo `context` — o mesmo
// ? mecanismo de `Theme.of(context)`, `MediaQuery.of(context)` e
// ? `Localizations.of(context)`, que você usa desde a fase 03.
//
// ? Todos esses são `InheritedWidget`. Neste bloco a gente escreve um.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: Home()));

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    // ! Nenhum widget acima entrega o total.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loja'),
        actions: const [BadgeCarrinho(), SizedBox(width: 12)],
      ),
      body: const Corpo(),
    );
  }
}

class BadgeCarrinho extends StatelessWidget {
  const BadgeCarrinho({super.key});

  @override
  Widget build(BuildContext context) {
    // ! Valor fixo: não há de onde ler.
    const total = 0;

    return const Center(
      child: Badge(label: Text('$total'), child: Icon(Icons.shopping_cart)),
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
    return ListTile(title: Text(nome), trailing: const Icon(Icons.add));
  }
}
