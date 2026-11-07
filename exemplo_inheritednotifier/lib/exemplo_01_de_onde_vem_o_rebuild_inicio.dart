// exemplo_01_de_onde_vem_o_rebuild_inicio.dart
// Ponto de partida: a loja da aula passada, sem mudar uma linha do que você já
// escreveu — CarrinhoProvider (Stateful, dono do _total) + CarrinhoScope
// (InheritedWidget, que entrega o valor). Novo aqui: dois placares de build.
//
// Rode e toque no "+" de um produto. Funciona: o badge do AppBar sobe. Repare no
// painel amarelo do rodapé enquanto clica.
//
// ? O provedor reconstrói a cada toque. E ele não desenha nada — o build dele só
// ? existe para fabricar um CarrinhoScope novo, com o total novo, e deixar o
// ? updateShouldNotify decidir quem avisar.
// ?
// ?   **o estado precisa mesmo morar dentro de um widget para chegar na árvore?**
// ?
// ? A seção passada inteira foi sobre um objeto que sabe avisar que mudou.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: CarrinhoProvider(child: Home())));

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

  // Escrito à mão: é você quem sabe qual campo importa comparar.
  @override
  bool updateShouldNotify(CarrinhoScope oldWidget) => total != oldWidget.total;
}

// Quem GUARDA o estado: um StatefulWidget acima do Scope.
class const CarrinhoProvider({super.key, required final Widget child})
    extends StatefulWidget {
  @override
  State<CarrinhoProvider> createState() => _CarrinhoProviderState();
}

class _CarrinhoProviderState extends State<CarrinhoProvider> {
  int _total = 0;
  int _builds = 0;

  void _adicionar() => setState(() => _total++);

  @override
  Widget build(BuildContext context) {
    _builds++;

    // A cada setState, um CarrinhoScope NOVO é criado com o valor atual. Como o
    // total mudou, updateShouldNotify devolve true e os dependentes reconstroem.
    return CarrinhoScope(
      total: _total,
      adicionar: _adicionar,
      child: PainelDeBuilds(builds: _builds, child: widget.child),
    );
  }
}

// Instrumentação: mostra quantas vezes o provedor rodou o build, sem interferir
// na tela. Aparece nos dois arquivos.
class const PainelDeBuilds({
  super.key,
  required final int builds,
  required final Widget child,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        child,
        Positioned(
          left: 8,
          bottom: 8,
          child: Material(
            color: Colors.amber,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text('provedor: $builds builds'),
            ),
          ),
        ),
      ],
    );
  }
}

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
      floatingActionButton: const EspiaDoTotal(),
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

// O espião da aula passada, agora contando os próprios builds: ele é dependente
// do escopo, então reconstrói toda vez que o carrinho muda.
class EspiaDoTotal extends StatefulWidget {
  const EspiaDoTotal({super.key});

  @override
  State<EspiaDoTotal> createState() => _EspiaDoTotalState();
}

class _EspiaDoTotalState extends State<EspiaDoTotal> {
  int _builds = 0;

  @override
  Widget build(BuildContext context) {
    final total = CarrinhoScope.of(context).total;
    _builds++;

    return FloatingActionButton.extended(
      onPressed: null,
      label: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('total real: $total'),
          Text('espião: $_builds builds'),
        ],
      ),
    );
  }
}
