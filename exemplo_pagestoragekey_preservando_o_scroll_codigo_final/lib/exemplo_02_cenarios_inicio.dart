// exemplo_02_cenarios_inicio.dart
// A mesma tela de abas, mas montada com IndexedStack em vez de trocar o body.
//
// O IndexedStack mantém TODAS as abas na árvore e só mostra uma por vez.
//
// A lista aqui NÃO tem PageStorageKey. Role, troque de aba, volte.
//
// ! O scroll voltou onde estava. Sem chave nenhuma.
//
// Por quê?

import 'package:material_ui/material_ui.dart';

import 'dados.dart';

void main() => runApp(const AppDosCenarios());

class AppDosCenarios extends StatelessWidget {
  const AppDosCenarios({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quando a chave importa',
      theme: ThemeData(colorSchemeSeed: Colors.deepPurple),
      home: const TelaComIndexedStack(),
    );
  }
}

class TelaComIndexedStack extends StatefulWidget {
  const TelaComIndexedStack({super.key});

  @override
  State<TelaComIndexedStack> createState() => _TelaComIndexedStackState();
}

class _TelaComIndexedStackState extends State<TelaComIndexedStack> {
  int _aba = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('IndexedStack x troca de body')),
      body: Column(
        children: [
          // EM CIMA: IndexedStack. Ele mantém as duas abas montadas o tempo todo.
          Expanded(
            child: Column(
              children: [
                const _Rotulo('IndexedStack: as duas abas ficam montadas'),
                Expanded(
                  child: IndexedStack(
                    index: _aba,
                    children: const [AbaLista(), AbaPerfil()],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 2, thickness: 2),
          // EMBAIXO: reservado para o cenário oposto, que entra na aula.
          Expanded(
            child: Column(
              children: [
                const _Rotulo('a comparação entra aqui'),
                Expanded(child: _aba == 0 ? AbaLista() : AbaPerfil()),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _aba,
        onDestinationSelected: (i) => setState(() => _aba = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.list), label: 'Lista'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}

class AbaLista extends StatefulWidget {
  const AbaLista({super.key});

  @override
  State<AbaLista> createState() => _AbaListaState();
}

class _AbaListaState extends State<AbaLista> {
  final _controle = ScrollController();

  @override
  void initState() {
    super.initState();
    // ! O placar precisa de um rebuild depois do primeiro frame: quando o
    // ! offset é restaurado do PageStorage, o controller não notifica — ele
    // ! já NASCE na posição certa. Sem isto o placar mostraria 0.0 mesmo com
    // ! a lista rolada.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _controle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itens = Repositorio.instancia.itens;
    return Column(
      children: [
        AnimatedBuilder(
          animation: _controle,
          builder: (context, _) => Placar(
            offset: _controle.hasClients ? _controle.offset : 0,
            destaque: false,
          ),
        ),
        Expanded(
          child: ListView.builder(
            key: PageStorageKey('lista'),
            controller: _controle,
            itemExtent: 80,
            itemCount: itens.length,
            itemBuilder: (context, i) =>
                LinhaDeItem(texto: itens[i], indice: i),
          ),
        ),
      ],
    );
  }
}

class AbaPerfil extends StatelessWidget {
  const AbaPerfil({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Outra aba qualquer'));
  }
}

// A faixa que identifica cada seção da comparação.
class const _Rotulo(final String texto) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(6),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Text(texto, style: const TextStyle(fontSize: 11)),
    );
  }
}
