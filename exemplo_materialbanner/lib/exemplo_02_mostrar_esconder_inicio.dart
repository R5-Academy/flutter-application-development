// exemplo_02_mostrar_esconder_inicio.dart
// Ponto de partida: o banner de "perfil incompleto", com um botão "AGORA NÃO".
//
// ! Toque em "Mostrar banner" e depois em "AGORA NÃO". O banner **continua
// ! lá**. Toque de novo. Continua.
//
// ! O `onPressed` da ação está vazio: ele não faz nada. E, como o banner não
// ! some sozinho, o aviso virou permanente — a pessoa perdeu 54 px do topo da
// ! tela para sempre (medido: banner de uma ação, com ou sem `leading`).
//
// ! Não adianta arrastar: diferente do SnackBar, que sai com um arrasto para
// ! baixo, o banner ignora o gesto (medido: continua na árvore).
//
// ? Quem **tira** o banner da tela é você. E existem duas formas de fazer isso,
// ? com efeitos visuais diferentes.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: MostrarEsconderPage()));

class MostrarEsconderPage extends StatelessWidget {
  const MostrarEsconderPage({super.key});

  void _mostrar(BuildContext context) {
    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        leading: const Icon(Icons.warning_amber),
        backgroundColor: Colors.amber.shade100,
        content: const Text('Seu perfil está incompleto.'),
        actions: [
          // ! Não faz nada: o banner fica para sempre.
          TextButton(onPressed: () {}, child: const Text('AGORA NÃO')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mostrar / esconder')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Mostre o banner e toque em "AGORA NÃO". Ele não sai.',
                textAlign: TextAlign.center,
              ),
            ),
            ElevatedButton(
              onPressed: () => _mostrar(context),
              child: const Text('Mostrar banner'),
            ),
          ],
        ),
      ),
    );
  }
}
