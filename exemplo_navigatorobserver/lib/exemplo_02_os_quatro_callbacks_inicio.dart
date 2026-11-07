// exemplo_02_os_quatro_callbacks_inicio.dart
// O mesmo espião do bloco anterior — `didPush` e `didPop` —, agora num app de
// verdade: login que entra, perfil, e um botão de sair.
//
// ! Faça o fluxo inteiro: Entrar, Abrir perfil, Sair. Depois conte o que o
// ! painel registrou contra o que você realmente fez.
// !
// ! Entrar e Sair somem do histórico. Um analytics montado assim reportaria
// ! que o usuário abriu o app, viu o perfil, e nunca mais saiu.
//
// ? As duas navegações que sumiram usam `pushReplacementNamed` e
// ? `pushNamedAndRemoveUntil`. As duas mexem na pilha — e nenhuma das duas
// ? chamou `didPush` nem `didPop`. Então elas chamaram o quê?

import 'package:material_ui/material_ui.dart';

void main() => runApp(const AppDoExemplo());

class AppDoExemplo extends StatelessWidget {
  const AppDoExemplo({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    navigatorObservers: [Espiao()],
    routes: {
      '/': (context) => const LoginScreen(),
      '/home': (context) => const HomeScreen(),
      '/perfil': (context) => const PerfilScreen(),
    },
  );
}

class Espiao extends NavigatorObserver {
  String nomeDe(Route<dynamic>? rota) => rota?.settings.name ?? '(sem nome)';

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    historico.registrar('didPush ${nomeDe(route)}  <- ${nomeDe(previousRoute)}');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    historico.registrar('didPop ${nomeDe(route)}  -> ${nomeDe(previousRoute)}');
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) => _Tela(
    titulo: 'Login',
    corpo: Builder(
      builder: (c) => FilledButton(
        onPressed: () => Navigator.of(c).pushReplacementNamed('/home'),
        child: const Text('Entrar'),
      ),
    ),
  );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => _Tela(
    titulo: 'Home',
    corpo: Builder(
      builder: (c) => FilledButton(
        onPressed: () => Navigator.of(c).pushNamed('/perfil'),
        child: const Text('Abrir perfil'),
      ),
    ),
  );
}

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) => _Tela(
    titulo: 'Perfil',
    corpo: Builder(
      builder: (c) => OutlinedButton(
        onPressed: () =>
            Navigator.of(c).pushNamedAndRemoveUntil('/', (rota) => false),
        child: const Text('Sair'),
      ),
    ),
  );
}

// * Bancada: moldura com o painel de histórico à direita.
class const _Tela({required final String titulo, required final Widget corpo})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(titulo)),
    body: Row(
      children: [
        Expanded(child: Center(child: corpo)),
        const VerticalDivider(width: 1),
        const SizedBox(width: 320, child: _PainelHistorico()),
      ],
    ),
  );
}

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
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      Text('Histórico (${historico.linhas.length})'),
      const SizedBox(height: 8),
      for (final linha in historico.linhas) Text(linha),
    ],
  );
}

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
