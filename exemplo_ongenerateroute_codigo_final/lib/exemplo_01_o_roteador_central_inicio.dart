// exemplo_01_o_roteador_central_inicio.dart
// Ponto de partida: o app da aula de `RouteSettings`, com **duas** telas que
// recebem argumentos — detalhe e edição.
//
// ! Olhe o começo do `build` das duas:
// !
// !     final produto = ModalRoute.of(context)!.settings.arguments as ProdutoArgs;
// !
// ! A mesma linha, duas vezes. E com o app crescendo, em toda tela que receber
// ! dados.
//
// ! O problema não é a repetição — é o que ela **acopla**. Cada uma dessas
// ! telas agora:
// !
// !   conhece `ModalRoute`, `settings` e `arguments`
// !   **só funciona quando alguém pôs o argumento na rota**. Medido nesta
// !     máquina: `MaterialApp(home: DetalheScreen())` num teste de widget
// !     estoura com
// !     `type 'Null' is not a subtype of type 'ProdutoArgs' in type cast` —
// !     o `home` cria uma rota, então o `!` passa; quem cai é o cast, porque
// !     `arguments` está vazio (a distinção entre os dois é a aula 10)
// !   e reusar a tela em outro lugar (dentro de um `Dialog`, numa `Row` de
// !     tablet) fica impossível sem gambiarra
//
// ! Compare com a tela de detalhe da aula de **push**: lá ela recebia o produto
// ! por construtor e não sabia que existia navegação. Aqui ela regrediu.
//
// ? O `arguments` precisa ser lido em algum lugar — mas não precisa ser
// ? **dentro da tela**. Existe um ponto no `MaterialApp` que recebe o
// ? `RouteSettings` de cada navegação e decide o que construir.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const AppCatalogo());

class AppCatalogo extends StatelessWidget {
  const AppCatalogo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/editar': (context) {
          final ProdutoArgs(:nome) =
              ModalRoute.of(context)!.settings.arguments as ProdutoArgs;
          return EditarScreen(nome: nome);
        },
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              settings: settings,
              builder: (context) {
                return CatalogoScreen();
              },
            );
          case '/detalhe':
            final ProdutoArgs(:id, :nome) = settings.arguments as ProdutoArgs;
            return MaterialPageRoute(
              settings: settings,
              builder: (context) => DetalheScreen(id: id, nome: nome),
            );
          // case '/editar':
          //   final ProdutoArgs(:nome) = settings.arguments as ProdutoArgs;
          //   return MaterialPageRoute(
          //     settings: settings,
          //     builder: (context) => EditarScreen(nome: nome),
          //   );
        }
        return null;
      },
    );
  }
}

class const ProdutoArgs({required final int id, required final String nome});

class CatalogoScreen extends StatelessWidget {
  const CatalogoScreen({super.key});

  static const _produtos = [
    ProdutoArgs(id: 1, nome: 'Teclado mecânico'),
    ProdutoArgs(id: 2, nome: 'Mouse sem fio'),
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
            title: Text(produto.nome),
            onTap: () =>
                Navigator.pushNamed(context, '/detalhe', arguments: produto),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () =>
                  Navigator.pushNamed(context, '/editar', arguments: produto),
            ),
          );
        },
      ),
    );
  }
}

class const DetalheScreen({
  super.key,
  required final int id,
  required final String nome,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(nome)),
      body: Center(child: Text('Código: $id')),
    );
  }
}

class const EditarScreen({super.key, required final String nome})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Editar $nome')),
      body: const Center(child: Text('Formulário de edição')),
    );
  }
}

// A tela de rota desconhecida. Bancada: ela existe desde o início, e o que a
// aula acrescenta é o `default` do switch que a escolhe.
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
