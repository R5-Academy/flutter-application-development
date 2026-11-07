// exemplo_03_empty_com_cta_inicio.dart
// Ponto de partida: a tela já não fica em branco — ela avisa "Nada por aqui".
//
// É melhor que o vazio mudo do primeiro exemplo, e ainda é pouco.
//
// Esvazie a lista pelo botão e leia a mensagem. Depois recarregue com a lista
// vazia desde o início e leia de novo: **é a mesma frase** para duas situações
// completamente diferentes.
//
// ? Uma lista pode estar vazia por motivos que não têm nada a ver entre si:
// ?
// ?   "nunca teve nada"  -> o usuário precisa ser CONVIDADO a criar o primeiro
// ?   "você esvaziou"    -> o usuário CONCLUIU a tarefa, e merece o tom certo
// ?
// ?   **a mesma tela serve para os dois?**
// ?
// ? Não serve. E a diferença não é só de texto: é de qual botão vai ali embaixo.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaListaCompras()));

class TelaListaCompras extends StatefulWidget {
  const TelaListaCompras({super.key});

  @override
  State<TelaListaCompras> createState() => _TelaListaComprasState();
}

class _TelaListaComprasState extends State<TelaListaCompras> {
  // Comeca vazia de propósito: a primeira coisa que o usuário vê e o vazio.
  final _itens = <String>[];
  var _contador = 0;

  // * A pergunta que separa os dois vazios: já houve alguma coisa aqui?
  var _jaTeveItens = false;

  void _adicionarItem() {
    setState(() {
      _contador++;
      _itens.add('Item $_contador');
      _jaTeveItens = true;
    });
  }

  void _concluirCompras() {
    setState(_itens.clear);
  }

  @override
  Widget build(BuildContext context) {
    final vazia = _itens.isEmpty;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de compras'),
        actions: [
          if (!vazia)
            IconButton(
              onPressed: _concluirCompras,
              icon: const Icon(Icons.done_all),
              tooltip: 'Concluir compras',
            ),
        ],
      ),
      // O mesmo texto, seja qual for o motivo de a lista estar vazia.
      body: switch ((vazia, _jaTeveItens)) {
        (true, _) => const Center(child: Text('Nada por aqui')),
        _ => ListView.builder(
          itemCount: _itens.length,
          itemBuilder: (context, i) => ListTile(
            leading: const Icon(Icons.check_box_outline_blank),
            title: Text(_itens[i]),
          ),
        ),
      },
      // Quando já há itens, o CTA vira o FAB (padrão de app real).
      floatingActionButton: vazia
          ? null
          : FloatingActionButton(
              onPressed: _adicionarItem,
              child: const Icon(Icons.add),
            ),
    );
  }
}
