// exemplo_04_painel_travado_inicio.dart
// Ponto de partida: o aceite dos termos, agora num bottom sheet — com os dois
// botões e o retorno tratado.
//
// ! Abra o painel e, em vez de escolher, **arraste-o para baixo**. Ou toque na
// ! área escura. Ele fecha, o Future vem `null`, e a tela registra "Termos
// ! recusados".
//
// ! É o mesmo problema do `barrierDismissible` da aula de AlertDialog — só que
// ! aqui existem **duas** saídas por acidente, não uma: tocar fora **e**
// ! arrastar. E arrastar é ainda mais fácil de fazer sem querer, porque o gesto
// ! é o mesmo de rolar a tela.
//
// ? O sheet tem um parâmetro para cada uma dessas saídas.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: PainelTravado()));

class PainelTravado extends StatefulWidget {
  const PainelTravado({super.key});

  @override
  State<PainelTravado> createState() => _PainelTravadoState();
}

class _PainelTravadoState extends State<PainelTravado> {
  var _resultado = 'Aguardando decisão';

  Future<void> _confirmar() async {
    final aceitou = await showModalBottomSheet<bool>(
      context: context,
      // ! Nada trava: tocar fora fecha, arrastar fecha.
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Aceitar os termos?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () => Navigator.pop(sheetContext, true),
                  child: const Text('Aceito'),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () => Navigator.pop(sheetContext, false),
                  child: const Text('Recuso'),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (!mounted) return;
    setState(() {
      _resultado = aceitou == true ? 'Termos aceitos' : 'Termos recusados';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Painel travado')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_resultado, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _confirmar,
              child: const Text('Abrir confirmação'),
            ),
          ],
        ),
      ),
    );
  }
}
