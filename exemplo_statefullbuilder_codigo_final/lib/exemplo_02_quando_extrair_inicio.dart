// exemplo_02_quando_extrair_inicio.dart
// Ponto de partida: o mesmo painel de filtros, agora com um campo de busca — e
// ele já usa o `StatefulBuilder` que acabamos de aprender.
//
// * Roteiro: abra o filtro, digite **leite** no campo, e então marque
// * "Laticínios".
//
// ! **O texto digitado some.** Medido: o campo volta a ficar vazio no toque da
// ! caixa, e o placar mostra que **um `TextEditingController` novo** foi criado
// ! a cada reconstrução — três toques, quatro controllers.
//
// ? O `StatefulBuilder` reconstrói o `builder:` inteiro. Tudo que é **criado
// ? dentro** dele nasce de novo a cada `setLocal` — inclusive o controller, que
// ? deveria viver enquanto o painel estiver aberto.
//
// ! E não há para onde mover. O `StatefulBuilder` te dá **um** método, o
// ! `setState` — ele não tem `initState` para criar o controller uma vez, nem
// ! `dispose` para descartá-lo. Esses três controllers abandonados também não
// ! são liberados: é vazamento.
//
// ? Esse é o limite da ferramenta, e ele é objetivo — não é questão de gosto:
// ? **assim que o trecho precisa de ciclo de vida, o `builder` não serve mais.**
// ? A saída é a que a aula 02 já ensinou, e é a regra da casa desde a fase 02:
// ? widget é classe.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: CatalogoDoMercado()));

const _categorias = <String>['Padaria', 'Laticínios', 'Hortifruti'];

const _produtos = <(String, String)>[
  ('Pão de forma integral', 'Padaria'),
  ('Leite integral 1 L', 'Laticínios'),
  ('Queijo minas frescal', 'Laticínios'),
  ('Banana prata · kg', 'Hortifruti'),
];

// Instrumentação: quantos controllers já foram criados nesta sessão.
int controllersCriados = 0;

class CatalogoDoMercado extends StatefulWidget {
  const CatalogoDoMercado({super.key});

  @override
  State<CatalogoDoMercado> createState() => _CatalogoDoMercadoState();
}

class _CatalogoDoMercadoState extends State<CatalogoDoMercado> {
  var _selecionadas = <String>{};

  Future<void> _abrirFiltros() async {
    controllersCriados = 0;

    final escolhidas = await showDialog<Set<String>>(
      context: context,
      builder: (dialogContext) {
        return _PainelDeFiltros(iniciais: _selecionadas);
      },
    );

    if (!mounted || escolhidas == null) return;
    setState(() {
      _selecionadas = escolhidas;
    });
  }

  @override
  Widget build(BuildContext context) {
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
      body: ListView.builder(
        itemCount: visiveis.length,
        itemBuilder: (_, index) => ListTile(
          title: Text(visiveis[index].$1),
          subtitle: Text(visiveis[index].$2),
        ),
      ),
    );
  }
}

class const _PainelDeFiltros({required final Set<String> iniciais})
    extends StatefulWidget {
  @override
  State<_PainelDeFiltros> createState() => _PainelDeFiltrosState();
}

class _PainelDeFiltrosState extends State<_PainelDeFiltros> {
  late final TextEditingController _busca;
  late final Set<String> _selecionadas;

  @override
  void initState() {
    super.initState();
    _busca = TextEditingController();
    controllersCriados++;
    _selecionadas = {...widget.iniciais};
  }

  @override
  void dispose() {
    _busca.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filtrar'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _busca,
            decoration: const InputDecoration(labelText: 'Buscar produto'),
          ),
          const SizedBox(height: 8),
          for (final categoria in _categorias)
            CheckboxListTile(
              title: Text(categoria),
              value: _selecionadas.contains(categoria),
              onChanged: (marcado) => setState(() {
                if (marcado ?? false) {
                  _selecionadas.add(categoria);
                } else {
                  _selecionadas.remove(categoria);
                }
              }),
            ),
          const Divider(),
          Text('controllers criados: $controllersCriados'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(_selecionadas),
          child: const Text('Fechar'),
        ),
      ],
    );
  }
}
