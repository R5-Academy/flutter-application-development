// exemplo_02_nome_errado_e_a_rede_inicio.dart
// A home tem três atalhos. O nome da rota de cada um vem de uma lista de
// String — que é como um pedido chega de fora do app: de um deep link, de uma
// notificação, de um atalho da tela inicial do celular.
//
// ! Um dos três está escrito errado, e o compilador não tem como saber: para
// ! ele, '/perfl' é uma String tão válida quanto '/perfil'. Rode
// ! `flutter analyze` na frente da turma — passa limpo.
//
// ! Toque nos três. Os dois primeiros abrem. O terceiro derruba o app com
// ! tela vermelha. Leia a mensagem inteira: ela ensina a ordem em que o
// ! Flutter procura uma rota.
//
// ? Na aula passada, quando o `initialRoute` não existia, o app caía na raiz
// ? sem quebrar. Aqui ele quebra. Por que a navegação não tem a mesma rede
// ? que a abertura tinha?

import 'package:material_ui/material_ui.dart';

void main() => runApp(const AppDoExemplo());

class AppDoExemplo extends StatelessWidget {
  const AppDoExemplo({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    routes: {
      '/': (context) => const HomeScreen(),
      '/perfil': (context) => const PerfilScreen(),
      '/ajuda': (context) => const AjudaScreen(),
    },
  );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Os atalhos que o app oferece: rótulo na tela, nome da rota por baixo.
  static const atalhos = <(String, String)>[
    ('Meu perfil', '/perfil'),
    ('Central de ajuda', '/ajuda'),
    ('Perfil (atalho antigo)', '/perfl'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: ListView.builder(
        itemCount: atalhos.length,
        itemBuilder: (_, index) {
          final (rotulo, rota) = atalhos[index];
          return ListTile(
            title: Text(rotulo),
            subtitle: Text(rota),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).pushNamed(rota),
          );
        },
      ),
    );
  }
}

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Perfil')),
    body: const Center(child: Text('Dados da conta')),
  );
}

class AjudaScreen extends StatelessWidget {
  const AjudaScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Ajuda')),
    body: const Center(child: Text('Perguntas frequentes')),
  );
}
