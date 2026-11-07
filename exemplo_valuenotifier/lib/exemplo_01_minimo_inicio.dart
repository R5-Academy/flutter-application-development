// exemplo_01_minimo_inicio.dart
// Ponto de partida: um contador escrito do jeito que você aprendeu na aula de
// ChangeNotifier — campo privado, getter, método que muta e avisa.
//
// Rode e siga esta ordem: "definir 1", "definir 2", e "definir 2" DE NOVO.
//
// ! Repare no terceiro toque. O método foi chamado com o valor 2, que já era o
// ! valor atual — nada mudou de fato — e mesmo assim o painel ganhou uma linha:
// ! todos os ouvintes rodaram. Num app de verdade, notificar sem ter mudado
// ! vira rebuild desnecessário.
//
// ? A classe inteira abaixo existe para guardar UM número. São doze linhas de
// ? cerimônia — campo, getter, método, notificação — em volta de um `int`.
// ?
// ?   **e quando o estado é um valor só, dá para não escrever nada disso?**

import 'package:material_ui/material_ui.dart';

class Contador extends ChangeNotifier {
  int _valor = 0;

  int get valor => _valor;

  void definir(int novo) {
    _valor = novo;
    notifyListeners();
  }
}

void main() => runApp(const MaterialApp(home: TelaContador()));

class TelaContador extends StatefulWidget {
  const TelaContador({super.key});

  @override
  State<TelaContador> createState() => _TelaContadorState();
}

class _TelaContadorState extends State<TelaContador> {
  late final Contador _contador;

  final _avisos = <String>[];

  @override
  void initState() {
    super.initState();
    _contador = Contador();
    _contador.addListener(_aoSerAvisado);
  }

  void _aoSerAvisado() {
    setState(() {
      _avisos.add('O contador mudou para ${_contador.valor}');
    });
  }

  @override
  void dispose() {
    _contador.dispose();
    super.dispose();
  }

  void _definir(int novo) => _contador.definir(novo);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ValueNotifier mínimo')),
      body: Column(
        children: [
          _Leitura(rotulo: 'Valor do contador', valor: '${_contador.valor}'),
          const Divider(height: 1),
          Expanded(
            child: _Registro(titulo: 'Avisos recebidos', linhas: _avisos),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Wrap(
            spacing: 8,
            alignment: WrapAlignment.center,
            children: [
              FilledButton.tonal(
                onPressed: () => _definir(1),
                child: const Text('definir 1'),
              ),
              FilledButton.tonal(
                onPressed: () => _definir(2),
                child: const Text('definir 2'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Bancada: o número grande, o estado agora.
class const _Leitura({
  required final String rotulo,
  required final String valor,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Text(valor, style: tema.displaySmall),
          Text(rotulo, style: tema.labelLarge),
        ],
      ),
    );
  }
}

// Bancada: a lista do que foi anotado, na ordem em que chegou.
class const _Registro({
  required final String titulo,
  required final List<String> linhas,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context).textTheme;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text('$titulo (${linhas.length})', style: tema.labelLarge),
        ),
        Expanded(
          child: linhas.isEmpty
              ? const Center(child: Text('nada ainda'))
              : ListView.builder(
                  itemCount: linhas.length,
                  itemBuilder: (_, index) {
                    return ListTile(
                      dense: true,
                      leading: Text('${index + 1}'),
                      title: Text(linhas[index]),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
