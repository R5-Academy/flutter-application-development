// exemplo_04_mundo_real_inicio.dart
// Ponto de partida: um saldo de conta com a plumbing pronta e os botões
// apagados.
//
// O `StreamController` já existe, já é fechado no `dispose`, e o `StreamBuilder`
// já mostra o saldo inicial. Os botões funcionam.
//
// Rode e toque em -30 três vezes:
//
//   o console  ->  "o saldo agora vale 70.0", "40.0", "10.0"
//   a tela     ->  "R$ 100,00", parada
//
// ! O saldo muda. O que não acontece é ninguém pôr esse valor dentro do cano.
//
// ? Nos exemplos anteriores o stream emitia sozinho — `Stream.periodic` no
// ? relógio, `async*` na sequência. Aqui é diferente: quem decide quando emitir
// ? é o usuário, ao tocar num botão.
// ?
// ?   **como VOCÊ empurra um evento para dentro de um Stream?**
// ?
// ? E a pergunta que vem junto: e quando a operação falha — saldo insuficiente,
// ? rede fora — como isso viaja pelo mesmo cano?

import 'dart:async';

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaSaldo()));

class TelaSaldo extends StatefulWidget {
  const TelaSaldo({super.key});

  @override
  State<TelaSaldo> createState() => _TelaSaldoState();
}

class _TelaSaldoState extends State<TelaSaldo> {
  // * O StreamController e a "torneira" do stream: nos abrimos (add) e fechamos.
  final _saldoController = StreamController<double>();
  double _saldoAtual = 100.0;

  void _movimentar(double valor) {
    _saldoAtual += valor;
    if (_saldoAtual < 0) {
      _saldoAtual -= valor;
      debugPrint('saldo insuficiente (o saldo segue em $_saldoAtual)');
      return;
    }
    // ! O campo mudou. E ninguém no cano ficou sabendo.
    debugPrint('o saldo agora vale $_saldoAtual');
  }

  @override
  void dispose() {
    // ! O StreamBuilder cancela a assinatura DELE sozinho no dispose (medido:
    // ! onCancel dispara, hasListener vira false). O que ele não faz e fechar a
    // ! SUA torneira: o close() é responsabilidade de quem criou o controller.
    _saldoController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Minha conta')),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'saque',
            onPressed: () => _movimentar(-30),
            child: const Icon(Icons.remove),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            heroTag: 'deposito',
            onPressed: () => _movimentar(30),
            child: const Icon(Icons.add),
          ),
        ],
      ),
      body: Center(
        child: StreamBuilder<double>(
          // ? controller.stream dentro do build não é a armadilha do exemplo 05:
          // o getter devolve um objeto novo a cada chamada, mas os dois são ==
          // (mesmo controller), e o StreamBuilder compara com != -- logo ele NÃO
          // reassina. Medido: 1 assinatura depois de 3 rebuilds.
          stream: _saldoController.stream,
          // Sem initialData, o primeiro frame ficaria "sem dado" até o primeiro
          // clique. Com ele, a tela já nasce mostrando 100.
          initialData: _saldoAtual,
          builder: (context, snapshot) {
            // * Erro PRIMEIRO, e o motivo não e "senão o erro passa batido".
            // Medido: num addError o snapshot fica active/data=null/hasError=true
            // -- o AsyncSnapshot nunca guarda dado e erro juntos. Se o ramo de
            // baixo rodasse com hasError, o data! estouraria.
            // E o erro aqui e PASSAGEIRO: o próximo add limpa o hasError e o
            // saldo volta. Num Future o erro seria o fim da linha.
            if (snapshot.hasError) {
              return Text(
                snapshot.error.toString(),
                style: const TextStyle(fontSize: 20, color: Colors.red),
              );
            }
            return Text(
              'R\$ ${snapshot.data!.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 40),
            );
          },
        ),
      ),
    );
  }
}
