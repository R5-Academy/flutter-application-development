// exemplo_01_a_tabela_de_rotas_inicio.dart
// Uma loja com três telas. A navegação entre elas usa `MaterialPageRoute`, do
// jeito que a gente vem fazendo desde a aula de push — isso não é o assunto
// aqui e não vai mudar.
//
// ! O assunto é OUTRO: este app só sabe abrir de um jeito. O `home:` fixa a
// ! primeira tela, e não existe em lugar nenhum uma lista das telas que ele
// ! tem. Se o marketing mandar um link para a promoção, ou uma notificação
// ! pedir a tela do produto, não há por onde esse pedido entrar: as telas só
// ! existem dentro dos `builder` espalhados pelo código.
//
// O rodapé mostra o nome da rota atual. Rode e repare: a tela inicial se chama
// "/" — um nome que ninguém escreveu — e as outras duas não têm nome nenhum.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const AppDoExemplo());

class AppDoExemplo extends StatelessWidget {
  const AppDoExemplo({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    routes: {
      '/': (context) => HomeScreen(),
      '/produto': (context) => ProdutoScreen(),
      '/promocao': (context) => PromocaoScreen(),
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
          mainAxisAlignment: .center,
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
