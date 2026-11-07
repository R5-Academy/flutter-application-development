// exemplo_04_o_caminho_da_abertura_inicio.dart
// Um link externo pediu a tela de configurações do perfil, e o app abre nela:
// `initialRoute: '/perfil/config'`.
//
// Rode. A tela certa aparece, e existe uma seta de voltar — o que já é bom
// sinal: quem chega de um link precisa poder entrar no app.
//
// ! Mas volte. Você cai direto na Home, pulando o perfil. O usuário estava
// ! DENTRO do perfil, nas configurações dele, e "voltar" não leva ao perfil.
//
// O rodapé mostra a rota atual e o canPop; conte as rotas apertando voltar
// até a seta sumir.
//
// ? O `initialRoute` recebeu um caminho com duas barras. O Flutter montou
// ? alguma coisa a partir dele — mas não tudo. O que faltou?

import 'package:material_ui/material_ui.dart';

void main() => runApp(const AppDoExemplo());

class AppDoExemplo extends StatelessWidget {
  const AppDoExemplo({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    initialRoute: '/perfil/config',
    routes: {
      '/': (context) => const HomeScreen(),
      '/perfil/config': (context) => const ConfigScreen(),
    },
  );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Home')),
    body: const Center(child: Text('Tela inicial')),
    bottomNavigationBar: const _Rodape(),
  );
}

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Perfil')),
    body: const Center(child: Text('Seus dados')),
    bottomNavigationBar: const _Rodape(),
  );
}

class ConfigScreen extends StatelessWidget {
  const ConfigScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Configurações do perfil')),
    body: const Center(child: Text('Notificações, privacidade, tema')),
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
