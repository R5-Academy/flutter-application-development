// exemplo_03_status_carregamento_inicio.dart
// Ponto de partida: uma busca com cara de app de verdade. O `_buscar()` já
// muda o status três vezes — parado, carregando, pronto — e o notifier já avisa.
//
// Rode e toque em Buscar.
//
// ! A tela não se mexe. Ela mostra "Toque em Buscar" do início ao fim, mesmo
// ! durante os dois segundos da requisição.
//
// ? Repare no tipo do notifier: `ValueNotifier<StatusCarga>`. O valor único não
// ? precisa ser um número — pode ser um enum que descreve a tela inteira.
// ?
// ?   **como fazer um widget diferente aparecer para cada valor desse enum?**

import 'package:material_ui/material_ui.dart';

// Um valor único pode ser um enum. Aqui ele modela o estado da tela.
enum StatusCarga { parado, carregando, pronto }

void main() => runApp(const MaterialApp(home: TelaBusca()));

class TelaBusca extends StatefulWidget {
  const TelaBusca({super.key});

  @override
  State<TelaBusca> createState() => _TelaBuscaState();
}

class _TelaBuscaState extends State<TelaBusca> {
  final _status = ValueNotifier<StatusCarga>(.parado);

  @override
  void dispose() {
    _status.dispose();
    super.dispose();
  }

  Future<void> _buscar() async {
    // Trocar o value já notifica: a tela mostra o spinner na hora.
    _status.value = .carregando;
    await Future.delayed(const Duration(seconds: 2)); // simula uma requisição
    _status.value = .pronto;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Status com ValueNotifier')),
      body: Center(
        // O texto é decidido uma vez, no primeiro build, e nunca mais.
        child: ValueListenableBuilder(
          valueListenable: _status,
          builder: (_, status, child) {
            return switch (status) {
              StatusCarga.parado => const Text('Toque em Buscar'),
              StatusCarga.carregando => const CircularProgressIndicator(),
              StatusCarga.pronto => const Text('Resultado carregado'),
            };
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _buscar,
        label: const Text('Buscar'),
        icon: const Icon(Icons.search),
      ),
    );
  }
}
