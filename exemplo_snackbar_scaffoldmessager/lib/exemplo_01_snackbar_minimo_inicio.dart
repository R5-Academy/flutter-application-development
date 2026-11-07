// exemplo_01_snackbar_minimo_inicio.dart
// Ponto de partida: salvar o perfil e avisar que deu certo — com o
// `AlertDialog` que a seção ensinou.
//
// ! Salve três vezes seguidas. A cada uma, a tela **para**, escurece, e você
// ! precisa tocar em OK para voltar ao que estava fazendo.
//
// ! Para confirmar algo que **já deu certo**, isso é caro demais. A pessoa não
// ! tem decisão nenhuma a tomar — o diálogo só cobra um toque para dizer "ok,
// ! eu vi".
//
// ? Existe um aviso que **não interrompe**: aparece, informa e sai sozinho.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaMinimo()));

class TelaMinimo extends StatelessWidget {
  const TelaMinimo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SnackBar: o mínimo')),
      body: Center(
        child: FilledButton(
          onPressed: () {
            // ! Interrompe e cobra um toque para algo que já aconteceu.
            showDialog<void>(
              context: context,
              builder: (dialogContext) => AlertDialog(
                content: const Text('Perfil salvo com sucesso!'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          },
          child: const Text('Salvar perfil'),
        ),
      ),
    );
  }
}
