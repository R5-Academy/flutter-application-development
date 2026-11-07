// exemplo_02_na_tela_inicio.dart
// Ponto de partida: o contador na tela do jeito que você já sabe — `setState`.
//
// O placar de cima conta uma coisa: quantas vezes o `build` da TELA inteira
// rodou. Ele começa em 1 — o build que montou a tela.
//
// Rode e toque no + três vezes. O número sobe, e o placar sobe junto.
//
// ? A tela tem uma AppBar, um placar, um texto de apoio e o número. Só o número
// ? depende do contador — os outros três não mudam nunca.
// ?
// ?   **por que reconstruir a tela inteira para trocar um dígito?**

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaContador()));

class TelaContador extends StatefulWidget {
  const TelaContador({super.key});

  @override
  State<TelaContador> createState() => _TelaContadorState();
}

class _TelaContadorState extends State<TelaContador> {
  final _contador = ValueNotifier<int>(0);

  // Instrumentação do exemplo (não faz parte do padrão).
  int _buildsDaTela = 0;

  @override
  Widget build(BuildContext context) {
    _buildsDaTela++;
    return Scaffold(
      appBar: AppBar(title: const Text('Contador na tela')),
      body: Column(
        children: [
          _Placar(tela: _buildsDaTela),
          const Divider(height: 1),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Só o número abaixo depende do contador.'),
          ),
          Expanded(
            child: Center(
              child: ValueListenableBuilder<int>(
                valueListenable: _contador,
                builder: (context, valor, child) {
                  return Text(
                    '$valor',
                    style: Theme.of(context).textTheme.displayLarge,
                  );
                },
              ),
            ),
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

class const _Placar({required final int tela}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          Text('$tela', style: t.headlineMedium),
          Text('builds da tela', style: t.labelMedium),
        ],
      ),
    );
  }
}
