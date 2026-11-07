// exemplo_05_opcoes_do_item_inicio.dart
// Ponto de partida: a lista de produtos, cada um com o "⋮" abrindo um sheet de
// opções — favoritar, editar, excluir.
//
// ! Abra o menu de dois produtos diferentes. Os dois painéis são **idênticos**:
// ! nada diz de qual item aquelas opções são.
// !
// ! Numa lista com quatro produtos, o sheet cobre a lista inteira ao subir. A
// ! pessoa toca no "⋮" do "Webcam", o painel sobe, esconde tudo — e na hora de
// ! confirmar ela não tem mais como conferir se tocou no item certo.
//
// ! E a opção de favoritar diz sempre "Favoritar", mesmo quando o produto **já
// ! é** favorito. Tocar nela desfavorita — com o rótulo dizendo o contrário.
//
// ? O painel é uma gaveta **daquele item**. Ele precisa dizer isso.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: ListaComOpcoes()));

// * enum como resultado do painel: cada opção vira um valor bem definido.
enum AcaoItem { favoritar, editar, excluir }

class Produto(final String nome, {var bool favorito = false});

class ListaComOpcoes extends StatefulWidget {
  const ListaComOpcoes({super.key});

  @override
  State<ListaComOpcoes> createState() => _ListaComOpcoesState();
}

class _ListaComOpcoesState extends State<ListaComOpcoes> {
  final List<Produto> _produtos = [
    Produto('Teclado mecânico'),
    Produto('Mouse sem fio', favorito: true),
    Produto('Monitor 27 polegadas'),
    Produto('Webcam Full HD'),
  ];

  Future<void> _abrirOpcoes(Produto produto) async {
    final acao = await showModalBottomSheet<AcaoItem>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ! Sem cabeçalho: o painel não diz de qual item ele é.
              Padding(
                padding: const .symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  produto.nome,
                  style: TextStyle(fontSize: 18, fontWeight: .bold),
                ),
              ),
              ListTile(
                leading: Icon(
                  produto.favorito ? Icons.favorite : Icons.favorite_border,
                ),
                // ! Rótulo fixo, mesmo quando o item já é favorito.
                title: Text(
                  produto.favorito ? 'Remover dos favoritos' : 'Favoritar',
                ),
                onTap: () => Navigator.pop(sheetContext, AcaoItem.favoritar),
              ),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Editar'),
                onTap: () => Navigator.pop(sheetContext, AcaoItem.editar),
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Excluir'),
                onTap: () => Navigator.pop(sheetContext, AcaoItem.excluir),
              ),
            ],
          ),
        );
      },
    );

    if (!mounted || acao == null) return;

    switch (acao) {
      case AcaoItem.favoritar:
        setState(() => produto.favorito = !produto.favorito);
      case AcaoItem.editar:
        showDialog<void>(
          context: context,
          builder: (dialogContext) =>
              AlertDialog(content: Text('Editar "${produto.nome}" (exemplo)')),
        );
      case AcaoItem.excluir:
        setState(() => _produtos.remove(produto));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Opções do item')),
      body: ListView.builder(
        itemCount: _produtos.length,
        itemBuilder: (context, i) {
          final produto = _produtos[i];
          return ListTile(
            leading: const Icon(Icons.inventory_2_outlined),
            title: Text(produto.nome),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (produto.favorito)
                  const Icon(Icons.favorite, color: Colors.red, size: 20),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  tooltip: 'Opções',
                  onPressed: () => _abrirOpcoes(produto),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
