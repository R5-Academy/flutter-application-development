import 'package:material_ui/material_ui.dart';
import 'package:permission_handler/permission_handler.dart';

import 'painel_de_estado.dart';

// * Gravar um video precisa de duas coisas: camera e microfone. O botao esta
// * apagado porque ainda nao existe o metodo que pede as duas.
//
// * O painel de baixo lista uma linha por permissao. Ele nasce vazio, e e o
// * retorno do pedido que vai preencher — uma entrada por permissao pedida.

void main() => runApp(const AppDeVideo());

class AppDeVideo extends StatelessWidget {
  const AppDeVideo({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Permissoes na pratica',
    theme: ThemeData(colorSchemeSeed: Colors.indigo),
    home: const TelaDeGravacao(),
  );
}

class TelaDeGravacao extends StatefulWidget {
  const TelaDeGravacao({super.key});

  @override
  State<TelaDeGravacao> createState() => _TelaDeGravacaoState();
}

class _TelaDeGravacaoState extends State<TelaDeGravacao> {
  var _leitura = PainelDeEstado.aindaNaoConsultado;
  var _porPermissao = <String, String>{};

  Future<void> _perdirParaGravar() async {
    final resultado = await [
      Permission.camera,
      Permission.microphone,
    ].request();

    if (!mounted) return;

    final podeGravar = resultado.values.every((status) => status.isGranted);
    final faltando = resultado.entries
        .where((entrada) => !entrada.value.isGranted)
        .map((entrada) => _nomeCurto(entrada.key))
        .join(' e ');

    setState(() {
      _porPermissao = {
        for (final MapEntry(:key, :value) in resultado.entries)
          _nomeCurto(key): value.name,
      };

      _leitura = LeituraDePermissao(
        status: podeGravar
            ? PermissionStatus.granted
            : resultado.values.firstWhere((status) => !status.isGranted),
        origem: '[camera,microfone].request() - ${resultado.length} entradas',
        decisao: podeGravar
            ? 'Gravar video com som'
            : 'não da pra gravar: falta $faltando',
      );
    });
  }

  static String _nomeCurto(Permission permission) =>
      permission == Permission.camera ? 'camera' : 'microfone';

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Gravar um video')),
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PainelDeEstado(leitura: _leitura),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _perdirParaGravar,
            icon: const Icon(Icons.videocam),
            label: const Text('Comecar a gravar'),
          ),
          FilledButton.icon(
            onPressed: () => openAppSettings(),
            icon: const Icon(Icons.settings),
            label: const Text('Abrir configurações '),
          ),
          const SizedBox(height: 24),
          Expanded(child: _ListaPorPermissao(itens: _porPermissao)),
        ],
      ),
    ),
  );
}

// * Bancada: a lista que mostra o resultado permissao a permissao.
class const _ListaPorPermissao({required final Map<String, String> itens})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (itens.isEmpty) {
      return Center(
        child: Text(
          'nenhuma permissao pedida ainda',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    final nomes = itens.keys.toList();

    return ListView.builder(
      itemCount: nomes.length,
      itemBuilder: (_, index) {
        final nome = nomes[index];
        return ListTile(
          dense: true,
          title: Text(nome),
          trailing: Text(itens[nome]!),
        );
      },
    );
  }
}
