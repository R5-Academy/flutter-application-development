// exemplo_03_guard_inicio.dart
// Um app com duas telas privadas — `/perfil` e `/pedidos` — e uma tela de
// login. O interruptor no topo da home simula a sessão: ligue e desligue à
// vontade, ele é bancada.
//
// ! Deixe a sessão DESLIGADA e toque em "Meu perfil". O perfil abre.
//
// ! Ninguém checou nada. Cada tela privada teria que se defender sozinha, no
// ! próprio `build` — e basta esquecer uma para o app vazar. Pior: a rota
// ! também chega **de fora** (link de e-mail, notificação), e aí não há toque
// ! nenhum para interceptar.
//
// ? Existe um lugar por onde **toda** navegação passa antes de virar tela.
// ? Se a checagem morar lá, ela vale para o app inteiro.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const AppComRotasPrivadas());

class AppComRotasPrivadas extends StatelessWidget {
  const AppComRotasPrivadas({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rotas protegidas',
      initialRoute: '/',
      routes: {'/perfil': (context) => const PerfilScreen()},
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute<void>(
              settings: settings,
              builder: (context) => const HomeScreen(),
            );

          case '/login':
            return MaterialPageRoute<void>(
              settings: settings,
              builder: (context) => const LoginScreen(),
            );

          case '/pedidos':
            return MaterialPageRoute<void>(
              settings: settings,
              builder: (context) => const PedidosScreen(),
            );

          default:
            return MaterialPageRoute<void>(
              builder: (context) => TelaRotaDesconhecida(nome: settings.name),
            );
        }
      },
    );
  }
}

// A sessão do app, reduzida ao osso: um booleano global. Num app de verdade
// aqui estaria o token guardado; o que a aula precisa é só do "tem ou não tem".
class SessaoFalsa {
  static bool logado = false;
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Loja')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Sessão'),
            subtitle: Text(SessaoFalsa.logado ? 'logado' : 'visitante'),
            value: SessaoFalsa.logado,
            onChanged: (novo) => setState(() => SessaoFalsa.logado = novo),
          ),
          const Divider(),
          ListTile(
            title: const Text('Meu perfil'),
            subtitle: const Text('/perfil'),
            onTap: () => Navigator.pushNamed(context, '/perfil'),
          ),
          ListTile(
            title: const Text('Meus pedidos'),
            subtitle: const Text('/pedidos'),
            onTap: () => Navigator.pushNamed(context, '/pedidos'),
          ),
        ],
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Entrar')),
      body: const Center(child: Text('Formulário de login')),
    );
  }
}

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meu perfil')),
      body: const Center(child: Text('Dados da conta')),
    );
  }
}

class PedidosScreen extends StatelessWidget {
  const PedidosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meus pedidos')),
      body: const Center(child: Text('Histórico de compras')),
    );
  }
}

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
