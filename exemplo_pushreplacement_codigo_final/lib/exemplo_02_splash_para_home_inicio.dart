// exemplo_02_splash_para_home_inicio.dart
// Ponto de partida: o caso mais clássico de todos — um splash que carrega
// alguma coisa e vai para a home. A troca acontece sozinha, sem botão, disparada
// no `initState`.
//
// * Rode e espere os 2 segundos. A home aparece. **Funciona.**
//
// ! Agora aperte o **voltar do sistema** (ou a seta da AppBar).
// !
// ! Você volta para o splash — e ele fica **girando para sempre**. A home não
// ! volta mais.
//
// ? Por que ele não recomeça a contagem? Porque o `push` não destruiu nada: o
// ? splash ficou **montado** embaixo o tempo todo. `initState` roda uma vez na
// ? vida de um `State`, e essa vez já passou. Ninguém vai chamar `_irParaHome`
// ? de novo.
//
// ! Medido: 20 segundos depois de voltar, o log continua
// ! `[initState, navega]` — sem um segundo `initState` — e o
// ! `CircularProgressIndicator` ainda está na tela. O usuário fica preso numa
// ! tela de carregamento que nunca carrega; o próximo toque no voltar fecha o
// ! app, porque agora só existe uma rota na pilha.
//
// ! É o pior sintoma possível do `push` num lugar onde ele não cabe. E repare
// ! que ele só aparece **depois** de o app parecer pronto: o fluxo feliz
// ! funciona perfeitamente.
//
// ? A pergunta do bloco anterior responde na hora: *"o usuário vai querer
// ? voltar para o splash?"* Nunca.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: SplashScreen()));

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _irParaHome();
  }

  Future<void> _irParaHome() async {
    // Simula uma inicialização (checar sessão, carregar config, etc.).
    await Future<void>.delayed(const Duration(seconds: 2));

    // ! Depois do await o widget pode não estar mais na tela: cheque mounted
    // ! antes de usar o context.
    if (!mounted) return;

    // ! push: o splash continua na pilha, esperando o usuário "voltar" para ele.
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (novoContext) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Text(
          Navigator.canPop(context)
              ? 'canPop: true — a tela anterior continua na pilha.'
              : 'canPop: false — a tela anterior saiu da pilha.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
