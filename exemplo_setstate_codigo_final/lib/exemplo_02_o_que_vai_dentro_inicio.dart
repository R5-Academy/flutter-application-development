// exemplo_02_o_que_vai_dentro_inicio.dart
// Ponto de partida: um carrinho. Toque num produto e a quantidade sobe; o total
// acompanha. Funciona.
//
// ? Mas olhe **o que foi parar dentro** do callback do `setState`. Quatro coisas:
// ?
// ?   a atribuição da quantidade      <- o build precisa disso
// ?   o recálculo do total            <- é **derivado** da quantidade
// ?   um `debugPrint`                 <- efeito colateral
// ?   uma chamada de analytics        <- I/O
//
// ! O callback do `setState` é **síncrono** e roda no meio do disparo do
// ! rebuild. Tudo que estiver ali segura o frame.
//
// ! E o `_total` como **campo** cria um problema pior que lentidão: agora há
// ! dois dados que precisam concordar. Basta alguém mexer em `_quantidades` em
// ! outro lugar e esquecer de recalcular o total — e a tela mostra uma soma
// ! errada, sem erro nenhum.
//
// ? Duas perguntas para o bloco:
// ?   o que o `setState` **precisa** que aconteça dentro dele?
// ?   e um valor que se **calcula** a partir de outro precisa mesmo ser campo?

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: Carrinho()));

class const Produto(final String nome, final double preco);

class Carrinho extends StatefulWidget {
  const Carrinho({super.key});

  @override
  State<Carrinho> createState() => _CarrinhoState();
}

class _CarrinhoState extends State<Carrinho> {
  static const _catalogo = <Produto>[
    Produto('Café', 12.0),
    Produto('Pão', 8.0),
    Produto('Leite', 6.0),
  ];

  final List<int> _quantidades = [0, 0, 0];

  // ! Um segundo dado que precisa concordar com o primeiro.
  double get _total {
    var soma = 0.0;
    for (var i = 0; i < _catalogo.length; i++) {
      soma += _catalogo[i].preco * _quantidades[i];
    }
    return soma;
  }

  void _adicionar(int indice) {
    final novaQuantidade = _quantidades[indice] + 1;

    // ! Efeito colateral.
    debugPrint('Adicionado ${_catalogo[indice].nome}');
    // ! I/O (aqui simulado).
    _registrarAnalytics(_catalogo[indice].nome);

    setState(() {
      _quantidades[indice] = novaQuantidade;
    });
  }

  void _registrarAnalytics(String produto) {
    debugPrint('analytics: add_to_cart $produto');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Carrinho')),
      body: ListView.builder(
        itemCount: _catalogo.length,
        itemBuilder: (_, index) {
          return ListTile(
            title: Text(_catalogo[index].nome),
            subtitle: Text('R\$ ${_catalogo[index].preco.toStringAsFixed(2)}'),
            trailing: Text('${_quantidades[index]} un.'),
            onTap: () => _adicionar(index),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          'Total: R\$ ${_total.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}
