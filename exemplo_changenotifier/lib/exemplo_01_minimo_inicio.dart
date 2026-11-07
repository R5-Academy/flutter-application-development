// exemplo_01_minimo_inicio.dart
// Ponto de partida: uma classe Dart comum que guarda um número, dentro de uma
// tela que já sabe mostrá-la.
//
// Rode e toque no +1 algumas vezes. O número sobe — mas repare em QUEM fez ele
// subir: o `setState` que eu escrevi no botão. O painel de avisos continua
// vazio, porque o `Contador` não tem como avisar nada a ninguém.
//
// ? Funciona enquanto quem muda o estado é o botão. E quando o valor mudar em
// ? outro lugar — num timer, na resposta de uma requisição, em outra tela? Não
// ? existe botão para pendurar o `setState`.
// ?
// ?   **como um objeto avisa que mudou, sem conhecer quem escuta?**
// ?
// ? Repare que a classe já está no formato que a aula vai usar: campo privado,
// ? getter só-leitura e um método que muta. Falta só a parte de avisar.

import 'package:material_ui/material_ui.dart';

// * O modelo não conhece a tela: nenhum widget aqui dentro, nenhum
// * BuildContext. Ele continua assim até o fim da aula.
class Contador {
  int _valor = 0;

  // Getter público: quem está de fora LÊ, mas não escreve direto.
  int get valor => _valor;

  void incrementar() {
    _valor++;
  }
}

void main() => runApp(const MaterialApp(home: TelaContador()));

class TelaContador extends StatefulWidget {
  const TelaContador({super.key});

  @override
  State<TelaContador> createState() => _TelaContadorState();
}

class _TelaContadorState extends State<TelaContador> {
  // late porque criamos no initState. Este State é o dono do contador.
  late final Contador _contador;

  // O que os ouvintes anotarem aparece aqui. Por enquanto, ninguém anota nada.
  final _avisos = <String>[];

  @override
  void initState() {
    super.initState();
    _contador = Contador();
  }

  void _incrementar() {
    // ! Quem manda a tela se redesenhar é este setState, e não o contador.
    // ! Ele muda o campo sem avisar ninguém: sem esta linha, o número na tela
    // ! ficaria em 0.
    setState(() => _contador.incrementar());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ChangeNotifier mínimo')),
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
              FilledButton(onPressed: _incrementar, child: const Text('+1')),
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
