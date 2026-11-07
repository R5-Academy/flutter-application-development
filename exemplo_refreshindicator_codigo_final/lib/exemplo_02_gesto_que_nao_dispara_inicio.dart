// exemplo_02_gesto_que_nao_dispara_inicio.dart
// Ponto de partida: quatro palcos lado a lado, um contador de disparos na
// AppBar, e o mesmo `RefreshIndicator` em volta de todos.
//
// Puxe cada um dos quatro e veja o contador subir — ou não:
//
//   ListView com 3 itens        -> dispara
//   ListView + controller       -> NÃO dispara
//   SingleChildScrollView       -> NÃO dispara
//   SingleChildScrollView (2)   -> NÃO dispara
//
// ? A explicação que se ouve por aí é "a lista é curta demais, não tem o que
// ? rolar". O primeiro palco desmente isso: três itens e o gesto funciona.
// ?
// ?   **então o que os três de baixo têm em comum, que o primeiro não tem?**
// ?
// ? A resposta é um parâmetro que você nunca precisou escrever — porque, num
// ? caso, o Flutter escreve por você.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaPalcos()));

enum _Caso {
  listaCurta('ListView 3 itens'),
  comController('ListView + controller'),
  scrollViewSimples('SingleChildScrollView'),
  scrollViewSimples2('SingleChildScrollView (2)');

  const _Caso(this.rotulo);

  final String rotulo;
}

class TelaPalcos extends StatefulWidget {
  const TelaPalcos({super.key});

  @override
  State<TelaPalcos> createState() => _TelaPalcosState();
}

class _TelaPalcosState extends State<TelaPalcos> {
  _Caso _caso = .listaCurta;
  int _disparos = 0;

  Future<void> _atualizar() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _disparos++);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('onRefresh disparou $_disparos vez(es)'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(160),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            // Wrap, e não uma linha rolável: com quatro chips numa linha só o
            // último sai da tela, e e justo ele que mostra o conserto.
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 4,
              children: [
                for (final c in _Caso.values)
                  ChoiceChip(
                    label: Text(c.rotulo),
                    selected: _caso == c,
                    onSelected: (_) => setState(() {
                      _caso = c;
                      _disparos = 0;
                    }),
                  ),
              ],
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _atualizar,
        // A ValueKey troca o palco de verdade a cada caso, sem reaproveitar o
        // estado de rolagem do anterior.
        child: _Palco(key: ValueKey(_caso), caso: _caso),
      ),
    );
  }
}

class const _Palco({super.key, required final _Caso caso})
    extends StatefulWidget {
  @override
  State<_Palco> createState() => _PalcoState();
}

class _PalcoState extends State<_Palco> {
  final _controlador = ScrollController();

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const itens = ['Maca', 'Banana', 'Laranja'];

    return switch (widget.caso) {
      // * DISPARA. Esta e a lista "curta" do folclore: 3 itens, cabe na tela.
      // Sem controller, sem primary e no eixo vertical, o ScrollView injeta
      // AlwaysScrollableScrollPhysics sozinho - não há nada para consertar.
      .listaCurta => ListView.builder(
        itemCount: itens.length,
        itemBuilder: (_, index) {
          final i = itens[index];
          return ListTile(title: Text(i));
        },
      ),

      // ! NÃO DISPARA. Passar um controller derruba a injeção automática:
      // ! physics fica null, cai na do ScrollBehavior (Clamping/Bouncing), e
      // ! conteúdo menor que a tela não aceita arraste. E o caso que pega o
      // ! dev de verdade, porque o controller entrou por outro motivo
      // ! (ir para o topo, ouvir a rolagem) e o refresh morreu de lado.
      // Conserto: physics: const AlwaysScrollableScrollPhysics().
      .comController => ListView.builder(
        controller: _controlador,
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: itens.length,
        itemBuilder: (_, index) {
          final i = itens[index];
          return ListTile(title: Text(i));
        },
      ),

      // ! NÃO DISPARA. SingleChildScrollView não herda de ScrollView, então
      // ! nunca ganhou a injeção. Tela de detalhe ou formulário com pouco
      // ! conteúdo e o cenário clássico.
      .scrollViewSimples => SingleChildScrollView(
        child: Column(
          children: [for (final i in itens) ListTile(title: Text(i))],
        ),
      ),

      // O mesmo widget do caso anterior.
      .scrollViewSimples2 => SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [for (final i in itens) ListTile(title: Text(i))],
        ),
      ),
    };
  }
}
