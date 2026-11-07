// exemplo_03_await_retorno_inicio.dart
// Ponto de partida: um carrinho que precisa da forma de pagamento. Tocar em
// "Escolher pagamento" abre a tela com as opções — push comum, como nos blocos
// anteriores.
//
// ! Rode e faça o fluxo inteiro: toque em "Escolher pagamento", toque em "Pix",
// ! e volte para o carrinho.
//
// ! **Continua dizendo "Pagamento: Nenhuma".**
//
// ! A escolha do usuário aconteceu, o `onTap` do "Pix" rodou — e o valor morreu
// ! ali. A tela de pagamento saiu da pilha levando a informação junto.
//
// ? Nos blocos anteriores os dados andaram **para frente** (da lista para o
// ? detalhe), o que era fácil: bastou um parâmetro de construtor. Agora eles
// ? precisam voltar, e o construtor não serve — a tela do carrinho já foi
// ? construída bem antes.
// ?
// ? A pista está no que o `Navigator.push` devolve. Olhe o tipo de retorno dele
// ? — a resposta está lá, e não é `void`.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaCarrinho()));

class TelaCarrinho extends StatefulWidget {
  const TelaCarrinho({super.key});

  @override
  State<TelaCarrinho> createState() => _TelaCarrinhoState();
}

class _TelaCarrinhoState extends State<TelaCarrinho> {
  // ! O analisador percebe o problema antes de você. Este campo está sublinhado
  // ! com um aviso do `flutter analyze`:
  // !
  // !     The private field _formaPagamento could be 'final'.
  // !     (prefer_final_fields)
  // !
  // ! Ele está certo: **nada nunca escreve neste campo**. É a mesma coisa que a
  // ! tela mostra — o valor escolhido não volta, então não há o que guardar.
  // ! Temos um StatefulWidget esperando um estado que nunca muda.
  var _formaPagamento = 'Nenhuma';

  Future<void> _escolherPagamento() async {
    // ! Empurra a tela e segue a vida. Nada é esperado, nada volta.
    final escolha = await Navigator.push(
      context,
      MaterialPageRoute(builder: (novoContext) => const TelaPagamento()),
    );

    if (!mounted) return;

    if (escolha != null) {
      setState(() {
        _formaPagamento = escolha;
      });
    } else {
      setState(() {
        _formaPagamento = 'Nenhuma';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Carrinho')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Pagamento: $_formaPagamento'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _escolherPagamento,
              child: const Text('Escolher pagamento'),
            ),
          ],
        ),
      ),
    );
  }
}

class TelaPagamento extends StatelessWidget {
  const TelaPagamento({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Formas de pagamento')),
      body: ListView(
        children: [
          for (final forma in const ['Pix', 'Cartão', 'Boleto'])
            ListTile(
              title: Text(forma),
              // ! Fecha a tela — e só. O `forma` escolhido não vai a lugar
              // ! nenhum.
              onTap: () => Navigator.pop(context, forma),
            ),
        ],
      ),
    );
  }
}
