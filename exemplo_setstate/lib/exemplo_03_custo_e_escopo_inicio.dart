// exemplo_03_custo_e_escopo_inicio.dart
// Ponto de partida: a tela de um pedido — o resumo da entrega no topo, o seletor
// de quantidade do produto em promoção e o catálogo embaixo. O seletor funciona;
// o `setState` está no lugar certo.
//
// * Para enxergar o custo, cada peça mostra **na própria tela** quantas vezes já
// * foi construída. **Toque em "Adicionar" três vezes e leia os três números.**
//
// ! Os três sobem juntos: entrega **4**, catálogo **4**, seletor **4** (o
// ! primeiro build mais três toques).
// !
// ! O resumo da entrega e o catálogo são reconstruídos **toda vez**, e nenhum
// ! dos dois tem qualquer relação com a quantidade de café no carrinho.
//
// ! A causa está em **onde o estado mora**. O `_quantidade` é um campo de
// ! `_TelaDoPedidoState`, então `setState` marca **a tela inteira** como *dirty*,
// ! e o `build` dela roda por completo — entrega, seletor, catálogo.
//
// ! Numa tela pequena isso é irrelevante. Numa tela com lista longa, gráfico ou
// ! imagem processada, é o motivo de a interface engasgar ao digitar num campo.
//
// ? O `setState` reconstrói **quem o chamou**. Se o rebuild está grande demais,
// ? a pergunta não é "como reconstruir menos" — é **"por que o estado está tão
// ? longe de quem o usa?"**

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaDoPedido()));

class TelaDoPedido extends StatefulWidget {
  const TelaDoPedido({super.key});

  @override
  State<TelaDoPedido> createState() => _TelaDoPedidoState();
}

class _TelaDoPedidoState extends State<TelaDoPedido> {
  // ! O estado do seletor mora na tela — longe do único widget que o usa.
  int _quantidade = 0;

  int _builds = 0;

  // Dados que a tela repassa aos filhos. Como vêm de campos de instância, as
  // chamadas dos filhos não são `const` — igual a qualquer tela real que exibe
  // dados vindos de fora.
  final _cliente = 'Ana';
  final _produtos = List<String>.of(_catalogo);

  @override
  Widget build(BuildContext context) {
    _builds++;

    return Scaffold(
      appBar: AppBar(title: const Text('Meu pedido')),
      body: Column(
        children: [
          _ResumoDaEntrega(cliente: _cliente),
          const SizedBox(height: 24),
          Text(
            'Café em grão: $_quantidade un.',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          _Placar(nome: 'seletor', builds: _builds),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () => setState(() => _quantidade++),
            child: const Text('Adicionar'),
          ),
          const SizedBox(height: 24),
          Expanded(child: _CatalogoDeProdutos(produtos: _produtos)),
        ],
      ),
    );
  }
}

const _catalogo = <String>[
  'Pão de forma integral',
  'Leite integral 1 L',
  'Ovos caipira · dúzia',
  'Arroz agulhinha 5 kg',
  'Feijão carioca 1 kg',
  'Macarrão parafuso 500 g',
  'Molho de tomate 340 g',
  'Azeite extra virgem 500 ml',
  'Queijo minas frescal',
  'Presunto fatiado 200 g',
  'Manteiga com sal 200 g',
  'Iogurte natural 170 g',
  'Banana prata · kg',
  'Tomate italiano · kg',
  'Alface crespa · unidade',
  'Detergente neutro 500 ml',
];

// O placar da aula: conta os próprios builds e mostra o número na tela. É ele
// que transforma "o rebuild é grande" numa afirmação que dá para conferir.
class const _Placar({required final String nome, required final int builds})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      '$nome: $builds builds',
      style: Theme.of(context).textTheme.labelLarge,
    );
  }
}

// O resumo da entrega: um cabeçalho caro de construir, como o de qualquer app
// de delivery (endereço, prazo, faixa de frete).
class const _ResumoDaEntrega({required final String cliente})
    extends StatefulWidget {
  @override
  State<_ResumoDaEntrega> createState() => _ResumoDaEntregaState();
}

class _ResumoDaEntregaState extends State<_ResumoDaEntrega> {
  int _builds = 0;

  @override
  Widget build(BuildContext context) {
    _builds++;

    return Container(
      height: 80,
      alignment: Alignment.center,
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Entrega para ${widget.cliente} · hoje até 18h'),
          _Placar(nome: 'entrega', builds: _builds),
        ],
      ),
    );
  }
}

class const _CatalogoDeProdutos({required final List<String> produtos})
    extends StatefulWidget {
  @override
  State<_CatalogoDeProdutos> createState() => _CatalogoDeProdutosState();
}

class _CatalogoDeProdutosState extends State<_CatalogoDeProdutos> {
  int _builds = 0;

  @override
  Widget build(BuildContext context) {
    _builds++;

    return Column(
      children: [
        _Placar(nome: 'catálogo', builds: _builds),
        Expanded(
          child: ListView.builder(
            itemCount: widget.produtos.length,
            itemBuilder: (_, index) =>
                ListTile(title: Text(widget.produtos[index])),
          ),
        ),
      ],
    );
  }
}
