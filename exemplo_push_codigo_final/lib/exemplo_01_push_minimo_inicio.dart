// exemplo_01_push_minimo_inicio.dart
// Ponto de partida: um app com duas telas e a necessidade de sair de uma para a
// outra. Sem conhecer navegação, a saída natural é a ferramenta que você já tem
// há duas fases: **estado**.
//
// * Um `bool` diz qual tela mostrar, e o `setState` troca. Rode: funciona. A
// * tela de detalhes aparece.
//
// ! Agora tente **voltar**.
// !
// !   não há setinha na AppBar — foi preciso passar um callback de volta na mão
// !   no Android, o botão/gesto de voltar do sistema **fecha o app**
// !   a troca é instantânea, sem nenhuma animação
// !   e o app não tem nenhuma noção de "onde eu estava antes"
//
// ! O último item é o mais grave. Com três, quatro, dez telas encadeadas, esse
// ! `bool` vira um emaranhado de flags, e ninguém consegue responder "qual é o
// ! caminho de volta?".
//
// * Repare no que a própria tela de detalhes diz de si mesma. Ela pergunta ao
// * `Navigator` se existe alguma rota embaixo dela — e a resposta, aqui, é
// * **não**. Ela não é uma rota; é o mesmo widget de sempre com outro corpo.
//
// ? O Flutter tem uma estrutura para isso, e ela é literalmente uma **pilha**
// ? de telas. Trocar de tela vira empilhar; voltar vira desempilhar.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaInicial()));

class TelaInicial extends StatelessWidget {
  const TelaInicial({super.key});

  @override
  Widget build(BuildContext context) {
    // if (_mostrandoDetalhes) {
    //   // ! O caminho de volta é problema de quem mostrou a tela: sem alguém
    //   // ! passar este callback, não há como sair de lá.
    //   return TelaDetalhes(
    //     aoVoltar: () => setState(() => _mostrandoDetalhes = false),
    //   );
    // }

    return Scaffold(
      appBar: AppBar(title: const Text('Tela Inicial')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return TelaDetalhes();
                },
              ),
            );
          },
          child: const Text('Abrir detalhes'),
        ),
      ),
    );
  }
}

// A tela de destino, idêntica nos dois arquivos desta dupla. O que muda entre
// eles não é ela: é **como** se chega até aqui.
class const TelaDetalhes({super.key, final VoidCallback? aoVoltar})
    extends StatelessWidget {
  // Anulável de propósito: quem chega por uma rota não precisa receber o
  // caminho de volta, porque a pilha já sabe qual é.
  @override
  Widget build(BuildContext context) {
    // * O placar desta aula. canPop responde se existe alguma rota embaixo
    // * desta na pilha do Navigator — é ele que separa "troquei o corpo da
    // * tela" de "empilhei uma rota de verdade".
    final empilhada = Navigator.canPop(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes')),
      body: Center(
        child: Text(
          empilhada
              ? 'Navigator.canPop: true\n'
                    'Estou numa rota, e há uma tela embaixo de mim.'
              : 'Navigator.canPop: false\n'
                    'Não sou uma rota: o pai trocou o próprio corpo.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
