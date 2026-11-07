// exemplo_03_scroll_controlled_inicio.dart
// Ponto de partida: um seletor de cidade — campo de busca no topo e a lista
// completa embaixo, dentro do painel.
//
// ! Rode e abra. O painel para em **9/16 da tela** — 56,25%, o default de
// ! `scrollControlDisabledMaxHeightRatio` (bottom_sheet.dart:32). Medido numa
// ! tela de 800: painel de 450 px, com espaço para **5 cidades** de 24 na lista,
// ! e 350 px de tela vazia acima dele.
//
// ! Agora toque no campo de busca. O teclado sobe e o painel **não se mexe**:
// ! ele vive numa rota por cima do `Scaffold`, então o `resizeToAvoidBottomInset`
// ! não o alcança. Medido com teclado de 300 px: o painel continua em 350..800, o
// ! teclado cobre de 500 para baixo, e sobram **zero** cidades inteiras. O campo
// ! escapa por 30 px — mas a lista, que é para onde a pessoa olha enquanto
// ! digita, sumiu inteira.
//
// ? São dois problemas independentes: o teto da altura e o teclado. Cada um tem
// ? o seu parâmetro, e o do teclado é um velho conhecido da aula de MediaQuery.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: ScrollControlled()));

class ScrollControlled extends StatelessWidget {
  const ScrollControlled({super.key});

  static const List<String> _cidades = [
    'São Paulo',
    'Rio de Janeiro',
    'Belo Horizonte',
    'Curitiba',
    'Porto Alegre',
    'Salvador',
    'Recife',
    'Fortaleza',
    'Brasília',
    'Manaus',
    'Belém',
    'Goiânia',
    'Campinas',
    'Florianópolis',
    'Vitória',
    'Natal',
    'Maceió',
    'João Pessoa',
    'Teresina',
    'Cuiabá',
    'Campo Grande',
    'Aracaju',
    'Palmas',
    'Macapá',
  ];

  Future<void> _abrir(BuildContext context) async {
    final cidade = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetContext) {
        return FractionallySizedBox(
          heightFactor: 0.75,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
            ),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Buscar cidade',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _cidades.length,
                    itemBuilder: (context, i) {
                      final nome = _cidades[i];
                      return ListTile(
                        leading: const Icon(Icons.location_city),
                        title: Text(nome),
                        onTap: () => Navigator.pop(sheetContext, nome),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (!context.mounted) return;
    if (cidade != null) {
      showDialog<void>(
        context: context,
        builder: (dialogContext) =>
            AlertDialog(content: Text('Cidade escolhida: $cidade')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('isScrollControlled')),
      body: Center(
        child: FilledButton(
          onPressed: () => _abrir(context),
          child: const Text('Escolher cidade'),
        ),
      ),
    );
  }
}
