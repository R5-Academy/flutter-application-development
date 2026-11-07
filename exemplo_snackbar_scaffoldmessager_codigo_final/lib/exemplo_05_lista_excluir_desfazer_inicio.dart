// exemplo_05_lista_excluir_desfazer_inicio.dart
// Ponto de partida: a lista de favoritos. Excluir abre uma **confirmação** —
// exatamente o que a aula 01 desta seção ensinou
// (`exemplo_05_confirmar_exclusao_completo`).
//
// Está correto. Mas experimente limpar a lista: quatro itens, quatro diálogos,
// oito toques.
//
// ! Para cada exclusão, a tela para, escurece e cobra uma decisão. E excluir um
// ! favorito não é apagar um contrato: é tirar um item de uma lista que a
// ! pessoa pode refazer em dois toques.
//
// ! O diálogo protege quem erra — interrompendo **todo mundo**, inclusive quem
// ! sabe exatamente o que está fazendo.
//
// ? A aula tem um mecanismo melhor para ações reversíveis. Qual é?

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaFavoritos()));

class TelaFavoritos extends StatefulWidget {
  const TelaFavoritos({super.key});

  @override
  State<TelaFavoritos> createState() => _TelaFavoritosState();
}

class _TelaFavoritosState extends State<TelaFavoritos> {
  final List<String> _favoritos = [
    'Fone de ouvido',
    'Teclado mecânico',
    'Mouse sem fio',
    'Monitor 27"',
  ];

  Future<void> _excluir(int index) async {
    final itemRemovido = _favoritos[index];
    final posicaoOriginal = index;

    setState(() => _favoritos.removeAt(index));

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('"$itemRemovido" excluido'),
          behavior: .floating,
          action: SnackBarAction(
            label: 'Desfazer',
            onPressed: () {
              setState(() {
                _favoritos.insert(posicaoOriginal, itemRemovido);
              });
            },
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meus favoritos')),
      body: _favoritos.isEmpty
          ? const Center(child: Text('Nenhum favorito'))
          : ListView.builder(
              itemCount: _favoritos.length,
              itemBuilder: (context, index) {
                final item = _favoritos[index];
                return ListTile(
                  leading: const Icon(Icons.favorite, color: Colors.red),
                  title: Text(item),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    tooltip: 'Excluir',
                    onPressed: () => _excluir(index),
                  ),
                );
              },
            ),
    );
  }
}
