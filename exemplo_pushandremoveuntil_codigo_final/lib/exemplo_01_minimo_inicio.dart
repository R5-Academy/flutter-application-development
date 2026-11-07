// exemplo_01_minimo_inicio.dart
// Ponto de partida: três telas empilhadas (A -> B -> C) e, no C, um botão que
// deveria levar para o D **limpando tudo o que veio antes**.
//
// * O método já está certo: `pushAndRemoveUntil`. Nesta forma —
// * `Navigator.of(context).pushAndRemoveUntil(...)` — ele recebe **duas** coisas:
// * a rota nova e um **predicate**, que decide o que fazer com o que já está na
// * pilha. (Na forma estática, `Navigator.pushAndRemoveUntil(context, rota,
// * predicate)`, o `context` entra como primeiro argumento; é a mesma chamada,
// * como a aula 02 mostrou para o `push`.)
//
// ! O predicate aqui é `(route) => true`. Parece o valor razoável: *"sim,
// ! remova"*.
//
// ! Rode: empilhe até o C, toque no botão, chegue no D — e olhe a AppBar. **A
// ! seta de voltar continua lá.** Volte e você encontra o C, o B, o A. Nada foi
// ! removido; o método se comportou como um `push` comum.
//
// ? O predicate não responde *"remover?"*. Ele responde outra pergunta — e é
// ? por isso que `true` deu no oposto do esperado.
// ?
// ? Olhe o nome do método com atenção: push and remove **until**. Até quando?

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaA()));

class TelaA extends StatelessWidget {
  const TelaA({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tela A')),
      body: Center(
        child: FilledButton(
          onPressed: () =>
              Navigator.of(context)
                  .push(MaterialPageRoute<void>(builder: (_) => const TelaB())),
          child: const Text('Ir para B'),
        ),
      ),
    );
  }
}

class TelaB extends StatelessWidget {
  const TelaB({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tela B')),
      body: Center(
        child: FilledButton(
          onPressed: () =>
              Navigator.of(context)
                  .push(MaterialPageRoute<void>(builder: (_) => const TelaC())),
          child: const Text('Ir para C'),
        ),
      ),
    );
  }
}

class TelaC extends StatelessWidget {
  const TelaC({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tela C')),
      body: Center(
        child: FilledButton(
          onPressed: () {
            // ! O predicate `(route) => true` não remove nada.
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute<void>(builder: (_) => const TelaD()),
              (route) {
                debugPrint(route.toString());
                return false;
              },
            );
          },
          child: const Text('Ir para D limpando a pilha'),
        ),
      ),
    );
  }
}

class TelaD extends StatelessWidget {
  const TelaD({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tela D')),
      body: Center(
        child: Text(
          Navigator.canPop(context)
              ? 'canPop: true — ainda há telas embaixo desta.'
              : 'canPop: false — a pilha foi limpa: não há para onde voltar.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
