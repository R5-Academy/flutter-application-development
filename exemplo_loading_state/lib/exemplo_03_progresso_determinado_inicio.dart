// exemplo_03_progresso_determinado_inicio.dart
// Ponto de partida: um download simulado que anda de verdade — o `_passos` sobe
// a cada 300ms — e dois indicadores que giram sem rumo.
//
// Rode e observe: o texto embaixo mostra a porcentagem subindo, e os dois
// indicadores animam do mesmo jeito do começo ao fim.
//
// ? Os indicadores da aula até aqui eram INDETERMINADOS: "estamos trabalhando,
// ? aguarde". Mas aqui a informação existe — o app sabe exatamente quanto já
// ? foi feito.
// ?
// ?   **como passar esse número para o indicador?**
// ?
// ? É um parâmetro só, e ele muda o widget de "aguarde" para "falta tanto".

import 'dart:async';

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaDownload()));

class TelaDownload extends StatefulWidget {
  const TelaDownload({super.key});

  @override
  State<TelaDownload> createState() => _TelaDownloadState();
}

class _TelaDownloadState extends State<TelaDownload> {
  // * Contamos PASSOS INTEIROS, não um double que vai somando.
  // ! Somar _progresso += 0.10 dez vezes NÃO dá 1.0: dá 0.9999999999999999,
  // ! porque 0.10 não existe exato em binário. Ai o "if (_progresso >= 1.0)"
  // ! não dispara, o timer segue para o 11o tique e a porcentagem mostra 110%
  // ! (a barra clampa em 100% e esconde o bug). Com int isso não acontece.
  int _passos = 0;
  Timer? _timer;

  static const _totalDePassos = 20;

  @override
  void initState() {
    super.initState();
    _iniciarDownload();
  }

  void _iniciarDownload() {
    _timer?.cancel();
    setState(() => _passos = 0);
    // Simula um download: a cada 300ms avanca um passo (5%).
    _timer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      setState(() => _passos++);
      if (_passos >= _totalDePassos) {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    // ! Sempre cancele o Timer no dispose; senão ele continua chamando setState
    // ! depois que a tela saiu e o app quebra.
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final concluido = _passos >= _totalDePassos;
    final porcentagem = _passos * 100 ~/ _totalDePassos;

    return Scaffold(
      appBar: AppBar(title: const Text('Progresso determinado')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // * value definido (0.0 a 1.0) = barra determinada: preenche até o
            // ponto certo em vez de animar sem fim.
            // No determinado o semanticsValue sai de graca: o próprio Flutter
            // preenche com a porcentagem. O label e que precisa ser seu.
            LinearProgressIndicator(semanticsLabel: 'Baixando arquivo'),
            const SizedBox(height: 16),
            Text(
              concluido ? 'Download concluido' : 'Baixando... $porcentagem%',
            ),
            const SizedBox(height: 24),
            // O mesmo value também vale no circular (vira um anel que enche).
            SizedBox(
              width: 64,
              height: 64,
              child: const CircularProgressIndicator(),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: concluido ? _iniciarDownload : null,
              child: const Text('Baixar de novo'),
            ),
          ],
        ),
      ),
    );
  }
}
