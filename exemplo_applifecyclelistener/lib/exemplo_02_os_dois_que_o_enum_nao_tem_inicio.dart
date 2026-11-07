// exemplo_02_os_dois_que_o_enum_nao_tem_inicio.dart
//
// Um caso comum: recarregar os dados quando o usuario volta para o app,
// porque enquanto ele esteve fora o preco pode ter mudado.
//
// Aqui a recarga esta no `onResume` -- o callback mais obvio.
//
// Rode e, SEM sair do app, arraste a barra de notificacoes e feche.
// O contador de recargas subiu: o app foi ao servidor a toa.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaCatalogo()));

class TelaCatalogo extends StatefulWidget {
  const TelaCatalogo({super.key});

  @override
  State<TelaCatalogo> createState() => _TelaCatalogoState();
}

class _TelaCatalogoState extends State<TelaCatalogo> {
  late final AppLifecycleListener _ciclo;
  int _recargas = 0;
  final _eventos = <String>[];

  @override
  void initState() {
    super.initState();
    _ciclo = AppLifecycleListener(
      onResume: () {
        _registrar('onResume');
        _recarregar();
      },
      onInactive: () => _registrar('onInactive'),
      onHide: () => _registrar('onHide'),
      onPause: () => _registrar('onPause'),
      onDetach: () => _registrar('onDetach'),
    );
  }

  @override
  void dispose() {
    _ciclo.dispose();
    super.dispose();
  }

  void _registrar(String evento) => setState(() => _eventos.add(evento));

  void _recarregar() => setState(() => _recargas++);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Catalogo')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'recarregou $_recargas vez(es)',
              style: const TextStyle(fontSize: 24),
            ),
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
