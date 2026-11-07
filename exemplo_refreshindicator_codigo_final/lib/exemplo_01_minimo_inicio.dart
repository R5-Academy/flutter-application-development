// exemplo_01_minimo_inicio.dart
// Ponto de partida: uma lista rolável e um método `_atualizar()` pronto, que
// devolve um `Future` e troca os itens.
//
// Rode e toque no botão de recarregar da AppBar: os itens trocam. O método
// funciona.
//
// ! Agora tente puxar a lista para baixo. Nada acontece: a lista bate no topo e
// ! para.
//
// ? O gesto de "puxar para atualizar" é tão comum que parece nativo das listas.
// ? Não é — é um widget, e ele precisa envolver algo ROLÁVEL.
// ?
// ?   **e como ele sabe quando parar de girar?**
// ?
// ? A resposta está na assinatura do parâmetro que você vai escrever: ele não
// ? recebe um `void Function()`, recebe algo que o widget possa ESPERAR.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaMinima()));

class TelaMinima extends StatefulWidget {
  const TelaMinima({super.key});

  @override
  State<TelaMinima> createState() => _TelaMinimaState();
}

class _TelaMinimaState extends State<TelaMinima> {
  // Estado simples: uma lista de textos que vamos "recarregar".
  List<String> _itens = List.generate(20, (i) => 'Item ${i + 1}');
  int _recargas = 0;

  // * onRefresh: o coração do RefreshIndicator.
  // O tipo esperado e RefreshCallback = Future<void> Function().
  // Enquanto este Future não completa, o spinner continua girando.
  Future<void> _atualizar() async {
    // Simula uma operação assincrona (ex.: buscar dados). O await segura o
    // spinner na tela até o carregamento terminar.
    await Future.delayed(const Duration(seconds: 2));

    // Troca os dados exibidos. O setState precisa vir antes de o Future
    // completar, para a lista já aparecer atualizada quando o spinner some.
    setState(() {
      _recargas++;
      _itens = List.generate(20, (i) => 'Item ${i + 1} (recarga $_recargas)');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Puxar para atualizar'),
        actions: [
          // O método de recarga funciona — só não está ligado ao gesto.
          IconButton(
            onPressed: _atualizar,
            icon: const Icon(Icons.refresh),
            tooltip: 'Recarregar pelo botão',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _atualizar,
        child: ListView.builder(
          itemCount: _itens.length,
          itemBuilder: (_, index) {
            return ListTile(
              leading: const Icon(Icons.label_outline),
              title: Text(_itens[index]),
            );
          },
        ),
      ),
    );
  }
}
