// exemplo_01_problema_inicio.dart
// Um app de duas abas. A primeira tem uma lista de 800 itens.
//
// Os dados moram num repositório FORA do State, então trocar de aba não os
// recria — o placar mostra "montagens do repositório: 1" o tempo todo.
//
// Faça o teste:
//   1. role a lista até o meio;
//   2. vá para a aba Perfil;
//   3. volte para a aba Lista.
//
// ! Os dados estão todos lá. E a lista voltou para o topo.

import 'package:material_ui/material_ui.dart';

import 'dados.dart';

void main() => runApp(const AppDoProblema());

class AppDoProblema extends StatelessWidget {
  const AppDoProblema({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'O lugar da rolagem',
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
      home: const TelaComAbas(),
    );
  }
}

class TelaComAbas extends StatefulWidget {
  const TelaComAbas({super.key});

  @override
  State<TelaComAbas> createState() => _TelaComAbasState();
}

class _TelaComAbasState extends State<TelaComAbas> {
  int _aba = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('O lugar da rolagem')),
      // A troca de aba substitui o body: a aba que sai é destruída.
      body: _aba == 0 ? const AbaLista() : const AbaPerfil(),
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
            destaque: true,
          ),
        ),
        Expanded(
          child: ListView.builder(
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
