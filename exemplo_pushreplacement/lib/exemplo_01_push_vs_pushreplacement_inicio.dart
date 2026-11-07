// exemplo_01_push_vs_pushreplacement_inicio.dart
// Ponto de partida: duas telas e um `push` — tudo o que a aula de push ensinou.
//
// * Rode e vá para o destino. **Olhe a AppBar.**
//
// * Tem uma seta de voltar. E isso é exatamente o que deveria acontecer: a tela
// * de origem continua viva embaixo na pilha, esperando. Quem percebe isso e
// * desenha a seta é a **`AppBar`** — ela pergunta à rota
// * (`ModalRoute.impliesAppBarDismissal`) se existe algo embaixo.
//
// ? Mas nem todo fluxo quer isso. Pense em três telas de qualquer app:
// ?
// ?   um **splash** que carrega e vai para a home
// ?   um **login** que autentica e vai para a home
// ?   um **onboarding** que termina e vai para a home
// ?
// ? Nos três casos, a seta de voltar não faz sentido — ninguém quer voltar para
// ? o splash, e voltar para o login **já logado** é pior ainda.
//
// ? O que essas três situações têm em comum é que a tela de origem **terminou o
// ? seu trabalho**. Ela não deveria continuar na pilha. Existe uma operação para
// ? isso: em vez de empilhar por cima, **substituir**.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaOrigem()));

class TelaOrigem extends StatelessWidget {
  const TelaOrigem({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Origem')),
      body: Center(
        child: FilledButton(
          // ! push empilha: a Origem continua viva embaixo, então o Destino
          // ! ganha a seta de voltar automática.
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (novoContext) => const TelaDestino(),
            ),
          ),
          child: const Text('Ir para o destino'),
        ),
      ),
    );
  }
}

class TelaDestino extends StatelessWidget {
  const TelaDestino({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Destino')),
      body: Center(
        child: Text(
          Navigator.canPop(context)
              ? 'canPop: true — a tela anterior continua na pilha.'
              : 'canPop: false — a tela anterior saiu da pilha.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
