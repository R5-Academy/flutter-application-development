// exemplo_05_ux_completa_inicio.dart
// Ponto de partida: um botão "Salvar" que chama uma operação de 2 segundos.
//
// Rode e toque UMA vez: parece que nada aconteceu. Toque de novo, e de novo —
// e você acaba de salvar três vezes.
//
// ! Do ponto de vista do usuário, o app ficou mudo. Ele não sabe se o toque foi
// ! registrado, então ele toca outra vez. Num app real, isso é um pedido
// ! duplicado no servidor.
//
// ? O loading dos exemplos anteriores vinha de um `snapshot`. Aqui não existe
// ? `FutureBuilder` nenhum: existe um `await` dentro de um callback.
// ?
// ?   **de onde vem o "estou processando" quando não há snapshot?**
// ?
// ? A resposta são duas coisas ao mesmo tempo: avisar E impedir o segundo toque.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaFormulario()));

// Simula o envio de um formulário ao servidor.
Future<void> salvarNoServidor() async {
  await Future.delayed(const Duration(seconds: 2));
}

class TelaFormulario extends StatefulWidget {
  const TelaFormulario({super.key});

  @override
  State<TelaFormulario> createState() => _TelaFormularioState();
}

class _TelaFormularioState extends State<TelaFormulario> {
  Future<void> _salvar() async {
    // * Liga o loading e reconstroi: o botão já aparece ocupado no próximo frame.

    await salvarNoServidor();

    // ! Depois de um await, a tela pode ter sido fechada. Cheque mounted antes
    // ! de chamar setState -- senão arrisca erro. (Async: Armadilhas e aula
    // ! própria; aqui fica a versão segura.)
    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Salvo com sucesso')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Loading em acao')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const TextField(decoration: InputDecoration(labelText: 'Seu nome')),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                // * onPressed nulo enquanto salva = botão desabilitado. Impede o
                // duplo clique, um dos bugs mais comuns em formularios.
                onPressed: _salvar,
                child: const Text('Salvar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
