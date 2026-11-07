// exemplo_03_a_rota_raiz_inicio.dart
// Outro app: um que começa pelo login. A tabela registra uma tela de abertura
// na chave '/' e manda o app começar no '/login'.
//
// ! Rode e olhe a AppBar do login: tem uma seta de voltar ali. Voltar para
// ! ONDE? O usuário acabou de abrir o app — e a seta leva para a tela de
// ! abertura, que ele nunca viu e não deveria poder ver.
//
// ! O rodapé confirma: canPop: true numa tela que deveria ser a primeira.
//
// ? Nenhum botão foi tocado; nada foi navegado. O app já ABRIU com duas telas
// ? empilhadas. Qual chave desta tabela é diferente das outras?

import 'package:material_ui/material_ui.dart';

void main() => runApp(const AppDoExemplo());

class AppDoExemplo extends StatelessWidget {
  const AppDoExemplo({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    initialRoute: '/login',
    routes: {
      '/': (context) => const AberturaScreen(),
      '/login': (context) => const LoginScreen(),
      '/home': (context) => const HomeScreen(),
    },
  );
}

class AberturaScreen extends StatelessWidget {
  const AberturaScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Abertura')),
    body: const Center(child: Text('Logo do app')),
    bottomNavigationBar: const _Rodape(),
  );
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: FilledButton(
          onPressed: () => Navigator.of(context).pushNamed('/home'),
          child: const Text('Entrar'),
        ),
      ),
      bottomNavigationBar: const _Rodape(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Home')),
    body: const Center(child: Text('Área logada')),
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
