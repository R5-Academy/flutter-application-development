// exemplo_01_pop_basico_inicio.dart
// Ponto de partida: duas telas, e a de detalhes tem um botão "Voltar". Com a
// aula anterior na cabeça, a ferramenta óbvia para "ir para uma tela" é o
// `push` — então o botão empurra a tela inicial de volta.
//
// * Rode. **Funciona**: o botão leva para a tela inicial.
//
// ! Agora faça o teste que revela o problema. Vá e volte **três vezes**:
// !
// !   inicial -> detalhes -> inicial -> detalhes -> inicial
// !
// ! Olhe o placar da tela inicial. Ele começa dizendo **"sou a raiz da pilha"**
// ! e, depois da primeira ida e volta, passa a dizer **"há telas embaixo de
// ! mim"** — porque esta não é mais a tela inicial de verdade. É uma cópia,
// ! empilhada em cima da anterior. A setinha na AppBar aparece pelo mesmo
// ! motivo.
// !
// ! E agora aperte o botão de voltar do Android (ou a setinha) várias vezes:
// ! você atravessa **todas** as telas que empilhou, uma por uma, antes de o app
// ! finalmente fechar.
//
// ! É que `push` só sabe fazer uma coisa: **empilhar**. Cada "voltar" adicionou
// ! uma tela nova em cima, em vez de tirar. A pilha só cresce — e o `Navigator`
// ! mantém **viva** cada rota empilhada, com o `State` dela inteiro. Ninguém
// ! nunca desempilha, então nada disso é liberado enquanto o app existir.
//
// ? Se `push` empilha, existe a operação inversa. Qual é o nome dela numa pilha?

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaInicial()));

class TelaInicial extends StatelessWidget {
  const TelaInicial({super.key});

  @override
  Widget build(BuildContext context) {
    // * O placar da aula: canPop é false só para quem está no fundo da pilha.
    // * Numa tela chamada "inicial", ver isto virar true é o próprio defeito.
    final temAlguemEmbaixo = Navigator.canPop(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Tela inicial')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              temAlguemEmbaixo
                  ? 'canPop: true — há telas embaixo de mim.\n'
                        'Não sou a tela inicial: sou uma cópia empilhada.'
                  : 'canPop: false — sou a raiz da pilha.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              child: const Text('Abrir detalhes'),
              onPressed: () {
                // push empurra a segunda tela para o topo da pilha (aula
                // anterior).
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (novoContext) => const TelaDetalhes(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TelaDetalhes extends StatelessWidget {
  const TelaDetalhes({super.key});

  @override
  Widget build(BuildContext context) {
    // * A AppBar já coloca uma seta de voltar automaticamente. Ela chama
    // * Navigator.maybePop por baixo dos panos — voltar "de graça" já funciona.
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes')),
      body: Center(
        child: ElevatedButton(
          child: const Text('Voltar'),
          onPressed: () {
            // ! "Voltar" empurrando outra tela: a pilha só cresce.
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
