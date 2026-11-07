// exemplo_05_transicoes_plataforma_inicio.dart
// Ponto de partida: o app precisa que as telas entrem deslizando da lateral, no
// estilo iOS, **em todas as plataformas**. Decisão de design.
//
// * O lugar natural para procurar é o `MaterialPageRoute` — afinal, é ele que
// * abre a tela. Abra o autocomplete no construtor e procure algo como
// * `transition`, `animation`, `curve`.
//
// ! Não tem. Os parâmetros são `builder`, `settings`, `fullscreenDialog`,
// ! `maintainState`, `allowSnapshotting` — e nenhum deles fala de animação.
//
// ! E, no entanto, a transição **existe**: rode e veja a tela entrar. Alguém
// ! está animando. Só não é a rota.
//
// ? Onde mais poderia estar? A pista é o comportamento padrão: a mesma
// ? `MaterialPageRoute` anima **diferente** no Android e no iOS, sem você
// ? configurar nada. Ou seja, quem decide a animação **sabe em que plataforma
// ? está** — e a rota não sabe.
// ?
// ? Que objeto do Flutter sabe a plataforma e vale para o app inteiro?

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MeuApp());

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // ! Nada configurado sobre transições: cada plataforma usa o seu padrão.
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {.iOS: ZoomPageTransitionsBuilder()},
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transições')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              // ! Procure aqui um parâmetro de animação. Não existe.
              MaterialPageRoute<void>(
                builder: (novoContext) => const SegundaScreen(),
              ),
            );
          },
          child: const Text('Abrir segunda tela'),
        ),
      ),
    );
  }
}

class SegundaScreen extends StatelessWidget {
  const SegundaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Segunda')),
      body: Center(
        child: Builder(
          builder: (context) {
            // * A causa na tela: qual builder de transição o tema entrega para
            // * a plataforma atual. Sem pageTransitionsTheme, o mapa vem vazio
            // * e quem decide é o padrão do Material.
            final tema = Theme.of(context);
            final emUso = tema.pageTransitionsTheme.builders[tema.platform];

            return Text(
              'Transição em uso:\n${emUso?.runtimeType ?? 'padrão da plataforma'}',
              textAlign: TextAlign.center,
            );
          },
        ),
      ),
    );
  }
}
