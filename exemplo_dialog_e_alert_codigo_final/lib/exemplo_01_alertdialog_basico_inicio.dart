// exemplo_01_alertdialog_basico_inicio.dart
// Ponto de partida: a tela de perfil avisa que salvou — com um `SnackBar`.
//
// Para "salvo com sucesso" isso costuma bastar. Mas imagine a mensagem sendo
// outra: *"não foi possível salvar: sua sessão expirou"*.
//
// ! Um SnackBar aparece por quatro segundos (o padrão do Flutter) e some
// ! sozinho. Se a pessoa estava olhando para o teclado, para o lado, ou rolando
// ! a tela, **ela nunca fica sabendo**. E segue achando que salvou.
//
// ? Existe informação que não pode depender de a pessoa estar olhando na hora
// ? certa. Como exigir que ela **reconheça** o aviso antes de continuar?
//
// * Fronteira: o SnackBar entra aqui só como **contraste**, para você ver o que
// * ele NÃO resolve — nada dele precisa ser escrito nesta aula. Ele é o assunto
// * da aula 4 desta seção (SnackBar e ScaffoldMessenger), que ensina duração,
// * ação de Desfazer e o ScaffoldMessenger.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaBasica()));

class TelaBasica extends StatelessWidget {
  const TelaBasica({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AlertDialog básico')),
      body: Center(
        child: FilledButton(
          onPressed: () {
            _mostrarAviso(context);
          },
          child: const Text('Mostrar aviso'),
        ),
      ),
    );
  }

  void _mostrarAviso(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Perfil Salvo'),
          content: Text('Suas alterações foram salvas com sucesso'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
