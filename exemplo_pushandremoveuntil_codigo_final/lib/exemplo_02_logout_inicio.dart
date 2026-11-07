// exemplo_02_logout_inicio.dart
// Ponto de partida: o caso canônico. Uma pilha de verdade — Login -> Home ->
// Perfil — e o botão "Sair" no perfil.
//
// * A saída usa `pushReplacement`, que é o que a aula anterior ensinou para
// * "voltar ao login sem deixar volta". E de fato: a tela de login aparece.
//
// ! Agora aperte o **voltar**. Você cai na **Home** — dentro do app, com a
// ! sessão encerrada.
//
// ! O `pushReplacement` fez exatamente o que promete: trocou **a rota do topo**.
// ! Ele substituiu o Perfil pelo Login, e a Home continuou lá embaixo, intacta.
// !
// !   antes:   [ Login, Home, Perfil ]
// !   depois:  [ Login, Home, Login  ]   <- e o voltar cai na Home
//
// ! Num logout isso é grave. Dependendo do app, a Home ainda mostra saldo,
// ! pedidos, mensagens — dados de uma sessão que já não existe.
//
// ? `pushReplacement` troca **uma** tela. Aqui é preciso remover **todas**. O
// ? bloco anterior já mostrou o método e o predicate que fazem isso.

import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: LoginPage()));

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: FilledButton(
          // push comum: empilha a Home por cima do Login.
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute<void>(builder: (_) => const HomePage())),
          child: const Text('Entrar'),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: FilledButton(
          onPressed: () => Navigator.of(
            context,
          ).push(MaterialPageRoute<void>(builder: (_) => const PerfilPage())),
          child: const Text('Abrir perfil'),
        ),
      ),
    );
  }
}

class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Neste ponto a pilha é: Login (base) -> Home -> Perfil (topo).
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: Center(
        child: FilledButton.tonal(
          onPressed: () {
            // aqui limparíamos a sessão/token do usuário...

            // ! pushReplacement troca só o topo: o Perfil sai, a Home fica.
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute<void>(builder: (_) => const LoginPage()),
              (route) => false,
            );
          },
          child: const Text('Sair'),
        ),
      ),
    );
  }
}
