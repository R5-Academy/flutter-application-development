// exemplo_03_armadilha_cast_e_null_inicio.dart
// Ponto de partida: a mesma tela de detalhe pode ser aberta de **dois lugares**
// — o que é comum em app de verdade: pela lista (com o produto) e por um deep
// link ou atalho (sem nada).
//
// * Toque em "Abrir COM argumentos": funciona.
//
// ! Agora toque em "Abrir SEM argumentos".
// !
// !     type 'Null' is not a subtype of type 'ProdutoArgs' in type cast
// !
// ! **Tela vermelha.** O app quebrou.
//
// ! A culpa é da linha que vem sendo copiada desde o bloco 1:
// !
// !     ModalRoute.of(context)!.settings.arguments as ProdutoArgs
// !
// ! Ela contém **duas apostas**. Repare em qual delas quebrou:
// !   o `!` assume que existe uma rota modal — aqui existe, e ele passou;
// !   o `as ProdutoArgs` assume que `arguments` é daquele tipo. Como ele é
// !     `Object?`, veio `null` — e foi **este** que estourou.
//
// ! O `!` não é inocente, só não é a vez dele. Ele quebra quando a tela é
// ! construída **fora** de qualquer rota — num teste de widget, por exemplo —, e
// ! aí a mensagem é outra: `Null check operator used on a null value`. Uma linha
// ! só, duas apostas, dois crashes diferentes.
//
// ! O que torna isso perigoso é **quem** dispara o caminho ruim. Deep links,
// ! notificações e atalhos do sistema vêm **de fora do seu app** — você não
// ! controla o que eles mandam. O caminho feliz é o único que se testa à mão.
//
// ? Dá para ler o `arguments` de um jeito que trate nulo e tipo errado de uma
// ? vez, sem `if` aninhado?

import 'package:material_ui/material_ui.dart';

void main() {
  runApp(
    MaterialApp(
      routes: {
        '/': (context) => const HomeScreen(),
        '/detalhe': (context) => const DetalheScreen(),
      },
    ),
  );
}

class const ProdutoArgs({required final int id, required final String nome});

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 16,
          children: [
            ElevatedButton(
              // Caminho feliz: navegação interna, com o objeto certo.
              onPressed: () => Navigator.pushNamed(
                context,
                '/detalhe',
                arguments: const ProdutoArgs(id: 7, nome: 'Webcam Full HD'),
              ),
              child: const Text('Abrir COM argumentos'),
            ),
            OutlinedButton(
              // ! O que um deep link faria: a mesma rota, sem dado nenhum.
              onPressed: () => Navigator.pushNamed(context, '/detalhe'),
              child: const Text('Abrir SEM argumentos'),
            ),
          ],
        ),
      ),
    );
  }
}

class DetalheScreen extends StatelessWidget {
  const DetalheScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ! Duas apostas numa linha: o `!` e o `as`. Sem argumentos, quebra.
    final produto = ModalRoute.of(context)!.settings.arguments as ProdutoArgs;

    return Scaffold(
      appBar: AppBar(title: Text(produto.nome)),
      body: Center(child: Text('Código do produto: ${produto.id}')),
    );
  }
}

// A tela de recado para quando não veio produto nenhum. Ela existe desde o
// início: o que a aula acrescenta é a **guarda** que decide usá-la.
class TelaSemProduto extends StatelessWidget {
  const TelaSemProduto({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhe')),
      body: const Center(child: Text('Produto não informado')),
    );
  }
}
