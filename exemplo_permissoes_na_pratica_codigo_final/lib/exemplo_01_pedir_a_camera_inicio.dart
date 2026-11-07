import 'package:material_ui/material_ui.dart';
import 'package:permission_handler/permission_handler.dart';

import 'painel_de_estado.dart';

// * O botao existe e esta apagado (onPressed: null): ainda nao ha metodo para
// * ligar nele. O painel, do lado, diz que nada foi consultado. Rode assim
// * primeiro — a tela ja promete o que o codigo ainda nao cumpre.

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

  Future<void> _perdirACamera() async {
    final status = await Permission.camera.request();

    if (!mounted) return;

    setState(() {
      _leitura = LeituraDePermissao(
        status: status,
        origem: 'Permission.camera.request()',
        decisao: status.isGranted ? 'Abrir a Camera' : 'seguir sem a cameras',
      );
    });
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
            onPressed: _perdirACamera,
            icon: const Icon(Icons.photo_camera),
            label: const Text('Tirar foto de perfil'),
          ),
        ],
      ),
    ),
  );
}
