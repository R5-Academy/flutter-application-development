// exemplo_02_pausando_o_que_gasta_inicio.dart
//
// A tela ja sabe QUE o app saiu de cena: o historico registra cada estado.
// Saber, porem, nao economiza bateria -- o Timer continua contando.
//
// O segundo numero do placar conta os segundos que passaram enquanto o app
// NAO estava em primeiro plano. Ele e a conta da bateria desperdicada.
//
// Aperte home, espere uns cinco segundos e volte: o numero subiu.

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
  int _segundosForaDaTela = 0;
  AppLifecycleState _estado = .resumed;
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
    setState(() {
      _estado = estado;
      _historico.add(estado);
    });
  }

  void _comecarTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        _segundos++;
        if (_estado != AppLifecycleState.resumed) _segundosForaDaTela++;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ciclo de vida do app')),
      body: Column(
        children: [
          _Placar(segundos: _segundos, foraDaTela: _segundosForaDaTela),
          const Divider(height: 1),
          Expanded(child: _Historico(estados: _historico)),
        ],
      ),
    );
  }
}

class const _Placar({
  required final int segundos,
  required final int foraDaTela,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text('$segundos s', style: const TextStyle(fontSize: 48)),
          Text(
            '$foraDaTela s contados fora da tela',
            style: const TextStyle(fontSize: 16),
          ),
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
