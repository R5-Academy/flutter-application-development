// exemplo_02_confirmacao_inicio.dart
// Ponto de partida: um diálogo de confirmação antes de enviar o formulário.
// Tem título, texto e os dois botões no padrão certo.
//
// ! Toque em "Enviar" e escolha **Cancelar**. O formulário é enviado do mesmo
// ! jeito.
//
// ! Olhe os dois `onPressed`: os dois chamam `pop()`, sem argumento. Do ponto de
// ! vista de quem chamou o diálogo, "Cancelar" e "Confirmar" são **a mesma
// ! coisa** — os dois só fecham.
//
// ? Um diálogo de confirmação existe para trazer uma resposta. Como o valor
// ? escolhido volta para quem perguntou?

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaConfirmacao()));

class TelaConfirmacao extends StatefulWidget {
  const TelaConfirmacao({super.key});

  @override
  State<TelaConfirmacao> createState() => _TelaConfirmacaoState();
}

class _TelaConfirmacaoState extends State<TelaConfirmacao> {
  var _resultado = 'Nenhuma escolha ainda';

  void _confirmarEnvio() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Enviar formulário?'),
          content: const Text('Confira os dados antes de enviar.'),
          actions: [
            // ! pop() sem valor: fecha e não conta nada a ninguém.
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );

    // ! Roda logo depois de ABRIR o diálogo, sem esperar a escolha.
    setState(() => _resultado = 'Formulário enviado!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Confirmação')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilledButton(
              onPressed: _confirmarEnvio,
              child: const Text('Enviar'),
            ),
            const SizedBox(height: 24),
            Text(_resultado),
          ],
        ),
      ),
    );
  }
}
