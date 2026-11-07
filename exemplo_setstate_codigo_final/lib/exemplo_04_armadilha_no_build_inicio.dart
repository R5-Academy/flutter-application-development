// exemplo_04_armadilha_no_build_inicio.dart
// Ponto de partida: o carrinho precisa avisar "frete grátis" assim que abre, e
// avisar também o selo que mostra a condição de frete. A intenção é razoável, e
// a implementação parece natural: se o `build` é o lugar onde a tela se monta, é
// ali que se avisa.
//
// * São duas tentativas, e elas terminam **diferente**. Rode e compare.
//
// ! Tentativa 1 — `setState` no **próprio** `build`. **Não dá erro nenhum.** A
// ! tela abre mostrando "frete grátis", e o contador de builds marca **1**.
// !
// ! Parece que funcionou. Não funcionou: o `setState` ali foi **descartado**. O
// ! framework ignora, de propósito, o pedido de rebuild vindo do widget que ele
// ! está construindo naquele instante. Está escrito no SDK, em `framework.dart`
// ! (`ComponentElement.performRebuild`):
// !
// !     // We delay marking the element as clean until after calling build()
// !     // so that attempts to markNeedsBuild() during build() will be ignored.
// !
// ! Ou seja: **não** existe o laço infinito que a lenda promete — o pedido é
// ! engolido. "frete grátis" só apareceu porque a **atribuição** dentro do
// ! callback é síncrona e aconteceu antes de o `Text` ser criado. O `setState`
// ! não serviu para nada, e num rebuild futuro continuará não servindo.
//
// ! Tentativa 2 — avisar **outro** widget. O `_SeloDeFrete` chama, no `build`
// ! dele, um callback que faz `setState` **na tela** (que está acima na
// ! árvore). Aí sim: **caixa vermelha** no lugar do selo, com
// !
// !     setState() or markNeedsBuild() called during build.
// !
// ! A mensagem completa explica o motivo: o framework constrói pai antes de
// ! filho, então marcar um **ancestral** já construído significaria pedir para
// ! refazer algo que ficou para trás nesta passada.
//
// ? A regra que sai das duas: o `build` **não avisa ninguém** — nem a si mesmo
// ? (é ignorado), nem os outros (é erro). O bloco 1 já tinha dito: dispare
// ? `setState` a partir de um **evento**. O `build` não é um evento; é a
// ? resposta a um.
// ?
// ? Mas a necessidade aqui é legítima: e quando você **precisa mesmo** reagir
// ? logo depois que a tela apareceu?

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaDoCarrinho()));

class TelaDoCarrinho extends StatefulWidget {
  const TelaDoCarrinho({super.key});

  @override
  State<TelaDoCarrinho> createState() => _TelaDoCarrinhoState();
}

class _TelaDoCarrinhoState extends State<TelaDoCarrinho> {
  var _frete = 'calculando frete...';
  var _builds = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Future.delayed(Duration(seconds: 2));
      setState(() => _frete = 'frete grátis');
    });
  }

  @override
  Widget build(BuildContext context) {
    _builds++;

    return Scaffold(
      appBar: AppBar(title: const Text('Carrinho')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_frete, style: Theme.of(context).textTheme.headlineMedium),
            Text('builds: $_builds'),
            const SizedBox(height: 24),
            SizedBox(height: 120, child: _SeloDeFrete(condicao: _frete)),
            FilledButton(
              onPressed: () {
                setState(() {
                  _frete = 'frete recalculado';
                });
              },
              child: Text('Recalculando frete'),
            ),
          ],
        ),
      ),
    );
  }
}

class const _SeloDeFrete({required final String condicao})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('entrega: $condicao');
  }
}
