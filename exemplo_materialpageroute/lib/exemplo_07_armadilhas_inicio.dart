// exemplo_07_armadilhas_inicio.dart
// Ponto de partida: o botão "Abrir destino" foi escrito com o que o bloco 1
// mostrou — a rota como um objeto, numa variável.
//
// * O código compila. O analisador não reclama de nada. O app roda.
//
// ! Toque no botão. **Nada acontece.**
//
// ! Nenhum erro, nenhuma tela vermelha, nenhuma mensagem no console. O toque é
// ! registrado, a linha executa, e a tela continua onde estava.
//
// ! E olhe o editor: a variável `rota` está **sublinhada**. O analisador avisa
// ! `unused_local_variable` — "esta variável não é usada".
// !
// ! Ele está certo, e é a pista exata: a rota foi criada e **ninguém fez nada
// ! com ela**. Um aviso que é fácil ignorar como "chatice do linter" é, aqui, o
// ! diagnóstico do bug.
//
// ? Olhe a função do `onPressed` e pergunte o que ela realmente faz. Ela cria um
// ? objeto e o guarda numa variável local. Depois a função termina, e a
// ? variável some.
//
// ? O bloco 1 já tinha avisado, em outras palavras: **criar a rota e navegar são
// ? dois passos**. Aqui só o primeiro foi escrito.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: HomeScreen()));

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Armadilhas')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 16,
          children: [
            ElevatedButton(
              onPressed: () {
                // ! A rota é criada... e fica só nisso. Repare no sublinhado.
                final rota = MaterialPageRoute<void>(
                  builder: (novoContext) => const DestinoScreen(),
                );
              },
              child: const Text('Criar a rota e então dar push'),
            ),
            ElevatedButton(
              onPressed: () {
                // * O caminho de sempre, para comparar: aqui a rota é criada
                // * dentro do próprio push, e o botão funciona.
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (novoContext) => const DestinoScreen(),
                  ),
                );
              },
              child: const Text('Direto no push (o jeito de sempre)'),
            ),
          ],
        ),
      ),
    );
  }
}

class DestinoScreen extends StatelessWidget {
  const DestinoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Destino')),
      body: const Center(child: Text('Cheguei aqui pelo push.')),
    );
  }
}
