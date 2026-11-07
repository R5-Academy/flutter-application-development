// exemplo_01_quem_escuta_inicio.dart
// Ponto de partida: o contador da aula anterior funcionando SEM o widget de
// hoje. O ouvinte está registrado na mão, no State: addListener no initState,
// setState no callback, removeListener no dispose.
//
// Rode: funciona. O número sobe, a tela acompanha.
//
// O painel de cima responde a uma pergunta: existe alguém escutando o notifier
// neste instante? Ele só atualiza quando você toca em "conferir". Faça assim:
// esconda o valor, depois confira.
//
// ! O valor some da tela e o painel continua em `sim`. O ouvinte é do State,
// ! não do trecho que mostra o número — ele fica registrado mesmo quando nada
// ! na tela depende dele.
//
// ? As oito linhas abaixo (o campo `_aoMudar`, o `addListener`, o `setState`, o
// ? `removeListener`) são plumbing: elas não falam do seu app, falam de como se
// ? escuta um observável. Toda tela que escutar um notifier vai reescrevê-las.
// ?
// ?   **e se um widget fizesse exatamente isso, e só isso, por você?**

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaContador()));

class Contador extends ChangeNotifier {
  int _valor = 0;

  int get valor => _valor;

  void incrementar() {
    _valor++;
    notifyListeners();
  }

  // Instrumentação do exemplo. `hasListeners` é @protected
  // (change_notifier.dart:212), então só a própria classe consegue lê-lo —
  // quem está de fora precisa que ela exponha.
  bool get temOuvinte => hasListeners;
}

class TelaContador extends StatefulWidget {
  const TelaContador({super.key});

  @override
  State<TelaContador> createState() => _TelaContadorState();
}

class _TelaContadorState extends State<TelaContador> {
  final _contador = Contador();
  var _mostrandoValor = true;
  bool? _tinhaOuvinte;

  @override
  void dispose() {
    _contador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quem escuta o notifier')),
      body: Column(
        children: [
          _PainelDeOuvintes(temOuvinte: _tinhaOuvinte),
          const Divider(height: 1),
          Expanded(
            child: Center(
              child: _mostrandoValor
                  ? ListenableBuilder(
                      listenable: _contador,
                      builder: (_, _) {
                        return Text(
                          'Valor: ${_contador.valor}',
                          style: Theme.of(context).textTheme.headlineMedium,
                        );
                      },
                    )
                  : const Text('(valor escondido)'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  onPressed: () =>
                      setState(() => _mostrandoValor = !_mostrandoValor),
                  child: Text(
                    _mostrandoValor ? 'Esconder o valor' : 'Mostrar o valor',
                  ),
                ),
                FilledButton.tonal(
                  onPressed: () =>
                      setState(() => _tinhaOuvinte = _contador.temOuvinte),
                  child: const Text('Conferir ouvintes'),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _contador.incrementar,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class const _PainelDeOuvintes({required final bool? temOuvinte})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Text(switch (temOuvinte) {
            null => '?',
            true => 'sim',
            false => 'não',
          }, style: tema.headlineMedium),
          Text('o notifier tem ouvinte?', style: tema.labelMedium),
        ],
      ),
    );
  }
}
