// exemplo_01_a_mesma_tela_com_callbacks_inicio.dart
//
// Esta e a tela da aula anterior, funcionando: o mixin, o registro no
// initState, a faxina no dispose e um `switch` sobre o estado que chegou.
//
// ? Repare no que o `switch` NAO consegue dizer: ele recebe `hidden` tanto
// ? quando o app esta indo embora quanto quando esta voltando. Para saber a
// ? direcao, voce teria que guardar o estado anterior e comparar na mao.

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
  final _eventos = <String>[];

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
    setState(() => _eventos.add(estado.name));

    switch (estado) {
      case AppLifecycleState.resumed:
        _comecarTimer();
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        _timer?.cancel();
      case AppLifecycleState.inactive:
        break;
    }
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
          Padding(
            padding: const EdgeInsets.all(24),
            child: Text('$_segundos s', style: const TextStyle(fontSize: 48)),
          ),
          const Divider(height: 1),
          Expanded(child: _Eventos(eventos: _eventos)),
        ],
      ),
    );
  }
}

class const _Eventos({required final List<String> eventos})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      reverse: true,
      itemCount: eventos.length,
      itemBuilder: (_, index) => ListTile(
        dense: true,
        leading: const Icon(Icons.chevron_right),
        title: Text(eventos[index]),
      ),
    );
  }
}
