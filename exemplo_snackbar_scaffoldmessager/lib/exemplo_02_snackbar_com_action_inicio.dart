// exemplo_02_snackbar_com_action_inicio.dart
// Ponto de partida: a mensagem foi enviada, e o SnackBar confirma.
//
// ! Agora imagine que a pessoa clicou em "Enviar" por engano — no destinatário
// ! errado, com o texto pela metade. O aviso aparece, confirma o erro, e some.
//
// ! O que sobra para ela? Nada. Ela viu o problema acontecer e não teve como
// ! reagir. Vai ter que abrir a conversa, achar a mensagem e apagar — se der
// ! tempo.
//
// ? Aquela barrinha fica quatro segundos na tela sem fazer nada além de
// ? informar. Dá para oferecer uma saída ali mesmo?

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaComAction()));

class TelaComAction extends StatelessWidget {
  const TelaComAction({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SnackBar com ação')),
      body: Center(
        child: FilledButton(
          onPressed: () {
            // ! Informa e pronto: a pessoa assiste ao erro passar.
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Mensagem enviada')));
          },
          child: const Text('Enviar mensagem'),
        ),
      ),
    );
  }
}
