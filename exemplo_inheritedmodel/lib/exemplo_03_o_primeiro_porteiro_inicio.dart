// exemplo_03_o_primeiro_porteiro_inicio.dart
// O updateShouldNotifyDependent está correto e o badge assina o aspecto certo.
// Mesmo assim, toque em "Nova mensagem": o número não sai do lugar.
// O culpado está no updateShouldNotify — o porteiro de cima, que roda primeiro
// e decide se alguém sequer será consultado.

import 'package:material_ui/material_ui.dart';

enum AspectoDaEntrega { status, minutos, naoLidas }

class const EntregaScope({
  super.key,
  required final String status,
  required final int minutos,
  required final int naoLidas,
  required super.child,
}) extends InheritedModel<AspectoDaEntrega> {
  static EntregaScope of(BuildContext context, {AspectoDaEntrega? aspecto}) {
    final scope = InheritedModel.inheritFrom<EntregaScope>(
      context,
      aspect: aspecto,
    );
    assert(scope != null, 'Nenhum EntregaScope encontrado no contexto');
    return scope!;
  }

  @override
  bool updateShouldNotify(EntregaScope oldWidget) =>
      status != oldWidget.status || minutos != oldWidget.minutos;

  @override
  bool updateShouldNotifyDependent(
    EntregaScope oldWidget,
    Set<AspectoDaEntrega> aspectos,
  ) =>
      (status != oldWidget.status &&
          aspectos.contains(AspectoDaEntrega.status)) ||
      (minutos != oldWidget.minutos &&
          aspectos.contains(AspectoDaEntrega.minutos)) ||
      (naoLidas != oldWidget.naoLidas &&
          aspectos.contains(AspectoDaEntrega.naoLidas));
}

void main() => runApp(const MaterialApp(home: TelaDaEntrega()));

class TelaDaEntrega extends StatefulWidget {
  const TelaDaEntrega({super.key});

  @override
  State<TelaDaEntrega> createState() => _TelaDaEntregaState();
}

class _TelaDaEntregaState extends State<TelaDaEntrega> {
  int _minutos = 32;
  int _naoLidas = 0;

  @override
  Widget build(BuildContext context) {
    return EntregaScope(
      status: 'Saiu para entrega',
      minutos: _minutos,
      naoLidas: _naoLidas,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sua entrega'),
          actions: const [BadgeDeMensagens()],
        ),
        body: const Padding(
          padding: EdgeInsets.all(16),
          child: PainelDoTempo(),
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
            ],
          ),
        ),
      ),
    );
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
    final minutos = EntregaScope.of(context, aspecto: .minutos).minutos;
    _builds++;

    return Card(
      child: ListTile(
        title: const Text('Chega em'),
        subtitle: Text('$minutos min', style: const TextStyle(fontSize: 22)),
        trailing: Text('build $_builds', key: const Key('placar-tempo')),
      ),
    );
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
    final naoLidas = EntregaScope.of(context, aspecto: .naoLidas).naoLidas;
    _builds++;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Center(
        child: Text('$naoLidas msg (build $_builds)', key: const Key('badge')),
      ),
    );
  }
}
