// exemplo_03_fullscreen_dialog_inicio.dart
// Ponto de partida: uma lista de produtos com um FAB que abre a tela de "novo
// produto". Push comum, como sempre.
//
// * Rode e toque no "+". A tela entra com a transição normal da plataforma
// * (deslizando da direita no iPhone; com fade + deslize no Android), e a AppBar
// * mostra a **seta de voltar**.
//
// ! Compare com o que os apps do seu celular fazem nesse mesmo momento. Criar
// ! um e-mail, adicionar um contato, escrever um post: em todos, a tela traz um
// ! **X** no canto, não uma seta (e no iPhone ela ainda **sobe de baixo**).
//
// ! A diferença não é decorativa. Ela comunica duas coisas diferentes:
// !
// !   seta  ->  "você está **navegando** — foi para um lugar mais fundo"
// !   X     ->  "você está numa **tarefa** — termine ou cancele"
// !
// ! Com a seta, o usuário lê a tela como parte da navegação e espera que voltar
// ! seja inofensivo. Numa tela com formulário preenchido, essa expectativa está
// ! errada.
//
// ? Isso não se resolve trocando o ícone na mão. É um **parâmetro do
// ? `MaterialPageRoute`** — e quem lê esse parâmetro para decidir o ícone não é
// ? a rota nem o `Scaffold`. Guarde a pergunta: **quem desenha esse botão?**

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: HomeScreen()));

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meus produtos')),
      body: const Center(child: Text('Nenhum produto ainda')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            // ! Rota comum: desliza da lateral e a AppBar põe a seta.
            MaterialPageRoute<void>(
              fullscreenDialog: true,
              builder: (novoContext) => const NovoProdutoScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class NovoProdutoScreen extends StatelessWidget {
  const NovoProdutoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo produto')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const TextField(decoration: InputDecoration(labelText: 'Nome')),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
