// exemplo_02_opcoes_com_icone_inicio.dart
// Ponto de partida: o `SimpleDialog` do bloco anterior, funcionando.
//
// ! Três linhas de texto puro, uma embaixo da outra. Para escolher, a pessoa
// ! precisa **ler as três** — mesmo já sabendo que quer Pix.
//
// ! É a mesma "parede de texto" da aula de Icon, agora dentro de um diálogo. E
// ! aqui incomoda mais: o diálogo interrompeu o que a pessoa estava fazendo, e
// ! cada segundo a mais é atrito.
//
// ? O `SimpleDialogOption` recebe um `child`. E `child` aceita qualquer widget.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaPagamento()));

enum FormaPagamento {
  pix('Pix'),
  cartao('Cartão de crédito'),
  boleto('Boleto');

  const FormaPagamento(this.rotulo);
  final String rotulo;
}

class TelaPagamento extends StatefulWidget {
  const TelaPagamento({super.key});

  @override
  State<TelaPagamento> createState() => _TelaPagamentoState();
}

class _TelaPagamentoState extends State<TelaPagamento> {
  FormaPagamento? _escolhida;

  Future<void> _abrirDialogo() async {
    final resultado = await showDialog<FormaPagamento>(
      context: context,
      builder: (dialogContext) {
        return SimpleDialog(
          title: const Text('Forma de pagamento'),
          children: [
            for (final forma in FormaPagamento.values)
              SimpleDialogOption(
                onPressed: () => Navigator.pop(dialogContext, forma),
                // ! Só texto: as três exigem leitura.
                child: Text(forma.rotulo),
              ),
          ],
        );
      },
    );

    if (!mounted) return;
    if (resultado != null) {
      setState(() => _escolhida = resultado);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pagamento')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilledButton(
              onPressed: _abrirDialogo,
              child: const Text('Escolher pagamento'),
            ),
            const SizedBox(height: 24),
            Text(_escolhida?.rotulo ?? 'Nenhuma forma escolhida'),
          ],
        ),
      ),
    );
  }
}
