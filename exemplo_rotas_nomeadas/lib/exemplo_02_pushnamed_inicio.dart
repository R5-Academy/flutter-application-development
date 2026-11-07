// exemplo_02_pushnamed_inicio.dart
// A mesma loja do bloco 1, com a tabela que a gente acabou de declarar — as
// três telas estão registradas. Só o `initialRoute` saiu, para o app voltar a
// abrir pela raiz e a Loja ficar na tela com os dois botões à vista.
//
// ! Mas os botões continuam construindo as telas na mão:
// !
// !     MaterialPageRoute<void>(builder: (novoContext) => const ProdutoScreen())
// !
// ! Ou seja: a tabela existe e ninguém usa. Cada tela continua importando as
// ! telas para onde navega, e o rodapé denuncia — as telas abertas por botão
// ! dizem "sem nome", mesmo estando registradas com nome logo ali em cima.
//
// ? A tabela sabe transformar '/produto' na ProdutoScreen. Como é que eu peço
// ? isso a ela?

import 'package:material_ui/material_ui.dart';

void main() => runApp(const AppDoExemplo());

class AppDoExemplo extends StatelessWidget {
  const AppDoExemplo({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    routes: {
      '/': (context) => const HomeScreen(),
      '/produto': (context) => const ProdutoScreen(),
      '/promocao': (context) => const PromocaoScreen(),
    },
  );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Loja')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 12,
          children: [
            FilledButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (novoContext) => const ProdutoScreen(),
                ),
              ),
              child: const Text('Ver produto'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (novoContext) => const PromocaoScreen(),
                ),
              ),
              child: const Text('Ver promoção'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const _Rodape(),
    );
  }
}

class ProdutoScreen extends StatelessWidget {
  const ProdutoScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Produto')),
    body: const Center(child: Text('Tênis de corrida')),
    bottomNavigationBar: const _Rodape(),
  );
}

class PromocaoScreen extends StatelessWidget {
  const PromocaoScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Promoção')),
    body: const Center(child: Text('30% off só hoje')),
    bottomNavigationBar: const _Rodape(),
  );
}

// * Instrumentação da aula: o nome da rota atual e se dá para voltar.
class _Rodape extends StatelessWidget {
  const _Rodape();

  @override
  Widget build(BuildContext context) {
    final nome = ModalRoute.of(context)?.settings.name ?? 'sem nome';
    final podeVoltar = Navigator.of(context).canPop();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        'rota: $nome   ·   canPop: $podeVoltar',
        textAlign: TextAlign.center,
      ),
    );
  }
}
