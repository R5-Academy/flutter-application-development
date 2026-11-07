// exemplo_04_programatico_inicio.dart
// Ponto de partida: o pull-to-refresh funcionando, com um interruptor para o
// `triggerMode` — e um botão de recarregar na AppBar que está apagado.
//
// ? O gesto resolve o caso comum, e não resolve dois:
// ?
// ?   1. o app quer recarregar por conta própria (voltou de outra tela, chegou
// ?      um push) — sem ninguém puxar nada;
// ?   2. o usuário já rolou a lista para baixo e quer atualizar de onde está.
// ?
// ?   **dá para acionar o MESMO indicador sem o gesto?**
// ?
// ? Dá, e a chave para isso é literalmente uma `GlobalKey`.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaProgramatica()));

class TelaProgramatica extends StatefulWidget {
  const TelaProgramatica({super.key});

  @override
  State<TelaProgramatica> createState() => _TelaProgramaticaState();
}

class _TelaProgramaticaState extends State<TelaProgramatica> {
  var _itens = List.generate(40, (i) => 'Linha ${i + 1}');
  int _recargas = 0;
  var _modo = RefreshIndicatorTriggerMode.anywhere;

  Future<void> _atualizar() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _recargas++;
      _itens = List.generate(40, (i) => 'Linha ${i + 1} (recarga $_recargas)');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Refresh sem gesto'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Atualizar',
            onPressed: null,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: SwitchListTile(
            dense: true,
            title: Text('triggerMode: ${_modo.name}'),
            value: _modo == RefreshIndicatorTriggerMode.anywhere,
            onChanged: (v) => setState(() {
              _modo = v
                  ? RefreshIndicatorTriggerMode.anywhere
                  : RefreshIndicatorTriggerMode.onEdge;
            }),
          ),
        ),
      ),
      body: RefreshIndicator(
        // ? Role a lista até o meio e arraste para baixo num movimento só.
        // Com onEdge (o padrão) nada acontece: o gesto só conta se COMECAR com
        // a lista no topo. Com anywhere o arraste pode comecar rolado - mas o
        // refresh só arma quando esse mesmo arraste chega ao topo e passa dele.
        triggerMode: _modo,
        // displacement: onde o spinner estaciona, contado a partir da borda.
        // edgeOffset: empurra a borda para baixo (útil quando há uma AppBar
        // que rola junto). Os dois somam: edgeOffset 80 + displacement 40
        // coloca o topo do spinner em 120.
        displacement: 40,
        onRefresh: _atualizar,
        child: ListView.builder(
          itemCount: _itens.length,
          itemBuilder: (context, index) => ListTile(
            leading: const Icon(Icons.short_text),
            title: Text(_itens[index]),
          ),
        ),
      ),
    );
  }
}
