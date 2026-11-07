import 'package:material_ui/material_ui.dart';

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
            onPressed: null,
            icon: const Icon(Icons.videocam),
            label: const Text('Comecar a gravar'),
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
