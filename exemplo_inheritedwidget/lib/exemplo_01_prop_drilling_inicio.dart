// exemplo_01_prop_drilling_inicio.dart
// Ponto de partida: uma loja. O total do carrinho nasce na `Home` (o topo) e
// precisa chegar em **dois pontos distantes**: o badge do `AppBar` e o botão lá
// no fundo da lista.
//
// * Com o que a aula de `setState` ensinou, a solução é a única possível:
// * **passar por parâmetro**.
//
// ! Siga o `total` com o dedo:
// !
// !     Home -> Corpo -> ListaProdutos -> CardProduto
// !             (não usa)  (não usa)        (usa)
// !
// ! **Dois widgets carregam um parâmetro que não usam.** E o `onAdicionar` faz
// ! o mesmo caminho na volta.
//
// ! O nome disso é *prop drilling*, e ele apareceu no fecho da aula de
// ! `setState`: "começa a doer quando muitos widgets distantes precisam do mesmo
// ! dado". É este o momento. E o incômodo aqui é maior do que numa tela só:
// ! cada widget novo no caminho precisa lembrar de repassar os dois.
//
// ! E o custo real não é a digitação: `Corpo` e `ListaProdutos` **passaram a
// ! depender do carrinho na assinatura**. Reusá-los em outra tela obriga a
// ! inventar um total; testá-los obriga a passar um.
//
// ? A primeira ideia de quem quer resolver isso costuma ser tirar o dado da
// ? árvore: uma **variável global**, acessível de qualquer lugar. Vale tentar —
// ? o que se aprende com o fracasso dela é o que explica o `InheritedWidget`.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: Home()));

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _total = 0;

  void _adicionar() => setState(() => _total++);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loja'),
        // O badge usa o total.
        actions: [
          BadgeCarrinho(total: _total),
          const SizedBox(width: 12),
        ],
      ),
      // ! Corpo recebe os dois só para repassar.
      body: Corpo(total: _total, onAdicionar: _adicionar),
    );
  }
}

class const BadgeCarrinho({super.key, required final int total})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Badge(
        label: Text('$total'),
        child: const Icon(Icons.shopping_cart),
      ),
    );
  }
}

class const Corpo({
  super.key,
  required final int total,
  required final VoidCallback onAdicionar,
}) extends StatelessWidget {
  // ! Não usa nenhum dos dois. Só repassa.
  @override
  Widget build(BuildContext context) {
    return ListaProdutos(total: total, onAdicionar: onAdicionar);
  }
}

class const ListaProdutos({
  super.key,
  required final int total,
  required final VoidCallback onAdicionar,
}) extends StatelessWidget {
  static const _produtos = ['Café', 'Pão', 'Leite'];

  // ! Também não usa. Também repassa.
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _produtos.length,
      itemBuilder: (_, index) {
        final nome = _produtos[index];
        return CardProduto(nome: nome, onAdicionar: onAdicionar);
      },
    );
  }
}

class const CardProduto({
  super.key,
  required final String nome,
  required final VoidCallback onAdicionar,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(nome),
      trailing: IconButton(icon: const Icon(Icons.add), onPressed: onAdicionar),
    );
  }
}
