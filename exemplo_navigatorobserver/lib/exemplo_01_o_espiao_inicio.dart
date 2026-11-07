// exemplo_01_o_espiao_inicio.dart
// A loja das aulas anteriores, navegando por nome. Do lado direito de cada
// tela há um painel que deveria mostrar o histórico de navegação do app.
//
// ! Rode e navegue à vontade: o painel continua dizendo "ainda não há fonte".
// ! Ninguém no app tem como saber que uma navegação aconteceu — cada tela sabe
// ! da própria vida, e a pilha inteira é invisível.
//
// ? O `Navigator` sabe de tudo: é ele quem empilha e desempilha. Será que dá
// ? para escutar o que ele faz?

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
  Widget build(BuildContext context) => _Tela(
    titulo: 'Loja',
    corpo: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 12,
      children: [
        Builder(
          builder: (c) => FilledButton(
            onPressed: () => Navigator.of(c).pushNamed('/produto'),
            child: const Text('Ver produto'),
          ),
        ),
        Builder(
          builder: (c) => FilledButton(
            onPressed: () => Navigator.of(c).pushNamed('/promocao'),
            child: const Text('Ver promoção'),
          ),
        ),
      ],
    ),
  );
}

class ProdutoScreen extends StatelessWidget {
  const ProdutoScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      const _Tela(titulo: 'Produto', corpo: Text('Tênis de corrida'));
}

class PromocaoScreen extends StatelessWidget {
  const PromocaoScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      const _Tela(titulo: 'Promoção', corpo: Text('30% off só hoje'));
}

// * Bancada: a moldura de todas as telas — conteúdo à esquerda, painel de
// * histórico à direita.
class const _Tela({required final String titulo, required final Widget corpo})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(titulo)),
    body: Row(
      children: [
        Expanded(child: Center(child: corpo)),
        const VerticalDivider(width: 1),
        const SizedBox(width: 280, child: _PainelHistorico()),
      ],
    ),
  );
}

// * Bancada: o painel se inscreve no histórico e se redesenha quando ele muda.
// * A inscrição manual (initState/dispose) é a mesma mecânica do ciclo de vida
// * que você já conhece. O curso tem uma versão pronta disso — `ChangeNotifier`
// * e `ListenableBuilder`, na seção Gerenciamento de Estado Nativo desta fase.
class _PainelHistorico extends StatefulWidget {
  const _PainelHistorico();

  @override
  State<_PainelHistorico> createState() => _PainelHistoricoState();
}

class _PainelHistoricoState extends State<_PainelHistorico> {
  @override
  void initState() {
    super.initState();
    historico.ouvintes.add(_aoMudar);
  }

  @override
  void dispose() {
    historico.ouvintes.remove(_aoMudar);
    super.dispose();
  }

  void _aoMudar() => setState(() {});

  @override
  Widget build(BuildContext context) {
    if (historico.linhas.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text('Histórico\n\nainda não há fonte'),
      );
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Histórico'),
        const SizedBox(height: 8),
        for (final linha in historico.linhas) Text(linha),
      ],
    );
  }
}

// * Bancada: onde o histórico mora. Por enquanto ninguém escreve nele.
final historico = Historico();

class Historico {
  final linhas = <String>[];
  final ouvintes = <VoidCallback>[];

  void registrar(String linha) {
    linhas.add(linha);
    for (final ouvinte in List<VoidCallback>.of(ouvintes)) {
      ouvinte();
    }
  }
}
