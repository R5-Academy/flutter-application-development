// exemplo_02_tentar_de_novo_inicio.dart
// Ponto de partida: a tela de produtos com a tela de erro já pronta — ícone,
// frase clara e um botão "Tentar de novo". O serviço falha nas duas primeiras
// tentativas e entrega os dados na terceira.
//
// ! Rode e aperte "Tentar de novo". Aperte de novo. E de novo. Nada acontece:
// ! nem o spinner volta, nem os produtos chegam. A terceira tentativa, que
// ! deveria funcionar, nunca é feita.
//
// ! O botão chama `setState` — e o `setState` roda mesmo. O `build` roda de
// ! novo. O que ele NÃO faz é refazer a busca: o `FutureBuilder` recebe o mesmo
// ! `Future`, aquele que já falhou, e um `Future` só entrega o resultado uma vez.
//
// Botão de retry que não repete a busca é decoração. Falta trocar o `Future`.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaProdutos()));

class ServicoProdutos {
  int _tentativas = 0;

  Future<List<String>> buscar() async {
    _tentativas++;
    await Future.delayed(const Duration(seconds: 1));
    // Falha nas duas primeiras tentativas; na terceira, entrega os dados.
    if (_tentativas < 3) {
      throw Exception('Falha ao conectar ao servidor');
    }
    return const ['Camiseta', 'Caneca', 'Adesivo'];
  }
}

class TelaProdutos extends StatefulWidget {
  const TelaProdutos({super.key});

  @override
  State<TelaProdutos> createState() => _TelaProdutosState();
}

class _TelaProdutosState extends State<TelaProdutos> {
  final _servico = ServicoProdutos();

  late Future<List<String>> _futureProdutos;

  @override
  void initState() {
    super.initState();
    // Dispara a PRIMEIRA busca uma única vez.
    _futureProdutos = _servico.buscar();
  }

  void _tentarDeNovo() {
    // ! Aqui está o furo. O setState avisa o framework que algo mudou e o build
    // ! roda — mas `_futureProdutos` continua apontando para o MESMO Future de
    // ! antes. O FutureBuilder compara a identidade do que recebeu, vê que é o
    // ! mesmo objeto, e não recomeça ciclo nenhum.
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Produtos')),
      body: Center(
        child: FutureBuilder<List<String>>(
          future: _futureProdutos,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            if (snapshot.hasError) {
              // A tela de erro completa: icone + frase clara + ação de saída.
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.cloud_off, size: 48),
                  const SizedBox(height: 16),
                  const Text('Não foi possível carregar os produtos.'),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _tentarDeNovo,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Tentar de novo'),
                  ),
                ],
              );
            }

            final produtos = snapshot.data ?? const <String>[];
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final p in produtos)
                  ListTile(
                    leading: const Icon(Icons.shopping_bag_outlined),
                    title: Text(p),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
