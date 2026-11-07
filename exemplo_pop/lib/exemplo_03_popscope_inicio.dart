// exemplo_03_popscope_inicio.dart
// Ponto de partida: o mesmo `BotaoVoltar` do bloco anterior, já consertado — ele
// pergunta com `canPop` e não apaga mais o app. Agora ele vai para uma tela de
// verdade: um rascunho não salvo, protegido por um `PopScope` que pergunta
// "Descartar alterações?" antes de deixar sair.
//
// * Comece **provando que a proteção funciona**: abra o rascunho e saia pela
// * **setinha da AppBar**. O diálogo aparece, e "Continuar editando" segura você
// * na tela. (Medido.) O botão de voltar do Android faz a mesma coisa.
//
// ! Agora saia pelo botão "Voltar" que nós escrevemos, na mesma tela.
// !
// !   **O rascunho some. Sem diálogo, sem pergunta, sem chance de cancelar.**
// !
// ! Não é bug do `PopScope`. Medido: `Navigator.pop` **arranca** a rota do topo
// ! sem consultar ninguém. O `PopScope` até é avisado — mas depois do fato, com
// ! `didPop == true`. A tela já saiu; não há mais o que cancelar.
//
// ! O resultado é um app incoerente: a mesma tela protege uma saída e deixa a
// ! outra passar, dependendo de por onde o usuário resolveu sair.
//
// ? A setinha da AppBar não chama `pop`. O que ela chama, então — e como isso
// ? consegue perguntar à rota antes de arrancá-la?

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaInicial()));

class TelaInicial extends StatelessWidget {
  const TelaInicial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tela inicial (raiz)')),
      body: Center(
        child: ElevatedButton(
          child: const Text('Abrir rascunho'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (novoContext) => const TelaRascunho()),
            );
          },
        ),
      ),
    );
  }
}

class TelaRascunho extends StatelessWidget {
  const TelaRascunho({super.key});

  @override
  Widget build(BuildContext context) {
    // * canPop: false = esta rota não sai sozinha. Toda tentativa de saída que
    // * PERGUNTE à rota cai no callback abaixo, e é ele quem decide.
    return PopScope<void>(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        // ! didPop == true significa "a rota JÁ saiu" — não há o que perguntar.
        if (didPop) return;

        final descartar = await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('Descartar alterações?'),
            content: const Text('O rascunho ainda não foi salvo.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text('Continuar editando'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: const Text('Descartar'),
              ),
            ],
          ),
        );

        if (!context.mounted) return;
        if (descartar ?? false) {
          // * Aqui o pop cru é o certo: a decisão de sair já foi tomada, e ele é
          // * justamente o único que atravessa o canPop: false.
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Rascunho')),
        body: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Alterações não salvas.'),
              SizedBox(height: 24),
              BotaoVoltar(),
            ],
          ),
        ),
      ),
    );
  }
}

// O botão do bloco anterior, sem uma vírgula de mudança.
class BotaoVoltar extends StatelessWidget {
  const BotaoVoltar({super.key});

  @override
  Widget build(BuildContext context) {
    final podeVoltar = Navigator.canPop(context);

    return ElevatedButton(
      // ! pop cru: atravessa o PopScope sem nem perguntar.
      onPressed: podeVoltar ? () => Navigator.pop(context) : null,
      child: const Text('Voltar'),
    );
  }
}
