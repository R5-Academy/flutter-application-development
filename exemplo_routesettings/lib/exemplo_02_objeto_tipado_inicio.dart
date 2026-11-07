// exemplo_02_objeto_tipado_inicio.dart
// Ponto de partida: agora a tela de detalhe precisa de **três** dados — id, nome
// e preço. Como `arguments` aceita qualquer coisa, a saída natural é mandar um
// `Map`.
//
// * Funciona: toque num produto e os três valores aparecem.
//
// ! Mas olhe a tela de destino. Cada leitura é uma chave em texto:
// !
// !     args['nome']    args['preço']    args['id']
// !
// ! E o que isso custa:
// !
// !   um erro de digitação (`args['nomee']`) **compila** e devolve `null`
// !   o autocomplete não sugere nada — as chaves não existem para o editor
// !   cada leitura vira um cast seu: `args['nome']! as String`,
// !     `args['preço']! as double`. Um por chave, e nenhum deles é conferido
// !     pelo compilador
// !   e renomear um campo obriga a caçar as aspas em todos os arquivos
//
// ! Repare no `toStringAsFixed` do preço: o `as double` **compila** mesmo que
// ! alguém mande `'349.90'` como texto — e aí quebra em execução.
//
// ! Fica pior quando o `Map` vem de fora, de um `jsonDecode`: ali ele é
// ! `Map<String, dynamic>`, e `args['preço'].toStringAsFixed(2)` compila
// ! **sem cast nenhum**. Some até o aviso do analisador.
//
// ? Como levar vários campos de uma vez **sem** abrir mão do compilador? Em vez
// ? de um saco de chaves, um tipo.

import 'package:material_ui/material_ui.dart';

void main() {
  runApp(
    MaterialApp(
      routes: {
        '/': (context) => const CatalogoScreen(),
        '/detalhe': (context) => const DetalheScreen(),
      },
    ),
  );
}

class CatalogoScreen extends StatelessWidget {
  const CatalogoScreen({super.key});

  // ! Os produtos como Maps: nada garante que todos tenham as mesmas chaves.
  static const _produtos = [
    {'id': 1, 'nome': 'Teclado mecânico', 'preco': 349.90},
    {'id': 2, 'nome': 'Mouse sem fio', 'preco': 129.90},
    {'id': 3, 'nome': 'Monitor 27 polegadas', 'preco': 1299.00},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Catálogo')),
      body: ListView.builder(
        itemCount: _produtos.length,
        itemBuilder: (_, index) {
          final produto = _produtos[index];
          return ListTile(
            title: Text(produto['nome']! as String),
            subtitle: Text(
              'R\$ ${(produto['preco']! as double).toStringAsFixed(2)}',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () =>
                Navigator.pushNamed(context, '/detalhe', arguments: produto),
          );
        },
      ),
    );
  }
}

class DetalheScreen extends StatelessWidget {
  const DetalheScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ! Um Map de chaves em texto. Cada acesso é uma aposta.
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, Object>;

    return Scaffold(
      appBar: AppBar(title: Text(args['nome']! as String)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Código do produto: ${args['id']}'),
            const SizedBox(height: 8),
            Text(
              'R\$ ${(args['preco']! as double).toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
    );
  }
}
