// exemplo_03_ate_rota_nomeada_inicio.dart
// Ponto de partida: um checkout — Home -> Carrinho -> Pagamento. Ao confirmar,
// a tela de Sucesso aparece e o fluxo é descartado com `(route) => false`, que
// é o que o bloco anterior ensinou.
//
// * E o descarte funciona: o carrinho e o pagamento sumiram. O usuário não
// * consegue voltar e pagar duas vezes.
//
// ! Mas ele também não consegue voltar para a **Home**. Chegue no Sucesso: não
// ! há seta na AppBar, e no Android o voltar do sistema **fecha o app**.
//
// ! O `(route) => false` é literal — *"nunca pare de remover"*. Ele apagou o
// ! carrinho, o pagamento **e a Home**, que era a única tela que devia ficar.
// !
// !   antes:   [ Home, Carrinho, Pagamento ]
// !   depois:  [ Sucesso ]
// !   queria:  [ Home, Sucesso ]
//
// ! No logout, apagar tudo estava certo. Aqui, não: o usuário terminou uma
// ! compra, não saiu do aplicativo.
//
// ? O predicate é uma **função**, e até agora usamos duas constantes. Ele pode
// ? olhar cada rota e decidir. Mas para reconhecer a Home, ele precisa de algo
// ? que a identifique.

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
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => const CarrinhoPage(),
              settings: RouteSettings(name: '/carrinho'),
            ),
          ),
          child: const Text('Ir ao carrinho'),
        ),
      ),
    );
  }
}

class CarrinhoPage extends StatelessWidget {
  const CarrinhoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Carrinho')),
      body: Center(
        child: FilledButton(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => const PagamentoPage(),
              settings: RouteSettings(name: '/pagamento'),
            ),
          ),
          child: const Text('Ir ao pagamento'),
        ),
      ),
    );
  }
}

class PagamentoPage extends StatelessWidget {
  const PagamentoPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Pilha agora: Home -> Carrinho -> Pagamento.
    return Scaffold(
      appBar: AppBar(title: const Text('Pagamento')),
      body: Center(
        child: FilledButton(
          onPressed: () {
            // ! Apaga tudo — inclusive a Home, que devia ficar.
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute<void>(builder: (_) => const SucessoPage()),
              ModalRoute.withName('/'),
            );
          },
          child: const Text('Confirmar pagamento'),
        ),
      ),
    );
  }
}

class SucessoPage extends StatelessWidget {
  const SucessoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sucesso')),
      body: Center(
        child: Text(
          Navigator.canPop(context)
              ? 'canPop: true — sobrou tela embaixo. Voltar leva à Home.'
              : 'canPop: false — a pilha foi limpa: voltar fecha o app.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
