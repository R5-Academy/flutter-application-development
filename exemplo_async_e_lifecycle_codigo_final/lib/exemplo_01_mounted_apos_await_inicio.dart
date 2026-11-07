// exemplo_01_mounted_apos_await_inicio.dart
// Ponto de partida: uma tela que carrega dados em 3 segundos e chama setState
// quando termina. Código comum, e ele funciona — desde que o usuário espere.
//
// Aperte "Carregar" e, DURANTE os 3 segundos de espera, aperte voltar.
//
// ! O console estoura:
// !   setState() called after dispose(): _TelaComAwaitState#f4056
// !   (lifecycle state: defunct, not mounted)
//
// ? Todo `await` abre uma fresta no tempo. Quem escreveu a linha de baixo do
// ? `await` presume que o mundo continua como estava — e ele pode não estar
// ? mais: a tela pode ter sido descartada nesse meio-tempo.
// ?
// ?   **como saber, depois do await, se este State ainda está vivo?**

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaInicial()));

// Tela de entrada só para termos um "voltar" de verdade: o botão empurra a
// TelaComAwait, e sair dela no meio da espera e o que expoe o problema.
class TelaInicial extends StatelessWidget {
  const TelaInicial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Async e Lifecycle')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const TelaComAwait())),
          child: const Text('Abrir tela que carrega'),
        ),
      ),
    );
  }
}

class TelaComAwait extends StatefulWidget {
  const TelaComAwait({super.key});

  @override
  State<TelaComAwait> createState() => _TelaComAwaitState();
}

class _TelaComAwaitState extends State<TelaComAwait> {
  var _texto = 'Aperte para carregar';

  Future<String> _buscar() async {
    await Future.delayed(const Duration(seconds: 3));
    return 'Dados carregados';
  }

  Future<void> _carregar() async {
    setState(() => _texto = 'Carregando...');

    final resultado = await _buscar();

    if (!mounted) return;

    // ! A FRESTA: nos 3 segundos acima o usuário pode ter saido da tela. Sem a
    // ! Este setState pode rodar num State já descartado.
    setState(() => _texto = resultado);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Carregando com await')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_texto, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: _carregar, child: const Text('Carregar')),
            const SizedBox(height: 8),
            const Text('Dica: aperte Carregar e saia da tela antes dos 3s.'),
          ],
        ),
      ),
    );
  }
}
