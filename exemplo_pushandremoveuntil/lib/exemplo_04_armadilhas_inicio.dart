// exemplo_04_armadilhas_inicio.dart
// Ponto de partida: o mesmo padrão do bloco anterior — descartar um fluxo e
// parar numa tela — aplicado num painel. A intenção é manter a Home.
//
// * O código parece certo: `pushAndRemoveUntil` com `ModalRoute.withName`,
// * exatamente como no bloco 3.
//
// ! Rode: abra o painel, toque em "Concluir" e olhe a tela de destino. **Não há
// ! seta de voltar.** A Home, que devia ter sido preservada, sumiu.
//
// ! São **dois** problemas que se somam, e nenhum dos dois avisa nada:
// !
// !   1. o nome procurado é `'/dashboard'`, e **ninguém na pilha se chama
// !      assim** — a Home é a rota do `home:`, cujo nome é `'/'`;
// !   2. o Painel foi empurrado **sem `settings`**, então nem ele tem nome.
// !
// ! Como o predicate nunca responde `true`, ele nunca para — e cai no caso
// ! `(route) => false`: **remove tudo**.
//
// ! O sintoma é traiçoeiro: você pediu para **manter** uma tela e o resultado é
// ! **perder todas**. E não há exceção, log ou aviso do analisador — o
// ! comportamento de "não encontrou" é indistinguível de "apague tudo".
// !
// ! Medido, partindo de [Home, Painel]: sobra **1** rota, `canPop()` = `false`,
// ! **0** setas e nenhuma exceção. Exatamente o mesmo que `(route) => false`.
//
// ? Como escrever isso de um jeito em que errar o nome não passe despercebido?

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: HomePage()));

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: FilledButton(
          // ! Sem settings: esta rota não tem nome.
          onPressed: () => Navigator.of(
            context,
          ).push(MaterialPageRoute<void>(builder: (_) => const PainelPage())),
          child: const Text('Abrir painel'),
        ),
      ),
    );
  }
}

class PainelPage extends StatelessWidget {
  const PainelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Painel')),
      body: Center(
        child: FilledButton(
          onPressed: () {
            // ! '/dashboard' não existe na pilha. O predicate nunca casa, e o
            // ! Navigator remove tudo — inclusive a Home.
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute<void>(builder: (_) => const DestinoPage()),
              ModalRoute.withName('/dashboard'),
            );
          },
          child: const Text('Concluir'),
        ),
      ),
    );
  }
}

class DestinoPage extends StatelessWidget {
  const DestinoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Destino')),
      body: Center(
        child: Text(
          Navigator.canPop(context)
              ? 'canPop: true — a Home ficou embaixo, como se pediu.'
              : 'canPop: false — a pilha foi esvaziada. A Home sumiu.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
