// exemplo_04_mundo_real_checkout_inicio.dart
// Ponto de partida: a tela de checkout. O `ListTile` abre o `SimpleDialog` de
// pagamento — a escolha funciona e aparece no subtítulo.
//
// ! Mas o "Finalizar pedido" está **sempre habilitado**. Abra a tela e toque
// ! direto: o pedido é finalizado com "não selecionado" no pagamento.
//
// ! E, quando o pagamento está escolhido, ele finaliza **sem confirmar** —
// ! um toque e o dinheiro foi.
//
// ? Os dois problemas já têm resposta em aulas anteriores: um botão que não
// ? pode ser usado agora, e uma ação irreversível sem confirmação.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaCheckout()));

enum FormaPagamento(final String rotulo, final IconData icone) {
  pix('Pix', Icons.pix),
  cartao('Cartão de crédito', Icons.credit_card),
  boleto('Boleto', Icons.receipt_long);
}

class TelaCheckout extends StatefulWidget {
  const TelaCheckout({super.key});

  @override
  State<TelaCheckout> createState() => _TelaCheckoutState();
}

class _TelaCheckoutState extends State<TelaCheckout> {
  FormaPagamento? _pagamento;
  bool _pedidoFinalizado = false;

  Future<void> _escolherPagamento() async {
    final resultado = await showDialog<FormaPagamento>(
      context: context,
      builder: (dialogContext) {
        return SimpleDialog(
          title: const Text('Forma de pagamento'),
          children: [
            for (final forma in FormaPagamento.values)
              SimpleDialogOption(
                onPressed: () => Navigator.pop(dialogContext, forma),
                child: Row(
                  children: [
                    Icon(forma.icone),
                    const SizedBox(width: 16),
                    Text(forma.rotulo),
                  ],
                ),
              ),
          ],
        );
      },
    );

    if (!mounted) return;
    if (resultado != null) {
      setState(() => _pagamento = resultado);
    }
  }

  Future<void> _finalizar() async {
    final forma = _pagamento!;

    final confirmou = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmar pedido?'),
          icon: Icon(Icons.shopping_bag_outlined),
          content: Text(
            r'Pagar R$ 129,90 com '
            '${forma.rotulo}',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Voltar'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Confirmar'),
            ),
          ],
        );
      },
    );

    if (!mounted) return;

    if (confirmou ?? false) {
      setState(() => _pedidoFinalizado = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pagamento = _pagamento;
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              child: ListTile(
                leading: Icon(pagamento?.icone ?? Icons.payment),
                title: const Text('Pagamento'),
                subtitle: Text(pagamento?.rotulo ?? 'não selecionado'),
                trailing: const Icon(Icons.chevron_right),
                onTap: _escolherPagamento,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              // ! Habilitado mesmo sem forma de pagamento escolhida.
              onPressed: _pagamento != null ? _finalizar : null,
              child: const Text('Finalizar pedido'),
            ),
            const SizedBox(height: 16),
            if (_pedidoFinalizado)
              Text(
                'Pedido confirmado com ${pagamento?.rotulo ?? "nada"}!',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
