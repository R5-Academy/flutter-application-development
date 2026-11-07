// exemplo_03_barrier_dismissible_inicio.dart
// Ponto de partida: o aceite dos termos de uso. O diálogo devolve `bool` e o
// `?? false` trata o null, exatamente como o bloco anterior ensinou.
//
// ! Agora toque em "Ler termos" e, em vez de escolher, **toque no fundo
// ! escurecido**. O diálogo fecha, o Future completa com `null`, o `?? false`
// ! traduz para "recusou" — e a tela registra que a pessoa **recusou os
// ! termos**.
//
// ! Ela não recusou. Ela tocou fora sem querer, ou apertou "voltar" por reflexo.
// ! E acabou de ser tratada como quem disse não a um contrato.
//
// ? O `?? false` está certo — na dúvida, não faça. O problema é a dúvida
// ? existir: há decisões em que **não pode haver saída sem resposta**.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaObrigatoria()));

class TelaObrigatoria extends StatefulWidget {
  const TelaObrigatoria({super.key});

  @override
  State<TelaObrigatoria> createState() => _TelaObrigatoriaState();
}

class _TelaObrigatoriaState extends State<TelaObrigatoria> {
  var _status = 'Termos ainda não respondidos';

  Future<void> _pedirAceite() async {
    final aceitou = await showDialog<bool>(
      context: context,
      // ! O padrão é `true`: tocar no fundo fecha e devolve null.
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Termos de uso'),
          content: const Text(
            'Você precisa aceitar os termos para continuar usando o app.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Recusar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Aceito'),
            ),
          ],
        );
      },
    );

    if (!mounted) return;

    setState(() {
      _status = (aceitou ?? false) ? 'Termos aceitos' : 'Termos recusados';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Termos')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilledButton(
              onPressed: _pedirAceite,
              child: const Text('Ler termos'),
            ),
            const SizedBox(height: 24),
            Text(_status),
          ],
        ),
      ),
    );
  }
}
