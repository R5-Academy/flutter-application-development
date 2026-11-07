// exemplo_04_botao_conforme_campo_inicio.dart
// Ponto de partida: um formulário em que o botão "Enviar" deve habilitar quando
// o campo tiver texto.
//
// O `onChanged` já alimenta o `_texto` a cada dígito, e o notifier já avisa.
//
// ! O botão continua apagado, digite o que digitar. Ele decidiu o próprio
// ! `onPressed` no primeiro build, quando o campo estava vazio, e nunca mais
// ! reconsiderou.
//
// ? Repare que aqui o valor observado não é "o estado do app" — é um pedaço da
// ? UI virando estado. E repare também no par de objetos: um
// ? `TextEditingController` E um `ValueNotifier<String>` andando juntos.
// ?
// ?   **guarde esse par: a aula de `ListenableBuilder` mostra que um deles
// ?   sobra.**

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaFormulario()));

class TelaFormulario extends StatefulWidget {
  const TelaFormulario({super.key});

  @override
  State<TelaFormulario> createState() => _TelaFormularioState();
}

class _TelaFormularioState extends State<TelaFormulario> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Formulário')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Nome',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // O botão decide uma vez, no primeiro build — com o campo vazio.
            ValueListenableBuilder(
              valueListenable: _controller,
              builder: (_, textValue, child) {
                final habilitado =
                    textValue.text.trim().isNotEmpty &&
                    textValue.text.trim().length > 3;
                return FilledButton(
                  onPressed: habilitado
                      ? () => ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Enviando: $textValue.text')),
                        )
                      : null,
                  child: Text('Enviar'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
