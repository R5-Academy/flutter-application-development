// exemplo_03_01_armadilhas_inicio.dart
// As duas listas do exemplo_03_02_armadilha_key_duplicada.dart, agora com chaves diferentes:
// 'lista-de-cima' e 'lista-de-baixo'.
//
// Faça o mesmo teste:
//   1. role a de cima até uns 900;
//   2. role a de baixo até uns 400;
//   3. vá para a aba Perfil e volte.
//
// Cada uma voltou no seu lugar: 900 em cima, 400 embaixo.
//
// O endereço no PageStorage mudou de [lista] × [lista] para
// [lista-de-cima] × [lista-de-baixo]. Duas entradas no mapa, não uma.

import 'package:material_ui/material_ui.dart';

import 'dados.dart';

void main() => runApp(const AppDasArmadilhas());

class AppDasArmadilhas extends StatelessWidget {
  const AppDasArmadilhas({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chaves e endereços',
      theme: ThemeData(colorSchemeSeed: Colors.orange),
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
      appBar: AppBar(title: const Text('Duas listas, uma tela')),
      body: _aba == 0 ? const TelaDuasListas() : const AbaPerfil(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _aba,
        onDestinationSelected: (i) => setState(() => _aba = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.list), label: 'Listas'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}

class TelaDuasListas extends StatelessWidget {
  const TelaDuasListas({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Expanded(
          child: AncoraDeSecao(
            key: PageStorageKey('secao-de-cima'),
            child: ListaComChave(chave: 'lista', titulo: 'Lista de cima'),
          ),
        ),
        Divider(height: 2, thickness: 2),
        Expanded(
          child: AncoraDeSecao(
            key: ValueKey('secao-de-baixo'),
            child: ListaComChave(chave: 'lista', titulo: 'Lista de baixo'),
          ),
        ),
      ],
    );
  }
}

class const AncoraDeSecao({super.key, required final Widget child})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) => child;
}

class AbaPerfil extends StatelessWidget {
  const AbaPerfil({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Outra aba qualquer'));
  }
}

class const ListaComChave({
  super.key,
  required final String chave,
  required final String titulo,
}) extends StatefulWidget {
  @override
  State<ListaComChave> createState() => _ListaComChaveState();
}

class _ListaComChaveState extends State<ListaComChave> {
  final _controle = ScrollController();

  @override
  void initState() {
    super.initState();
    // ! O cabeçalho precisa de um rebuild depois do primeiro frame: quando o
    // ! offset é restaurado do PageStorage, o controller não notifica — ele
    // ! já NASCE na posição certa.
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
          builder: (context, _) => Container(
            width: double.infinity,
            padding: const EdgeInsets.all(6),
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Text(
              "${widget.titulo} — PageStorageKey('${widget.chave}') — "
              'offset: '
              '${(_controle.hasClients ? _controle.offset : 0).toStringAsFixed(1)}',
              style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            key: PageStorageKey<String>(widget.chave),
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
