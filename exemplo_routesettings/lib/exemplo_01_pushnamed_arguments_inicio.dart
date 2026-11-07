// exemplo_01_pushnamed_arguments_inicio.dart
// Ponto de partida: um app com rotas nomeadas — a organização que a aula de
// `pushReplacement` apresentou. A tabela `routes` registra os nomes, e a
// navegação cita `'/detalhe'`.
//
// ! Mas a tela de detalhe mostra um texto fixo. Ela precisa saber **qual
// ! produto** exibir, e não tem como descobrir.
//
// ! E repare por quê — é uma consequência direta das rotas nomeadas:
// !
// !     '/detalhe': (context) => const DetalheScreen(),
// !
// ! Quem constrói a tela é **a tabela**, não quem navegou. O truque que a aula
// ! de push ensinou (passar pelo construtor, dentro do `builder`) **não existe
// ! aqui**: o `builder` do `routes` não recebe nada de quem chamou.
//
// ? Então rotas nomeadas não servem para telas que precisam de dados? Servem —
// ? mas por outro canal. O `Navigator.pushNamed` tem um parâmetro para isso, e
// ? do outro lado existe um objeto que carrega **o nome e os dados** da rota.

import 'package:material_ui/material_ui.dart';

void main() {
  runApp(
    MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const ListaScreen(),
        // ! A tabela constrói a tela sem receber nada de quem navegou.
        '/detalhe': (context) => const DetalheScreen(),
      },
    ),
  );
}

class ListaScreen extends StatelessWidget {
  const ListaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Produtos')),
      body: Center(
        child: ElevatedButton(
          // ! O nome do produto está aqui e não tem como chegar ao destino.
          onPressed: () => Navigator.pushNamed(context, '/detalhe'),
          child: const Text('Ver Teclado mecânico'),
        ),
      ),
    );
  }
}

class DetalheScreen extends StatelessWidget {
  const DetalheScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhe')),
      body: Center(
        child: Text(
          'Qual produto?',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}
