// exemplo_04_busca_sem_resultado_inicio.dart
// Ponto de partida: a busca funciona e o vazio já tem uma mensagem — a mesma
// mensagem genérica do bloco anterior.
//
// Digite "xyz" no campo e leia: "Nada por aqui".
//
// ? Este é o TERCEIRO motivo de uma lista estar vazia, e ele não se parece com
// ? os outros dois. Não é "nunca teve nada" nem "você esvaziou": é "o que você
// ? procurou não existe aqui".
// ?
// ?   **e a saída também é outra — qual botão faz sentido agora?**
// ?
// ? Criar um item novo não ajuda ninguém. E a mensagem pode dizer algo que as
// ? anteriores não podiam: o que exatamente foi procurado — o `_termo` já está
// ? guardado no State, e por enquanto ninguém o lê.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaBuscaFrutas()));

const _todasAsFrutas = ['Abacaxi', 'Banana', 'Caju', 'Laranja', 'Manga', 'Uva'];

// Simula um serviço de busca que emite os resultados filtrados como um Stream.
// Cada termo digitado gera uma nova consulta; o resultado pode vir vazio.
Stream<List<String>> buscarFrutas(String termo) async* {
  await Future.delayed(const Duration(milliseconds: 400));
  if (termo.isEmpty) {
    yield _todasAsFrutas;
    return;
  }
  final t = termo.toLowerCase();
  yield _todasAsFrutas.where((f) => f.toLowerCase().contains(t)).toList();
}

class TelaBuscaFrutas extends StatefulWidget {
  const TelaBuscaFrutas({super.key});

  @override
  State<TelaBuscaFrutas> createState() => _TelaBuscaFrutasState();
}

class _TelaBuscaFrutasState extends State<TelaBuscaFrutas> {
  final _controlador = TextEditingController();
  var _termo = '';

  // O Stream mora num campo e só troca quando o termo muda -- cria-lo dentro
  // do build refaria a consulta a cada rebuild.
  late var _resultados = buscarFrutas('');

  void _buscar(String valor) {
    setState(() {
      _termo = valor;
      _resultados = buscarFrutas(valor);
    });
  }

  void _limparBusca() {
    _controlador.clear();
    _buscar('');
  }

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buscar frutas')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _controlador,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Digite o nome de uma fruta',
                border: OutlineInputBorder(),
              ),
              onChanged: _buscar,
            ),
          ),
          Expanded(
            child: StreamBuilder<List<String>>(
              stream: _resultados,
              builder: (context, snapshot) {
                // ! O "&& !hasData" e o que impede a lista pronta de sumir a
                // ! cada tecla: na troca de stream o builder recebe waiting
                // ! COM o data anterior dentro do snapshot. Um if (waiting)
                // ! sozinho apagaria os resultados e piscaria um spinner a
                // ! cada letra digitada.
                final carregando =
                    snapshot.connectionState == ConnectionState.waiting;
                if (carregando && !snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final frutas = snapshot.data ?? const <String>[];

                // * Vazio contextual: a mensagem depende de POR QUE esta vazio.
                // ! Se o usuário digitou algo e não veio nada, dizer só "lista
                // ! vazia" confunde -- ele precisa saber que foi a BUSCA dele
                // ! que não achou nada, e não que o app esta sem dados.
                if (frutas.isEmpty) {
                  // O termo digitado está bem aqui, guardado — e a mensagem
                  // abaixo ignora ele completamente.
                  debugPrint('busca sem resultado para: "$_termo"');
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search_off, size: 72, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          'Nenhum resultado para "$_termo"',
                          textAlign: .center,
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 24),
                        TextButton.icon(
                          onPressed: _limparBusca,
                          icon: Icon(Icons.close),
                          label: const Text('Limpar Buscar'),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: frutas.length,
                  itemBuilder: (context, i) => ListTile(
                    leading: const Icon(Icons.eco_outlined),
                    title: Text(frutas[i]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
