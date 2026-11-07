// exemplo_02_builder_e_context_inicio.dart
// Ponto de partida: uma lista de produtos. Como o bloco anterior mostrou que a
// rota é um objeto, aqui alguém foi um passo além e construiu **a tela** antes
// também, guardando-a numa variável.
//
// *     final tela = DetalheProduto(produto: produto);
// *     builder: (novoContext) => tela,
//
// * Funciona. O detalhe abre com o produto certo.
//
// ! Mas abra o console e toque num produto. Repare **quando** a mensagem
// ! "construindo DetalheProduto" aparece: no momento em que a tela **é
// ! construída**, não quando ela aparece.
//
// ! Agora repare no pior: rode e **role a lista sem tocar em nada**. Com este
// ! código, se a construção estivesse num lugar percorrido pela lista, as telas
// ! seriam criadas para produtos que ninguém abriu.
//
// ? O `builder` recebe uma **função** por um motivo. Se ele quisesse um widget
// ? pronto, o parâmetro se chamaria `child` e teria o tipo `Widget` — como em
// ? tantos outros widgets do Flutter.
// ?
// ? Que diferença faz receber uma função em vez do widget?

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: ListaProdutos()));

class const Produto(final String nome, final double preco);

class ListaProdutos extends StatelessWidget {
  const ListaProdutos({super.key});

  static const _produtos = [
    Produto('Camiseta', 79.90),
    Produto('Tênis', 299.90),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Produtos')),
      body: ListView.builder(
        itemCount: _produtos.length,
        itemBuilder: (_, index) {
          final produto = _produtos[index];

          return ListTile(
            title: Text(produto.nome),
            onTap: () {
              // ! A tela é construída AQUI, antes de qualquer navegação.
              debugPrint('Realizando o push');
              Navigator.push(
                context,
                // ! E o builder só devolve o que já existe.
                MaterialPageRoute<void>(
                  builder: (novoContext) {
                    debugPrint('Chamou o builder da rota');
                    return DetalheProduto(produto: produto);
                  },
                ),
              );
              debugPrint('Finalizou o botão');
            },
          );
        },
      ),
    );
  }
}

class DetalheProduto({super.key, required final Produto produto})
    extends StatelessWidget {
  // O corpo do construtor primário entra num bloco `this { ... }`.
  this {
    // Só para a aula: mostra no console quando a tela é construída.
    debugPrint('construindo DetalheProduto: ${produto.nome}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(produto.nome)),
      body: Center(child: Text('R\$ ${produto.preco.toStringAsFixed(2)}')),
    );
  }
}
