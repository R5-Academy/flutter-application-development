// exemplo_02_canpop_inicio.dart
// Ponto de partida: um botão "Voltar" reaproveitável, para usar em qualquer
// tela do app. Ele chama `Navigator.pop` — exatamente o que o bloco anterior
// ensinou.
//
// * Rode e abra "Detalhes". O botão faz o esperado: tira a tela do topo e
// * devolve a inicial. Nesta tela ele é perfeito.
//
// ! Agora toque no MESMO botão na tela inicial — que é o que acontece com
// ! qualquer componente reaproveitável, mais cedo ou mais tarde.
// !
// !   **A tela some e o app fica preto.**
// !
// ! Não há erro vermelho, não há exceção, não há log. Medido: o `pop` remove a
// ! rota raiz como removeria qualquer outra, o `Navigator` fica com zero rotas
// ! e **nenhum pixel é pintado** (alfa 0 no centro da tela).
// !
// ! O que você vê no lugar é o fundo da janela nativa, e ele depende do tema do
// ! aparelho: **preto** no modo escuro (`values-night/styles.xml` usa
// ! `Theme.Black.NoTitleBar`) e branco no modo claro (`values/styles.xml`, com
// ! `Theme.Light.NoTitleBar`). O app não fechou — ele ficou sem nada na tela.
//
// ! É o pior tipo de defeito: silencioso. O botão funciona em toda tela
// ! empilhada e mata o app justamente na única em que não há para onde voltar.
//
// ? O botão não sabe onde está. Como perguntar ao `Navigator`, antes de
// ? oferecer a ação, se existe alguma tela embaixo desta?

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaInicial()));

class TelaInicial extends StatelessWidget {
  const TelaInicial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tela inicial (raiz)')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Não há nenhuma tela embaixo desta.'),
            const SizedBox(height: 24),
            ElevatedButton(
              child: const Text('Abrir detalhes'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (novoContext) => const TelaDetalhes(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            // ! O mesmo botão da tela de detalhes, agora na raiz.
            const BotaoVoltar(),
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
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes')),
      body: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('A tela inicial está embaixo desta.'),
            SizedBox(height: 24),
            BotaoVoltar(),
          ],
        ),
      ),
    );
  }
}

// Um botão de voltar reaproveitável — que não sabe onde está.
class BotaoVoltar extends StatelessWidget {
  const BotaoVoltar({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      // ! pop cru: na raiz, esvazia a pilha e deixa o app sem nada na tela.
      onPressed: () => Navigator.pop(context),
      child: const Text('Voltar'),
    );
  }
}
