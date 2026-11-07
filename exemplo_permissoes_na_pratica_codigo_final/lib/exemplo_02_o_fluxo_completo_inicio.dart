import 'package:material_ui/material_ui.dart';
import 'package:permission_handler/permission_handler.dart';

import 'painel_de_estado.dart';

// * Este arquivo comeca onde o exemplo 01 parou: o pedido curto, que so chama
// * request() e mostra o resultado.
//
// * Ele funciona ate o usuario negar duas vezes. A partir dai o request() volta
// * na hora, sempre igual, e o botao vira um botao morto: o usuario toca, nada
// * acontece, e o app nao explica por que.
//
// * O segundo botao, apagado, e a saida — e o assunto do bloco.

void main() => runApp(const AppDaCamera());

class AppDaCamera extends StatelessWidget {
  const AppDaCamera({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Permissoes na pratica',
    theme: ThemeData(colorSchemeSeed: Colors.indigo),
    home: const TelaDaCamera(),
  );
}

class TelaDaCamera extends StatefulWidget {
  const TelaDaCamera({super.key});

  @override
  State<TelaDaCamera> createState() => _TelaDaCameraState();
}

class _TelaDaCameraState extends State<TelaDaCamera> {
  var _leitura = PainelDeEstado.aindaNaoConsultado;

  Future<void> _pedirACamera() async {
    var status = await Permission.microphone.status;

    if (!mounted) return;

    if (status.isPermanentlyDenied) {
      _leitura = LeituraDePermissao(
        status: status,
        origem: 'Permission.microphone.status',
        decisao: 'Mandar para configurações - o dialogo não aparece mais',
      );
    }

    if (!status.isGranted) {
      status = await Permission.microphone.request();
      if (!mounted) return;
    }

    setState(() {
      _leitura = LeituraDePermissao(
        status: status,
        origem: 'Permission.microphone.request()',
        decisao: status.isGranted
            ? 'abrir a microphone'
            : 'seguir sem o microphone',
      );
    });
  }

  Future<void> _abrirConfiguracoes() async {
    await openAppSettings();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Foto de perfil')),
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PainelDeEstado(leitura: _leitura),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _pedirACamera,
            icon: const Icon(Icons.mic),
            label: const Text('Gravar audio'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _leitura.status?.isPermanentlyDenied ?? false
                ? _abrirConfiguracoes
                : null,
            icon: const Icon(Icons.settings),
            label: const Text('Abrir as Configuracoes do app'),
          ),
        ],
      ),
    ),
  );
}
