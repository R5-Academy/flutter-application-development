// exemplo_03_login_para_home_inicio.dart
// Ponto de partida: o login. A troca não é automática como no splash — ela parte
// de uma ação do usuário, e espera uma autenticação assíncrona antes de navegar.
//
// * Rode, toque em "Entrar", espere o carregamento. A home aparece.
//
// ! Agora aperte voltar. **Você volta para a tela de login — já autenticado.**
//
// ! Não é só estranho, é um problema de verdade:
// !
// !   o usuário logado vê um formulário pedindo que ele entre de novo
// !   ele pode tocar em "Entrar" e disparar uma segunda autenticação
// !   e num app com sessão, essa tela pode estar exibindo dados de antes do
// !   login
//
// ! Este é **o erro mais comum de navegação em Flutter**. Ele passa em todo
// ! teste manual do fluxo feliz, porque ninguém testa "logar e apertar voltar".
//
// ? A pergunta de novo: *"o usuário vai querer voltar para o login?"* Depois de
// ? entrar, nunca.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: LoginScreen()));

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _carregando = false;

  Future<void> _entrar() async {
    setState(() => _carregando = true);

    // Simula a chamada de autenticação (rede).
    await Future<void>.delayed(const Duration(seconds: 1));

    // ! async gap: o usuário pode ter saído durante o await. Cheque mounted.
    if (!mounted) return;

    // ! push: o login continua vivo embaixo. Voltar traz o usuário de volta
    // ! para ele — já logado.
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (novoContext) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: FilledButton(
          onPressed: _carregando ? null : _entrar,
          child: _carregando
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Entrar'),
        ),
      ),
    );
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
