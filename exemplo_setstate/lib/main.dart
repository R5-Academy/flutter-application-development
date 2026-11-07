// main.dart
// Launcher dos pontos de partida. Cada arquivo `_inicio` continua podendo
// rodar sozinho com `flutter run -t lib/....dart`.

import 'package:material_ui/material_ui.dart';

import 'exemplo_01_minimo_inicio.dart' hide main;
import 'exemplo_02_o_que_vai_dentro_inicio.dart' hide main;
import 'exemplo_03_custo_e_escopo_inicio.dart' hide main;
import 'exemplo_04_armadilha_no_build_inicio.dart' hide main;
import 'exemplo_05_armadilha_apos_dispose_inicio.dart' hide main;

void main() => runApp(const MaterialApp(home: Launcher()));

class const Launcher({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final exemplos = <({String titulo, String subtitulo, WidgetBuilder abrir})>[
      (
        titulo: '01 · Mínimo',
        subtitulo: 'Quem guarda o valor novo',
        abrir: (_) => const TelaDoProduto(),
      ),
      (
        titulo: '02 · O que vai dentro',
        subtitulo: 'Callback do setState e dado derivado',
        abrir: (_) => const Carrinho(),
      ),
      (
        titulo: '03 · Custo e escopo',
        subtitulo: 'O setState reconstrói quem o chamou',
        abrir: (_) => const TelaDoPedido(),
      ),
      (
        titulo: '04 · Armadilha no build',
        subtitulo: 'setState durante o build',
        abrir: (_) => const TelaDoCarrinho(),
      ),
      (
        titulo: '05 · Armadilha após dispose',
        subtitulo: 'setState depois que a tela saiu',
        abrir: (_) => const Vitrine(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('setState')),
      body: ListView.separated(
        itemCount: exemplos.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, i) {
          final exemplo = exemplos[i];
          return ListTile(
            title: Text(exemplo.titulo),
            subtitle: Text(exemplo.subtitulo),
            trailing: const Icon(Icons.chevron_right),
            onTap: () =>
                Navigator.of(context)
                    .push(MaterialPageRoute<void>(builder: exemplo.abrir)),
          );
        },
      ),
    );
  }
}
