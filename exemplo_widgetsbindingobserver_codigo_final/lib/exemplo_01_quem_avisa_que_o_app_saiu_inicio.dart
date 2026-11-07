// exemplo_01_quem_avisa_que_o_app_saiu_inicio.dart
//
// Uma tela que gasta recurso o tempo todo: um Timer contando segundos.
//
// Rode, deixe o contador subir, aperte home (ou minimize a janela) e volte.
// O contador continuou. Num app de verdade isso e um video que segue tocando,
// um GPS ligado, uma conexao aberta queimando bateria de alguem que nem esta
// olhando para a tela.
//
// ? O `dispose` nao ajuda aqui: quando o usuario aperta home a tela NAO e
// ? descartada -- ela continua viva, montada, so invisivel. Existe um segundo
// ? ciclo de vida, o do aplicativo, e o painel abaixo esta esperando por ele.

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
  final _historico = <AppLifecycleState>[];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _comecarTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _comecarTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _segundos++);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _historico.add(state);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ciclo de vida do app')),
      body: Column(
        children: [
          _Placar(segundos: _segundos),
          const Divider(height: 1),
          Expanded(child: _Historico(estados: _historico)),
        ],
      ),
    );
  }
}

class const _Placar({required final int segundos}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text('$segundos s', style: const TextStyle(fontSize: 48)),
          const Text(
            'O contador so para quando o Timer para.',
            textAlign: TextAlign.center,
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
    if (estados.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Nenhum aviso chegou ate agora.\n'
            'Ninguem nesta tela esta ouvindo o ciclo de vida do app.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

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
