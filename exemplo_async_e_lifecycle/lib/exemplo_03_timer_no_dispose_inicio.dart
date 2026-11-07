// exemplo_03_timer_no_dispose_inicio.dart
// Ponto de partida: um cronômetro que começa no `initState` — e nunca para.
//
// O `dispose` desta tela não cancela o timer. Há um interruptor para a guarda
// `if (!mounted) return` do callback, e um placar de "ticks fantasma" no menu:
// ele conta os ticks que chegam DEPOIS de a tela morrer.
//
// Experimente, nesta ordem:
//   1. entre no cronômetro, espere alguns segundos, volte — e olhe o placar;
//   2. ligue a guarda `mounted` e repita.
//
// ! Com a guarda LIGADA o console fica em silêncio. E o placar continua subindo.
//
// ? A guarda parece ter resolvido, e não resolveu nada: ela só desviou o tick.
// ?
// ?   **o que, de fato, PARA o timer?**

import 'dart:async';

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaMenu()));

// Interruptores da demo (globais só para o professor mexer neles ao vivo).
final cancelarNoDispose = ValueNotifier(true);
final checarMounted = ValueNotifier(true);

// Quantos ticks chegaram depois que a tela do cronômetro já tinha sido
// descartada. E o "fantasma" ficando visível.
final ticksFantasma = ValueNotifier(0);

class TelaMenu extends StatelessWidget {
  const TelaMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menu')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _Interruptor(
              flag: cancelarNoDispose,
              titulo: '_timer?.cancel() no dispose',
              subtitulo: 'a cura de verdade: para o timer',
            ),
            _Interruptor(
              flag: checarMounted,
              titulo: 'if (!mounted) return no callback',
              subtitulo: 'so evita o erro -- nao para o timer',
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const TelaCronometro())),
              child: const Text('Abrir cronometro'),
            ),
            const SizedBox(height: 24),
            const _PlacarFantasma(),
          ],
        ),
      ),
    );
  }
}

class const _Interruptor({
  required final ValueNotifier<bool> flag,
  required final String titulo,
  required final String subtitulo,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: flag,
      builder: (context, ligado, _) => SwitchListTile(
        value: ligado,
        onChanged: (novo) => flag.value = novo,
        title: Text(titulo),
        subtitle: Text(subtitulo),
      ),
    );
  }
}

class _PlacarFantasma extends StatelessWidget {
  const _PlacarFantasma();

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;

    return ValueListenableBuilder(
      valueListenable: ticksFantasma,
      builder: (context, ticks, _) => Card(
        color: ticks == 0
            ? cores.surfaceContainerHighest
            : cores.errorContainer,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text('$ticks', style: const TextStyle(fontSize: 40)),
              const Text(
                'ticks que chegaram DEPOIS de a tela morrer',
                textAlign: TextAlign.center,
              ),
              if (ticks > 0)
                const Text(
                  'e o console nao imprimiu nada',
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class TelaCronometro extends StatefulWidget {
  const TelaCronometro({super.key});

  @override
  State<TelaCronometro> createState() => _TelaCronometroState();
}

class _TelaCronometroState extends State<TelaCronometro> {
  // Guardamos o Timer num campo — justamente para poder cancelá-lo depois.
  // ! E, por enquanto, ninguém o cancela.
  // ignore: unused_field
  Timer? _timer;
  int _segundos = 0;

  @override
  void initState() {
    super.initState();
    // O timer começa aqui, junto com a tela.
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      // Se a tela já morreu e o timer não foi cancelado, o tick ainda chega.
      // O placar do menu conta exatamente estes.
      if (!mounted) ticksFantasma.value++;

      // ! A guarda só DESVIA o tick. O timer continua rodando, o State continua
      // ! preso na memória e o console fica em silêncio -- vazamento invisível.
      if (checarMounted.value && !mounted) return;

      setState(() => _segundos++);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cronometro')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('$_segundos s', style: const TextStyle(fontSize: 48)),
            const Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'Volte para o menu e observe o placar.',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
