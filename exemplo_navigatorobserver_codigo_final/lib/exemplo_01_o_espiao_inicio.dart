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
    navigatorObservers: [Espiao()],
    routes: {
      '/': (context) => const HomeScreen(),
      '/produto': (context) => const ProdutoScreen(),
      '/promocao': (context) => const PromocaoScreen(),
    },
  );
}

class Espiao extends NavigatorObserver {
  String extractRouteName(Route<dynamic>? route) =>
      route?.settings.name ?? 'Sem nome';

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    historico.registrar(
      'didPush: ${extractRouteName(previousRoute)} -> ${extractRouteName(route)} ',
    );
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    historico.registrar(
      'didPop: ${extractRouteName(route)} -> ${extractRouteName(previousRoute)} ',
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => _Tela(
    titulo: 'Loja',
    corpo: Column(
      spacing: 12,
      children: [
        SizedBox(
          width: 120,
          child: FilledButton(
            onPressed: () => Navigator.of(context).pushNamed('/produto'),
            child: const Text('Ver produto', style: TextStyle(fontSize: 10)),
          ),
        ),
        SizedBox(
          width: 120,

          child: FilledButton(
            onPressed: () => Navigator.of(context).pushNamed('/promocao'),
            child: const Text('Ver promoção', style: TextStyle(fontSize: 10)),
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
    body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: .start,
        children: [
          Padding(padding: const EdgeInsets.all(8.0), child: corpo),
          const VerticalDivider(width: 1),
          Expanded(child: _PainelHistorico()),
        ],
      ),
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
        for (final linha in historico.linhas) Text(linha, style: TextStyle()),
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
