// exemplo_01_menu_de_acoes_inicio.dart
// Ponto de partida: o menu de ações de um post — compartilhar, editar, excluir
// — resolvido com o `SimpleDialog` da aula passada.
//
// Funciona. Mas repare em duas coisas ao abrir:
//
// ! 1. O painel aparece **no meio da tela**, longe do polegar. Num celular
// !    grande, a pessoa precisa reposicionar a mão para tocar em qualquer opção.
// ! 2. Ele surge do nada, no centro, com a mesma cara de um alerta — e este
// !    menu não é um alerta: é uma gaveta de ações do item que ela tocou.
//
// ? Em todo app moderno, esse tipo de menu **sobe da base da tela**. Não é
// ? enfeite: é onde a mão está.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: MenuDeAcoes()));

class MenuDeAcoes extends StatefulWidget {
  const MenuDeAcoes({super.key});

  @override
  State<MenuDeAcoes> createState() => _MenuDeAcoesState();
}

class _MenuDeAcoesState extends State<MenuDeAcoes> {
  var _ultimaAcao = 'Nenhuma ação ainda';

  Future<void> _abrirMenu() async {
    // ! Um diálogo centralizado para um menu de ações.
    final acao = await showModalBottomSheet<String>(
      context: context,
      builder: (dialogContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: .min,
            children: [
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Compartilhar'),
                onTap: () => Navigator.pop(dialogContext, 'compartilhar'),
              ),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Editar'),
                onTap: () => Navigator.pop(dialogContext, 'editar'),
              ),
              Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Excluir'),
                onTap: () => Navigator.pop(dialogContext, 'excluir'),
              ),
            ],
          ),
        );
      },
    );

    if (!mounted) return;
    if (acao != null) {
      setState(() => _ultimaAcao = 'Você escolheu: $acao');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menu de ações')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilledButton(
              onPressed: _abrirMenu,
              child: const Text('Abrir menu'),
            ),
            const SizedBox(height: 24),
            Text(_ultimaAcao),
          ],
        ),
      ),
    );
  }
}
