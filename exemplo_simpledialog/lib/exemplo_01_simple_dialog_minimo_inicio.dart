// exemplo_01_simple_dialog_minimo_inicio.dart
// Ponto de partida: escolher a forma de pagamento — resolvido com o
// `AlertDialog` da aula passada, com as três opções no `actions`.
//
// ! Rode e olhe a base do diálogo. O `actions` é um `OverflowBar`: quando os
// ! botões não cabem lado a lado, ele **empilha** os três, colados à direita.
// !
// !   celular (360-400 px)  três linhas soltas, encostadas na direita, cada uma
// !                         do tamanho do próprio rótulo
// !   desktop (800+ px)     os três lado a lado, na mesma linha
// !
// ! Não estoura, não corta, não dá erro nenhum. O layout "funciona" — e é aí que
// ! está a pegadinha, porque o problema não é de pixel.
//
// ! `actions` foi feito para **ações**, e ação tem hierarquia: quem lê espera a
// ! principal na ponta direita e a secundária ao lado. Aqui não há hierarquia
// ! nenhuma — são três opções **equivalentes**. E a área de toque de cada uma é
// ! só a largura do rótulo: "Pix" vira um alvo de 64 px encostado na borda.
//
// ? Um diálogo que apresenta uma **lista de escolhas** é outro tipo de diálogo.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaPagamento()));

// * Um enum deixa as opções explícitas e seguras: o retorno só pode ser uma
// * destas três, nada de String solta escrita errada.
enum FormaPagamento(final String rotulo) {
  pix('Pix'),
  cartao('Cartão de crédito'),
  boleto('Boleto');
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
        return AlertDialog(
          title: const Text('Escolha a forma de pagamento'),
          // ! Três opções equivalentes no slot das ações, que não é para isso.
          actions: [
            for (final forma in FormaPagamento.values)
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, forma),
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
