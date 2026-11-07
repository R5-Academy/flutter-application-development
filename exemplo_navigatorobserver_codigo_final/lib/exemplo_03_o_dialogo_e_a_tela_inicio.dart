// exemplo_03_o_dialogo_e_a_tela_inicio.dart
// Agora o espião serve a um propósito de verdade: o painel mostra "telas
// visitadas", que é o que um analytics de produto reporta.
//
// ! Abra o app, vá ao produto e toque em "Comprar" — que abre um diálogo de
// ! confirmação. Olhe o painel: o diálogo entrou na lista de TELAS VISITADAS,
// ! com o nome "(sem nome)".
//
// ! Feche o diálogo e abra de novo três vezes. O relatório agora diz que o
// ! usuário visitou quatro telas anônimas. Num painel de produto de verdade
// ! isso vira uma tela fantasma com mais acessos que a home.
//
// ? `showDialog` não parece navegação — não muda de tela, não tem seta de
// ? voltar. Por que ele apareceu aqui?

import 'package:material_ui/material_ui.dart';

void main() => runApp(const AppDoExemplo());

class AppDoExemplo extends StatelessWidget {
  const AppDoExemplo({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    navigatorObservers: [EspiaoDeTelas()],
    routes: {
      '/': (context) => const HomeScreen(),
      '/produto': (context) => const ProdutoScreen(),
    },
  );
}

class EspiaoDeTelas extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route is! PageRoute) {
      debugPrint(route.toString());
      return;
    }
    final name = route.settings.name;
    if (name == null) return;

    telasVisitadas.registrar(name);
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => _Tela(
    titulo: 'Loja',
    corpo: Builder(
      builder: (c) => FilledButton(
        onPressed: () => Navigator.of(c).pushNamed('/produto'),
        child: const Text('Ver produto'),
      ),
    ),
  );
}

class ProdutoScreen extends StatelessWidget {
  const ProdutoScreen({super.key});

  @override
  Widget build(BuildContext context) => _Tela(
    titulo: 'Produto',
    corpo: Builder(
      builder: (c) => FilledButton(
        onPressed: () => showDialog<void>(
          context: c,
          builder: (dialogoContext) => AlertDialog(
            title: const Text('Confirmar compra?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogoContext).pop(),
                child: const Text('Cancelar'),
              ),
            ],
          ),
        ),
        child: const Text('Comprar'),
      ),
    ),
  );
}

// * Bancada: moldura com o painel de telas visitadas à direita.
class const _Tela({required final String titulo, required final Widget corpo})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(titulo)),
    body: Row(
      children: [
        Expanded(child: Center(child: corpo)),
        const VerticalDivider(width: 1),
        const SizedBox(width: 200, child: _PainelTelas()),
      ],
    ),
  );
}

class _PainelTelas extends StatefulWidget {
  const _PainelTelas();

  @override
  State<_PainelTelas> createState() => _PainelTelasState();
}

class _PainelTelasState extends State<_PainelTelas> {
  @override
  void initState() {
    super.initState();
    telasVisitadas.ouvintes.add(_aoMudar);
  }

  @override
  void dispose() {
    telasVisitadas.ouvintes.remove(_aoMudar);
    super.dispose();
  }

  void _aoMudar() => setState(() {});

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      Text('Telas visitadas (${telasVisitadas.linhas.length})'),
      const SizedBox(height: 8),
      for (final linha in telasVisitadas.linhas) Text(linha),
    ],
  );
}

final telasVisitadas = Historico();

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
