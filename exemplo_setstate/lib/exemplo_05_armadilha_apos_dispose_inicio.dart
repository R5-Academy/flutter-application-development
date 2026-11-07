// exemplo_05_armadilha_apos_dispose_inicio.dart
// Ponto de partida: a tela de detalhe do produto consulta o estoque ao abrir — o
// padrão correto do bloco anterior: `initState` chamando um método `Future`.
//
// * Abra o produto, espere os 3 segundos, e o texto muda para "12 unidades em
// * estoque". **Funciona.**
//
// ! Agora faça o que um usuário real faz: abra o produto e **volte antes de
// ! carregar**. Toque em "Ver detalhes", conte um segundo, e aperte voltar.
//
// !     setState() called after dispose(): _DetalheDoProdutoState#29d47
// !     (lifecycle state: defunct, not mounted)
// !
// ! (o assert está no início de `State.setState`, em `framework.dart`)
// !
// ! O `await` continuou correndo depois que a tela saiu da árvore. Quando ele
// ! completou, chamou `setState` num `State` que já foi descartado.
//
// ! **Por que isso é grave:** o fluxo feliz passa em todo teste. O erro só
// ! aparece quando o usuário é mais rápido que a rede — o que, num aplicativo
// ! real com conexão ruim, é o tempo todo.
//
// ! E o analisador **não te ajuda aqui**: `flutter analyze` neste arquivo diz
// ! *"No issues found!"*. O lint `use_build_context_synchronously` só olha para
// ! o **`BuildContext`** depois de um `await` — `setState` sem `mounted` passa
// ! batido. Este é um erro que só a execução (ou o seu olho) pega.
//
// ! E repare que **não há nada de errado com o `await`**. Ele não sabe nada
// ! sobre widgets, e não tem como saber que a tela sumiu. Cancelar um `Future`
// ! em Dart, aliás, não é possível.
//
// ? Se não dá para cancelar a operação, resta **verificar antes de agir**. O
// ? `State` tem uma propriedade que responde exatamente à pergunta *"eu ainda
// ? estou na árvore?"*.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: Vitrine()));

class Vitrine extends StatelessWidget {
  const Vitrine({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mercado da Esquina')),
      body: Center(
        child: FilledButton(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const DetalheDoProduto()),
          ),
          child: const Text('Ver detalhes do café em grão'),
        ),
      ),
    );
  }
}

class DetalheDoProduto extends StatefulWidget {
  const DetalheDoProduto({super.key});

  @override
  State<DetalheDoProduto> createState() => _DetalheDoProdutoState();
}

class _DetalheDoProdutoState extends State<DetalheDoProduto> {
  var _estoque = 'consultando estoque...';

  @override
  void initState() {
    super.initState();
    _consultarEstoque();
  }

  Future<void> _consultarEstoque() async {
    // Simula uma requisição lenta. Volte antes de 3s para ver o erro.
    final resultado = await Future<String>.delayed(
      const Duration(seconds: 3),
      () => '12 unidades em estoque',
    );

    // ! Sem guarda: se a tela já saiu, isto roda num State descartado.
    setState(() => _estoque = resultado);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Café em grão · 500 g')),
      body: Center(
        child: Text(_estoque, style: Theme.of(context).textTheme.headlineSmall),
      ),
    );
  }
}
