// exemplo_04_armadilha_mutacao_inicio.dart
// Ponto de partida: um carrinho num `ValueNotifier<List<String>>`, com um botão
// que adiciona itens.
//
// Rode e toque em "Adicionar" duas vezes.
//
// ! A tela continua em "Carrinho vazio". E o dado NÃO está errado: os dois itens
// ! entraram na lista. Só ninguém foi avisado.
//
// ? O método faz `_itens.value.add(...)`. Ele mexe na lista que está dentro do
// ? notifier — e nunca atribui nada ao `.value`.
// ?
// ?   **se o setter é quem notifica, e ninguém chamou o setter, quem avisaria?**
// ?
// ? O botão de baixo está apagado: ele chama o método que ainda não existe.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaCarrinho()));

class TelaCarrinho extends StatefulWidget {
  const TelaCarrinho({super.key});

  @override
  State<TelaCarrinho> createState() => _TelaCarrinhoState();
}

class _TelaCarrinhoState extends State<TelaCarrinho> {
  final _itens = ValueNotifier<List<String>>([]);

  @override
  void dispose() {
    _itens.dispose();
    super.dispose();
  }

  // Muta a lista por dentro. A referência continua a mesma, o setter do value
  // nem roda — e o ValueListenableBuilder não reconstrói.
  void _adicionarErrado() {
    _itens.value.add('Item ${_itens.value.length + 1}');
  }

  void _adicionarCerto() {
    _itens.value = [..._itens.value, 'Item ${_itens.value.length + 1}'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mexendo numa lista')),
      body: ValueListenableBuilder<List<String>>(
        valueListenable: _itens,
        builder: (context, itens, child) {
          if (itens.isEmpty) {
            return const Center(child: Text('Carrinho vazio'));
          }
          return ListView.builder(
            itemCount: itens.length,
            itemBuilder: (_, index) {
              final item = itens[index];
              return ListTile(title: Text(item));
            },
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.extended(
            onPressed: _adicionarErrado,
            heroTag: 'errado',
            label: const Text('Adicionar'),
          ),
          const SizedBox(height: 12),
          FloatingActionButton.extended(
            onPressed: _adicionarCerto,
            heroTag: 'certo',
            label: Text('Adicionar (outro jeito)'),
          ),
        ],
      ),
    );
  }
}
