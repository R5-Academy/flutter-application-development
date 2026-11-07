// exemplo_01_assinando_um_aspecto_inicio.dart
// Ponto de partida: um InheritedWidget comum, igual ao da aula 03, distribuindo
// TRÊS dados de uma entrega para três painéis distantes na tela.
// Cada painel tem um placar de builds. Toque em "+1 min" e repare: os três
// placares sobem juntos, mesmo que só o tempo tenha mudado.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaDaEntrega()));

class const EntregaScope({
  super.key,
  required final String status,
  required final int minutos,
  required final int naoLidas,
  required super.child,
}) extends InheritedWidget {
  static EntregaScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<EntregaScope>();
    assert(scope != null, 'Nenhum EntregaScope encontrado no contexto');
    return scope!;
  }

  @override
  bool updateShouldNotify(EntregaScope oldWidget) =>
      status != oldWidget.status ||
      minutos != oldWidget.minutos ||
      naoLidas != oldWidget.naoLidas;
}

class TelaDaEntrega extends StatefulWidget {
  const TelaDaEntrega({super.key});

  @override
  State<TelaDaEntrega> createState() => _TelaDaEntregaState();
}

class _TelaDaEntregaState extends State<TelaDaEntrega> {
  static const _status = ['Preparando', 'Saiu para entrega', 'Chegou'];

  int _indiceDoStatus = 0;
  int _minutos = 32;
  int _naoLidas = 0;

  @override
  Widget build(BuildContext context) {
    return EntregaScope(
      status: _status[_indiceDoStatus],
      minutos: _minutos,
      naoLidas: _naoLidas,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sua entrega'),
          actions: const [BadgeDeMensagens()],
        ),
        body: const Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [PainelDoStatus(), SizedBox(height: 12), PainelDoTempo()],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            spacing: 8,
            children: [
              Expanded(
                child: FilledButton.tonal(
                  onPressed: () => setState(() => _minutos--),
                  child: const Text('+1 min'),
                ),
              ),
              Expanded(
                child: FilledButton.tonal(
                  onPressed: () => setState(() => _naoLidas++),
                  child: const Text('Nova mensagem'),
                ),
              ),
              Expanded(
                child: FilledButton.tonal(
                  onPressed: () => setState(() {
                    _indiceDoStatus = (_indiceDoStatus + 1) % _status.length;
                  }),
                  child: const Text('Avançar status'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PainelDoStatus extends StatefulWidget {
  const PainelDoStatus({super.key});

  @override
  State<PainelDoStatus> createState() => _PainelDoStatusState();
}

class _PainelDoStatusState extends State<PainelDoStatus> {
  int _builds = 0;

  @override
  Widget build(BuildContext context) {
    final status = EntregaScope.of(context).status;
    _builds++;

    return _Cartao(titulo: 'Status', valor: status, builds: _builds);
  }
}

class PainelDoTempo extends StatefulWidget {
  const PainelDoTempo({super.key});

  @override
  State<PainelDoTempo> createState() => _PainelDoTempoState();
}

class _PainelDoTempoState extends State<PainelDoTempo> {
  int _builds = 0;

  @override
  Widget build(BuildContext context) {
    final minutos = EntregaScope.of(context).minutos;
    _builds++;

    return _Cartao(titulo: 'Chega em', valor: '$minutos min', builds: _builds);
  }
}

class BadgeDeMensagens extends StatefulWidget {
  const BadgeDeMensagens({super.key});

  @override
  State<BadgeDeMensagens> createState() => _BadgeDeMensagensState();
}

class _BadgeDeMensagensState extends State<BadgeDeMensagens> {
  int _builds = 0;

  @override
  Widget build(BuildContext context) {
    final naoLidas = EntregaScope.of(context).naoLidas;
    _builds++;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Center(
        child: Text('$naoLidas msg (build $_builds)', key: const Key('badge')),
      ),
    );
  }
}

// * Bancada: o cartão só desenha. Ele não lê o escopo, então nunca aparece
//   como culpado de rebuild nenhum.
class const _Cartao({
  required final String titulo,
  required final String valor,
  required final int builds,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(titulo),
        subtitle: Text(valor, style: const TextStyle(fontSize: 22)),
        trailing: Text(
          'build $builds',
          key: Key('placar-$titulo'),
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ),
    );
  }
}
