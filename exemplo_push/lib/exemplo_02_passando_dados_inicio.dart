// exemplo_02_passando_dados_inicio.dart
// Ponto de partida: uma lista de produtos — cara de app de verdade. Tocar em
// qualquer item abre a tela de detalhe com `Navigator.push`, exatamente como o
// bloco anterior ensinou.
//
// ! Rode e toque nos três produtos, um de cada vez. **A tela de detalhe é
// ! sempre a mesma.** "Camiseta", "Tênis" ou "Boné" levam ao mesmo lugar
// ! genérico, que não sabe qual produto foi tocado.
//
// ! E não é bug: olhe o `builder`. Ele constrói `const TelaDetalheProduto()`,
// ! sem argumento nenhum. A informação de qual item foi clicado existe na lista
// ! (a variável `produto` do laço), mas nunca chega ao destino.
//
// ? A pergunta parece difícil — "como passo dados por uma rota?" — e a resposta
// ? é mais simples do que parece. Olhe com atenção o que o `builder` **é**.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaProdutos()));

class const Produto(final String nome, final double preco);

class TelaProdutos extends StatelessWidget {
  const TelaProdutos({super.key});

  static const _produtos = [
    Produto('Camiseta', 79.90),
    Produto('Tênis', 299.90),
    Produto('Boné', 49.90),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Produtos')),
      body: ListView(
        children: [
          for (final produto in _produtos)
            ListTile(
              title: Text(produto.nome),
              trailing: Text('R\$ ${produto.preco.toStringAsFixed(2)}'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    // ! O produto tocado está aqui à mão, e mesmo assim a tela
                    // ! de destino é construída sem ele.
                    builder: (novoContext) => const TelaDetalheProduto(),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class const TelaDetalheProduto({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhe')),
      body: Center(
        child: Text(
          'Qual produto era mesmo?',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}
