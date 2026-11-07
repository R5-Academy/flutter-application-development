// exemplo_02_shape_e_aparencia_inicio.dart
// Ponto de partida: o painel do bloco anterior, no visual **padrão** do
// `showModalBottomSheet` — sem uma linha de aparência.
//
// * E o padrão já é bom. Lido no SDK 3.44.6 (tema M3, que é o default desde o
// * Flutter 3.16):
// *   cantos de cima arredondados em 28   (bottom_sheet.dart:1488)
// *   fundo = colorScheme.surfaceContainerLow (bottom_sheet.dart:1496)
// *   elevação 1, sem sombra e sem tint   (bottom_sheet.dart:1486, 1499, 1502)
// * Ou seja: você NÃO precisa escrever `shape` nem `backgroundColor` para o
// * painel ter cara de app.
//
// ! O que o padrão **não** te dá é a alcinha cinza no topo. Ela vem desligada —
// ! `showDragHandle` cai em `false` (bottom_sheet.dart:363) — e sem ela nada na
// ! tela conta que o painel pode ser arrastado para baixo. O gesto existe desde
// ! o bloco 1; quem não o conhece procura um botão de fechar que não existe.
//
// ? Um parâmetro resolve isso. E a lição maior do bloco é a que você acabou de
// ? ler aqui em cima: procure o default **antes** de escrever o parâmetro.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: ShapeEAparencia()));

class ShapeEAparencia extends StatelessWidget {
  const ShapeEAparencia({super.key});

  Future<void> _abrir(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      // ! Nenhum ajuste de aparência: o tema decide tudo — e não há alça.
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ajuste rápido',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'O painel já sobe arredondado e com a cor do tema. Só que '
                  'nada aqui diz que dá para arrastá-lo para baixo.',
                  style: TextStyle(
                    color: Theme.of(sheetContext).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => Navigator.pop(sheetContext),
                  child: const Text('Entendi'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aparência do sheet')),
      body: Center(
        child: FilledButton(
          onPressed: () => _abrir(context),
          child: const Text('Abrir painel'),
        ),
      ),
    );
  }
}
