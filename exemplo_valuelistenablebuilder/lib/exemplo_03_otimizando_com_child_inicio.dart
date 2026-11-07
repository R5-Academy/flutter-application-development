// exemplo_03_otimizando_com_child_inicio.dart
// Ponto de partida: a mesma tela duas vezes, uma em cima da outra. As duas
// metades são idênticas — mesmo builder, mesmo bloco caro dentro dele.
//
// Cada bloco caro conta os próprios builds e mostra o número na tela.
//
// Rode e toque no + cinco vezes. Os dois placares marcam 6, e é o esperado: o
// `_ResumoDoProduto` nasce DENTRO do builder, então é reconstruído a cada
// mudança do valor — mesmo sem depender dela.
//
// ? O bloco caro recebe dados de fora, então não dá para marcá-lo `const` no
// ? ponto de uso — se desse, o framework curto-circuitaria sozinho e não
// ? haveria problema. `const` é assunto de Foundations; o que falta aqui é uma
// ? saída para o caso, muito mais comum, em que `const` não é possível.
// ?
// ?   **como manter um widget dentro do builder sem reconstruí-lo?**
// ?
// ? O `ValueListenableBuilder` tem um terceiro parâmetro que você ainda não usou
// ? — e o `builder` recebe um terceiro argumento que, até agora, veio sempre
// ? `null`.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaCarrinho()));

// O "widget caro". Ele recebe dados de fora, então não dá para marcar `const`
// no ponto de uso - e por isso o Flutter o reconstrói a cada build do pai.
// ? Se ele fosse `const`, o framework curto-circuitaria sozinho (a mesma
// ? instância cai no atalho de framework.dart:4014) e o `child` não faria
// ? diferença nenhuma. `const` é assunto de Foundations; o `child` existe
// ? justamente para o caso — o mais comum — em que `const` não é possível.
class const _ResumoDoProduto({
  required final String nome,
  required final String rotulo,
}) extends StatefulWidget {
  @override
  State<_ResumoDoProduto> createState() => _ResumoDoProdutoState();
}

class _ResumoDoProdutoState extends State<_ResumoDoProduto> {
  // O placar do bloco caro: é este número que separa as duas metades da tela.
  int _builds = 0;

  @override
  Widget build(BuildContext context) {
    _builds++;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.headphones, size: 40),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.nome),
                Text(
                  'bloco caro: $_builds builds',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TelaCarrinho extends StatefulWidget {
  const TelaCarrinho({super.key});

  @override
  State<TelaCarrinho> createState() => _TelaCarrinhoState();
}

class _TelaCarrinhoState extends State<TelaCarrinho> {
  final _itens = ValueNotifier<int>(0);
  final _nome = 'Fone de Ouvido Bluetooth';

  @override
  void dispose() {
    _itens.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('O parâmetro child')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('metade de cima'),
            ValueListenableBuilder<int>(
              valueListenable: _itens,
              builder: (context, quantidade, child) {
                return Column(
                  children: [
                    _ResumoDoProduto(nome: _nome, rotulo: 'metade de cima'),
                    Text('$quantidade itens'),
                  ],
                );
              },
            ),
            const SizedBox(height: 32),
            // A metade de baixo é, por enquanto, IDÊNTICA à de cima.
            const Text('metade de baixo'),
            ValueListenableBuilder<int>(
              valueListenable: _itens,
              builder: (context, quantidade, child) {
                return Column(
                  children: [
                    _ResumoDoProduto(nome: _nome, rotulo: 'metade de baixo'),
                    Text('$quantidade itens'),
                  ],
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _itens.value++,
        child: const Icon(Icons.add),
      ),
    );
  }
}
