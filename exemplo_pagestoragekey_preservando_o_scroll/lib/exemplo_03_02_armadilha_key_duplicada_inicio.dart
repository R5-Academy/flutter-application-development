// exemplo_03_02_armadilha_key_duplicada_inicio.dart
// ! ESTE ARQUIVO TEM UM BUG DE PROPÓSITO. É o ponto de partida do bloco.
//
// Duas listas na mesma tela, cada uma com a sua PageStorageKey. Só que as
// duas chaves têm o MESMO nome: 'lista'.
//
// Faça o teste:
//   1. role a de cima até uns 900 (o cabeçalho mostra o offset ao vivo);
//   2. role a de baixo até uns 400;
//   3. vá para a aba Perfil e volte para a aba Listas.
//
// ! As duas voltam em 400 — a de cima herdou o lugar da de baixo.
//
// O PageStorage é um mapa. Chaves iguais, mesma entrada: o último a gravar
// vence, e na volta as duas leem o mesmo valor.
//
// ! A troca de aba é ESSENCIAL para ver o bug. Sem ela a tela nunca é
// ! destruída, ninguém lê o PageStorage de volta e a colisão fica invisível.

import 'package:material_ui/material_ui.dart';

import 'dados.dart';

void main() => runApp(const AppDasArmadilhas());

class AppDasArmadilhas extends StatelessWidget {
  const AppDasArmadilhas({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Duas listas',
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
      appBar: AppBar(title: const Text('Duas listas na mesma tela')),
      // A troca de aba destrói a tela das duas listas: é na volta que o
      // PageStorage é lido, e é aí que a colisão aparece.
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
        // ! As duas usam PageStorageKey('lista'). Colidem.
        Expanded(
          child: ListaComChave(chave: 'lista', titulo: 'Lista de cima'),
        ),
        Divider(height: 2, thickness: 2),
        Expanded(
          child: ListaComChave(chave: 'lista', titulo: 'Lista de baixo'),
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

// A lista com o offset ao vivo no cabeçalho — é o número que denuncia a
// colisão na volta da aba.
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
    // ! já NASCE na posição certa. Sem isto o número mostraria 0.0 mesmo com
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
