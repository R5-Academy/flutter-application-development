// exemplo_04_stream_subscription_inicio.dart
// Ponto de partida: uma tela "ao vivo" que assina uma Stream infinita no
// `initState` e dá `setState` a cada evento. A escuta é manual (`.listen`), não
// é o `StreamBuilder`.
//
// Rode, abra a tela ao vivo, deixe o contador subir e volte com o botão de
// voltar. A tela some, e parece que acabou.
//
// ! Não acabou. A `Stream.periodic` continua emitindo um evento por segundo,
// ! para sempre, e o callback continua sendo chamado. Quem segura tudo isso é o
// ! `State` que já saiu da árvore — ele não é coletado enquanto a assinatura
// ! viver. Entre e saia da tela cinco vezes e você terá cinco contadores
// ! rodando ao mesmo tempo.
//
// ! O `if (!mounted) return;` no callback esconde o sintoma: evita o erro do
// ! `setState` depois do `dispose`, mas não faz a Stream parar. O trabalho
// ! continua sendo feito — só é jogado fora.
//
// Quem assina é quem cancela.

import 'dart:async';

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaMenu()));

// Uma "fonte de dados" ao vivo: emite um número a cada segundo, para sempre.
Stream<int> contadorInfinito() {
  return Stream.periodic(
    const Duration(seconds: 1),
    (contagem) => contagem + 1,
  );
}

class TelaMenu extends StatelessWidget {
  const TelaMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menu')),
      body: Center(
        child: ElevatedButton(
          onPressed: () =>
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => const TelaAoVivo())),
          child: const Text('Abrir tela ao vivo'),
        ),
      ),
    );
  }
}

class TelaAoVivo extends StatefulWidget {
  const TelaAoVivo({super.key});

  @override
  State<TelaAoVivo> createState() => _TelaAoVivoState();
}

class _TelaAoVivoState extends State<TelaAoVivo> {
  int _ultimo = 0;
  StreamSubscription<int>? _sub;

  @override
  void initState() {
    super.initState();
    // ! A assinatura é feita aqui e o retorno do `.listen` é jogado fora. Sem
    // ! guardar o `StreamSubscription` não existe nem COMO cancelar depois —
    // ! e é assim que a maioria escreve na primeira vez.
    _sub = contadorInfinito().listen((valor) {
      debugPrint('contadorInfinito $valor');
      if (!mounted) return;
      setState(() => _ultimo = valor);
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contador ao vivo')),
      body: Center(
        child: Text(
          'Ultimo evento: $_ultimo',
          style: const TextStyle(fontSize: 32),
        ),
      ),
    );
  }
}
