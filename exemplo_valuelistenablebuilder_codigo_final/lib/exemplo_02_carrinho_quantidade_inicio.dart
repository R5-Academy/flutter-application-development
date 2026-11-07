// exemplo_02_carrinho_quantidade_inicio.dart
// Ponto de partida: um card de produto com botões de + e -, do jeito que ele
// apareceria num app de verdade.
//
// Rode e toque nos botões. O notifier muda — o `_quantidade.value` sobe e desce
// corretamente — e o número na tela fica em 1.
//
// ? A tela tem duas partes bem diferentes: o card do produto (ícone, nome,
// ? preço), que nunca muda, e o número entre os dois botões, que muda toda hora.
// ?
// ?   **onde exatamente o builder deve começar?**
// ?
// ? Guarde a pergunta: envolver demais custa caro, e é o assunto do último
// ? exemplo desta aula.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaProduto()));

class TelaProduto extends StatefulWidget {
  const TelaProduto({super.key});

  @override
  State<TelaProduto> createState() => _TelaProdutoState();
}

class _TelaProdutoState extends State<TelaProduto> {
  final _quantidade = ValueNotifier<int>(1);

  @override
  void dispose() {
    _quantidade.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Produto')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // O card do produto não depende da quantidade: fica fora do builder
            // e nunca reconstroi ao mudar o número.
            const Card(
              child: ListTile(
                leading: Icon(Icons.headphones, size: 40),
                title: Text('Fone de Ouvido Bluetooth'),
                subtitle: Text('R\$ 199,90'),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton.filledTonal(
                  onPressed: () {
                    // Não deixa a quantidade cair abaixo de 1.
                    if (_quantidade.value > 1) _quantidade.value--;
                  },
                  icon: const Icon(Icons.remove),
                ),
                // O número é lido uma vez, quando a tela monta.
                ValueListenableBuilder(
                  valueListenable: _quantidade,
                  builder: (context, value, child) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        '$value',
                        style: const TextStyle(fontSize: 28),
                      ),
                    );
                  },
                ),
                IconButton.filledTonal(
                  onPressed: () => _quantidade.value++,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
