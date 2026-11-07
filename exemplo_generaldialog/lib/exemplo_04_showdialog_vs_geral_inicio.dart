// exemplo_04_showdialog_vs_geral_inicio.dart
// Ponto de partida: depois de aprender o `showGeneralDialog`, a tentação é
// usá-lo para tudo. Este arquivo faz isso — inclusive para um **alerta comum**,
// daqueles com título, texto e um "Ok".
//
// ! Conte as linhas. Para chegar no comportamento que o `showDialog` dá de
// ! graça, foi preciso configurar **quatro coisas** na mão:
// !   barrierDismissible, barrierLabel, barrierColor, transitionDuration
// !   (mais o transitionBuilder)
// !
// ! E cada uma é uma chance de errar: esquecer o `barrierLabel` quebra o app;
// ! escolher outro tom de preto deixa este diálogo diferente dos demais; mudar
// ! a duração faz ele destoar da animação padrão.
//
// ! E, mesmo com os quatro no lugar, ainda **não** ficou igual: falta a
// ! `SafeArea`, falta a curva `easeOut` do fade e falta o tema herdado do
// ! local da chamada. O bloco 4 mede cada um desses.
//
// ? Ferramenta poderosa não é ferramenta melhor. Quando cada uma serve?

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaComparacao()));

class TelaComparacao extends StatelessWidget {
  const TelaComparacao({super.key});

  // ! Um alerta comum, feito na versão crua.
  Future<void> _alertaComum(BuildContext context) {
    return showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 150),
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        return AlertDialog(
          title: const Text('Perfil salvo'),
          content: const Text('Suas alterações foram salvas.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Ok'),
            ),
          ],
        );
      },
      transitionBuilder: (dialogContext, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Atalho × versão crua')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Um alerta simples, escrito na versão crua.\n'
              'Conte quantos parâmetros foram necessários.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: () => _alertaComum(context),
              child: const Text('Abrir alerta'),
            ),
          ],
        ),
      ),
    );
  }
}
