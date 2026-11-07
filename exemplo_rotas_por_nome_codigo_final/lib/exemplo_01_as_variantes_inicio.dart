// exemplo_01_as_variantes_inicio.dart
// Um app com login: entrar leva à home, e a home tem um botão de sair.
// A tabela está declarada, e o `pushNamed` da aula passada já está em uso.
//
// ! Só que as duas navegações desta tela não deveriam ser `pushNamed`:
// !
// !   entrar  -> o login não pode continuar na pilha (o usuário volta e vê a
// !              tela de login já autenticado)
// !   sair    -> TODAS as telas da área logada precisam sumir, não só a atual
// !
// ! Rode e comprove: entre, e a seta de voltar leva ao login. Vá ao perfil,
// ! saia — e a seta leva de volta para dentro da conta.
//
// ? Na aula de pushReplacement e na de pushAndRemoveUntil a gente resolveu
// ? exatamente esses dois casos. Aqueles métodos existem em versão nomeada?

import 'package:material_ui/material_ui.dart';

void main() => runApp(const AppDoExemplo());

class AppDoExemplo extends StatelessWidget {
  const AppDoExemplo({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    routes: {
      '/': (context) => const LoginScreen(),
      '/home': (context) => const HomeScreen(),
      '/perfil': (context) => const PerfilScreen(),
    },
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
          onPressed: () => Navigator.of(context).pushReplacementNamed('/home'),
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: FilledButton(
          onPressed: () => Navigator.of(context).pushNamed('/perfil'),
          child: const Text('Abrir perfil'),
        ),
      ),
      bottomNavigationBar: const _Rodape(),
    );
  }
}

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: Center(
        child: OutlinedButton(
          onPressed: () =>
              Navigator.of(context).pushNamedAndRemoveUntil('/', (_) => false),
          child: const Text('Sair'),
        ),
      ),
      bottomNavigationBar: const _Rodape(),
    );
  }
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
