// exemplo_05_a_armadilha_do_topo_inicio.dart
// Ponto de partida: a tela montada do jeito CERTO. O builder envolve só o total,
// e o painel de ofertas — que não depende do contador — fica fora dele.
//
// Rode e toque no + cinco vezes: o painel marca **1 build**. Ele foi construído
// uma vez, quando a tela montou, e nunca mais.
//
// ? Agora um experimento. O código abaixo funcionaria igual se o builder
// ? estivesse mais acima — envolvendo o `Scaffold` inteiro. A tela ficaria
// ? idêntica, o total continuaria certo, e o código continuaria "reativo".
// ?
// ?   **quanto custa subir o builder um andar?**
// ?
// ? O placar do painel responde.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaArmadilhaDoTopo()));

// O placar destes exemplos: o número de builds fica na tela, não no console.
class const _Placar({required final String nome, required final int builds})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      '$nome: $builds builds',
      style: Theme.of(context).textTheme.labelLarge,
    );
  }
}

class const _PainelDeOfertas({required final List<String> ofertas})
    extends StatefulWidget {
  @override
  State<_PainelDeOfertas> createState() => _PainelDeOfertasState();
}

class _PainelDeOfertasState extends State<_PainelDeOfertas> {
  int _builds = 0;

  @override
  Widget build(BuildContext context) {
    _builds++;

    return Column(
      children: [
        const Text('Ofertas da semana'),
        for (final oferta in widget.ofertas) Text(oferta),
        _Placar(nome: 'painel de ofertas', builds: _builds),
      ],
    );
  }
}

class TelaArmadilhaDoTopo extends StatefulWidget {
  const TelaArmadilhaDoTopo({super.key});

  @override
  State<TelaArmadilhaDoTopo> createState() => _TelaArmadilhaDoTopoState();
}

class _TelaArmadilhaDoTopoState extends State<TelaArmadilhaDoTopo> {
  final _contador = ValueNotifier<int>(0);
  final _ofertas = ['Fone com 20% off', 'Teclado com frete grátis'];

  @override
  void dispose() {
    _contador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // O builder envolve só o total — o menor trecho que depende do valor.
    return Scaffold(
      appBar: AppBar(title: const Text('Onde o builder começa')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _PainelDeOfertas(ofertas: _ofertas),
          const SizedBox(height: 24),
          ValueListenableBuilder<int>(
            valueListenable: _contador,
            builder: (context, valor, child) =>
                Text('Total: $valor', style: const TextStyle(fontSize: 32)),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _contador.value++,
        child: const Icon(Icons.add),
      ),
    );
  }
}
