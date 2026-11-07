// exemplo_01_minimo_inicio.dart
// Ponto de partida: a tela de um produto, com o botão que adiciona ao carrinho.
// Você já escreveu este código em Foundations e já usou `setState` a fase 03
// inteira — a novidade aqui **não** é como usar, é o que ele faz por baixo e por
// que ele quebra nos dois casos dos blocos 4 e 5.
//
// * O `_quantidade++` roda de verdade — o `debugPrint` no console prova: 1, 2, 3.
//
// ! **E a tela não muda.** O texto continua "No carrinho: 0 un.". Medido: três
// ! toques deixam o campo em **3** e o `Text` em **"No carrinho: 0 un."**.
//
// ? Não é novidade que falta o `setState`. A pergunta desta aula é outra, e ela
// ? é a fonte de metade da confusão com estado no Flutter:
// ?
// ?   **quem, exatamente, guarda o valor novo?**
// ?
// ? Muita gente responde "o `setState`". Se fosse verdade, um `setState` com
// ? callback **vazio** não faria nada — e ele faz. Guarde a pergunta; o
// ? `_completo` responde com as duas medições.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaDoProduto()));

class TelaDoProduto extends StatefulWidget {
  const TelaDoProduto({super.key});

  @override
  State<TelaDoProduto> createState() => _TelaDoProdutoState();
}

class _TelaDoProdutoState extends State<TelaDoProduto> {
  int _quantidade = 0;

  void _adicionar() {
    setState(() {
      _quantidade++;
    });
  }

  void _avisarSemMudarNada() {
    _quantidade += 10;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Café em grão · 500 g')),
      body: Center(
        child: Column(
          children: [
            Text(
              'No carrinho: $_quantidade un.',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            TextButton(onPressed: _avisarSemMudarNada, child: Text('Soma 10')),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _adicionar,
        child: const Icon(Icons.add_shopping_cart),
      ),
    );
  }
}
