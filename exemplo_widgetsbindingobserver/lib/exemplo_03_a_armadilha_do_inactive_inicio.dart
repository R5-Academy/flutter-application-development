// exemplo_03_a_armadilha_do_inactive_inicio.dart
//
// `inactive` parece o estado obvio para pausar: o nome diz "inativo".
// Este arquivo faz exatamente isso -- pausa assim que o aviso chega.
//
// Rode e, SEM sair do app, arraste a barra de notificacoes para baixo (ou
// abra a central de controle, no iOS) e feche de novo.
//
// O contador de pausas subiu, e o cronometro piscou -- e o usuario nunca saiu
// do app.

import 'dart:async';

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaMonitor()));

class TelaMonitor extends StatefulWidget {
  const TelaMonitor({super.key});

  @override
  State<TelaMonitor> createState() => _TelaMonitorState();
}

class _TelaMonitorState extends State<TelaMonitor> with WidgetsBindingObserver {
  Timer? _timer;
  int _segundos = 0;
  int _vezesQuePausou = 0;
  final _historico = <AppLifecycleState>[];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _comecarTimer();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState estado) {
    setState(() => _historico.add(estado));

    switch (estado) {
      case AppLifecycleState.resumed:
        _comecarTimer();
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        _pausar();
    }
  }

  void _pausar() {
    if (_timer == null) return;
    _timer?.cancel();
    _timer = null;
    setState(() => _vezesQuePausou++);
  }

  void _comecarTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _segundos++);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ciclo de vida do app')),
      body: Column(
        children: [
          _Placar(segundos: _segundos, pausas: _vezesQuePausou),
          const Divider(height: 1),
          Expanded(child: _Historico(estados: _historico)),
        ],
      ),
    );
  }
}

class const _Placar({required final int segundos, required final int pausas})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text('$segundos s', style: const TextStyle(fontSize: 48)),
          Text('pausou $pausas vez(es)', style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

class const _Historico({required final List<AppLifecycleState> estados})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      reverse: true,
      itemCount: estados.length,
      itemBuilder: (_, index) {
        final estado = estados[index];
        return ListTile(
          dense: true,
          leading: const Icon(Icons.chevron_right),
          title: Text(estado.name),
        );
      },
    );
  }
}
