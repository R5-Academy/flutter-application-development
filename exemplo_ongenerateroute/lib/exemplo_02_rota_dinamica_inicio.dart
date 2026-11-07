// exemplo_02_rota_dinamica_inicio.dart
// Um catálogo que navega para `/produto/42`, `/produto/7` e
// `/busca?q=teclado mecânico`. As três telas de destino já existem aqui
// embaixo, prontas, recebendo dados pelo construtor.
//
// ! Rode e toque em qualquer item: o app abre a tela de "rota não encontrada".
//
// ! O motivo está no `switch`: ele compara o nome **inteiro**. `'/produto/42'`
// ! não é igual a nenhum `case`, e o nome muda a cada produto — declarar um
// ! `case` por id é impossível. A tabela `routes` da aula 07 esbarra na mesma
// ! parede, pelo mesmo motivo: ela é um `Map`, e um `Map` tem chaves fixas.
//
// ? O nome de uma rota tem cara de caminho de URL. E o Dart já sabe ler URL.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const AppLoja());

class AppLoja extends StatelessWidget {
  const AppLoja({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rota dinâmica',
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute<void>(
              settings: settings,
              builder: (context) => const CatalogoScreen(),
            );

          default:
            return MaterialPageRoute<void>(
              builder: (context) => TelaRotaDesconhecida(nome: settings.name),
            );
        }
      },
    );
  }
}

class const Produto(final int id, final String nome);

class CatalogoScreen extends StatelessWidget {
  const CatalogoScreen({super.key});

  static const _produtos = [
    Produto(42, 'Teclado mecânico'),
    Produto(7, 'Mouse sem fio'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Catálogo')),
      body: ListView(
        children: [
          for (final produto in _produtos)
            ListTile(
              title: Text(produto.nome),
              subtitle: Text('/produto/${produto.id}'),
              onTap: () =>
                  Navigator.pushNamed(context, '/produto/${produto.id}'),
            ),
          const Divider(),
          ListTile(
            title: const Text('Buscar "teclado mecanico"'),
            subtitle: const Text('/busca?q=teclado%20mecanico'),
            onTap: () =>
                Navigator.pushNamed(context, '/busca?q=teclado%20mecanico'),
          ),
        ],
      ),
    );
  }
}

// As telas de destino: elas recebem dados prontos pelo construtor e não sabem
// que existe rota. O que falta é alguém construí-las.
class const ProdutoScreen({super.key, required final int id})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Produto #$id')),
      body: Center(child: Text('Detalhe do produto $id')),
    );
  }
}

class const BuscaScreen({super.key, required final String termo})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Busca')),
      body: Center(child: Text('Resultados para: $termo')),
    );
  }
}

class const TelaRotaDesconhecida({super.key, required final String? nome})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ops')),
      body: Center(child: Text('Rota não encontrada: $nome')),
    );
  }
}
