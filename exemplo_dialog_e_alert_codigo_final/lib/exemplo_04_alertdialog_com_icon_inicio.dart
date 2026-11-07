// exemplo_04_alertdialog_com_icon_inicio.dart
// Ponto de partida: o diálogo que confirma a compra. Título, texto e um botão.
//
// ! Ele está correto — e visualmente idêntico ao diálogo de erro, ao de aviso e
// ! ao de confirmação. Nada nele diz **"deu certo"** antes de a pessoa ler.
//
// ! Num momento de alívio como esse (acabei de gastar dinheiro, deu tudo bem?),
// ! a leitura vem depois da reação. E a reação depende de um sinal visual que
// ! não existe aqui.
//
// ? O `AlertDialog` do Material 3 tem um lugar próprio para esse sinal — e
// ? outro parâmetro para o botão único não ficar espremido no canto.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaComIcone()));

class TelaComIcone extends StatelessWidget {
  const TelaComIcone({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AlertDialog com icon')),
      body: Center(
        child: FilledButton(
          onPressed: () => _mostrarSucesso(context),
          child: const Text('Finalizar compra'),
        ),
      ),
    );
  }

  void _mostrarSucesso(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          // ! Sem sinal visual: parece qualquer outro diálogo.
          icon: Icon(Icons.check_circle),
          iconColor: Colors.green,
          title: const Text('Pedido confirmado'),
          content: const Text(
            'Seu pedido foi realizado e vai chegar em até 3 dias úteis.',
          ),
          // ! Botão único empurrado para o canto direito (o padrão).
          actionsAlignment: .center,
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Acompanhar pedido'),
            ),
          ],
        );
      },
    );
  }
}
