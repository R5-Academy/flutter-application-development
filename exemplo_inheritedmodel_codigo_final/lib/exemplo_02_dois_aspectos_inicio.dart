// exemplo_02_dois_aspectos_inicio.dart
// Um painel de resumo que mostra DOIS campos (status e tempo) e, por enquanto,
// chama o of() sem dizer nenhum aspecto.
// Rode e toque em "Nova mensagem": o resumo não usa esse campo e mesmo assim
// reconstrói. Quem não assina aspecto nenhum volta a ser um InheritedWidget.

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
      status != oldWidget.status ||
      minutos != oldWidget.minutos ||
      naoLidas != oldWidget.naoLidas;

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
          child: PainelDeResumo(),
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

class PainelDeResumo extends StatefulWidget {
  const PainelDeResumo({super.key});

  @override
  State<PainelDeResumo> createState() => _PainelDeResumoState();
}

class _PainelDeResumoState extends State<PainelDeResumo> {
  int _builds = 0;

  @override
  Widget build(BuildContext context) {
    final status = EntregaScope.of(context, aspecto: .status).status;
    final minutos = EntregaScope.of(context, aspecto: .minutos).minutos;
    _builds++;

    return Card(
      child: ListTile(
        title: Text(status),
        subtitle: Text('chega em $minutos min'),
        trailing: Text('build $_builds', key: const Key('placar-resumo')),
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
