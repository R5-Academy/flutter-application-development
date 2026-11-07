// exemplo_01_filtros_inicio.dart
// Ponto de partida: o catálogo do mercado com um diálogo de filtros. Toque em
// "Filtrar", e escolha as categorias que quer ver.
//
// ! **Toque numa categoria. A caixa não marca.** Toque de novo, e de novo:
// ! nada. E **nenhum erro aparece** — nem no console, nem na tela.
//
// * Leia os dois placares antes de continuar. Depois de três toques:
// *
// *     tela: 4 builds      <- a tela reconstruiu, três vezes
// *     diálogo: 1 build    <- o diálogo não reconstruiu nenhuma
//
// ? O `setState` **funcionou**. O campo `_selecionadas` mudou, a tela foi
// ? marcada como suja e o `build` dela rodou. Só que quem precisava ser
// ? redesenhado era o **conteúdo do diálogo** — e ele não foi.
//
// ? A aula de `NavigatorObserver` já deu a peça que explica isso: `showDialog`
// ? **empurra uma rota**. O diálogo não é um filho desta tela; ele mora no
// ? `Overlay`, acima do `Navigator`. Reconstruir esta tela não alcança lá.
//
// ? A aula 02 resolveu o problema de escopo **extraindo uma classe**
// ? (`_SeletorDeQuantidade`). Aqui não dá: o conteúdo do diálogo nasce dentro
// ? de um closure — o `builder:` do `showDialog` — e não é um widget da árvore
// ? desta tela. Como se dá `setState` a um trecho que não é um widget seu?

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: CatalogoDoMercado()));

const _categorias = <String>['Padaria', 'Laticínios', 'Hortifruti'];

const _produtos = <(String, String)>[
  ('Pão de forma integral', 'Padaria'),
  ('Broa de milho', 'Padaria'),
  ('Leite integral 1 L', 'Laticínios'),
  ('Queijo minas frescal', 'Laticínios'),
  ('Iogurte natural 170 g', 'Laticínios'),
  ('Banana prata · kg', 'Hortifruti'),
  ('Tomate italiano · kg', 'Hortifruti'),
  ('Alface crespa · unidade', 'Hortifruti'),
];

class CatalogoDoMercado extends StatefulWidget {
  const CatalogoDoMercado({super.key});

  @override
  State<CatalogoDoMercado> createState() => _CatalogoDoMercadoState();
}

class _CatalogoDoMercadoState extends State<CatalogoDoMercado> {
  // O estado dos filtros mora aqui, no State da TELA.
  final _selecionadas = <String>{};

  // Instrumentação: quantas vezes cada lado reconstruiu.
  var _buildsDaTela = 0;
  var _buildsDoDialogo = 0;

  Future<void> _abrirFiltros() async {
    _buildsDoDialogo = 0;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        _buildsDoDialogo++;

        return StatefulBuilder(
          builder: (_, setStateLocal) {
            return AlertDialog(
              title: const Text('Filtrar por categoria'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final categoria in _categorias)
                    CheckboxListTile(
                      title: Text(categoria),
                      value: _selecionadas.contains(categoria),
                      // ! O setState DESTA TELA. Ele roda, e o diálogo não muda.
                      onChanged: (marcado) {
                        setStateLocal(() {
                          if (marcado ?? false) {
                            _selecionadas.add(categoria);
                          } else {
                            _selecionadas.remove(categoria);
                          }
                        });
                      },
                    ),
                  const Divider(),
                  Text('diálogo: $_buildsDoDialogo builds'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Fechar'),
                ),
              ],
            );
          },
        );
      },
    );

    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _buildsDaTela++;

    final visiveis = _selecionadas.isEmpty
        ? _produtos
        : _produtos.where((p) => _selecionadas.contains(p.$2)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo'),
        actions: [
          IconButton(
            onPressed: _abrirFiltros,
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filtrar',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text('tela: $_buildsDaTela builds'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: visiveis.length,
              itemBuilder: (_, index) => ListTile(
                title: Text(visiveis[index].$1),
                subtitle: Text(visiveis[index].$2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
