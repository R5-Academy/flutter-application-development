// exemplo_03_mundo_real_inicio.dart
// Ponto de partida: agora o dado vem da internet de verdade. `buscarEndereco`
// bate no viaCEP (https://viacep.com.br), um serviço público e gratuito, e
// devolve um `Endereco` montado a partir do JSON da resposta.
//
// Rode: o CEP que já está no campo é buscado no `initState`, e o card aparece.
// Funciona.
//
// ? O botão "Buscar" está apagado, e é aí que mora a pergunta. A aula inteira
// ? insiste em NÃO recriar o Future — ele nasce no `initState` e fica quieto.
// ? Mas agora o usuário digitou outro CEP e quer o endereço dele.
// ?
// ?   **como refazer a busca, se recriar o Future é justamente o que não se
// ?   deve fazer?**
// ?
// ? A resposta é a exceção que confirma a regra, e ela cabe em três linhas.

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:material_ui/material_ui.dart';

void main() => runApp(const MaterialApp(home: TelaEndereco()));

class const Endereco({
  required final String cep,
  required final String logradouro,
  required final String bairro,
  required final String localidade,
  required final String uf,
}) {
  factory Endereco.fromJson(Map<String, dynamic> json) => Endereco(
    cep: json['cep'] as String,
    logradouro: json['logradouro'] as String,
    bairro: json['bairro'] as String,
    localidade: json['localidade'] as String,
    uf: json['uf'] as String,
  );
}

// Busca de verdade: uma requisição HTTP para o viaCEP, um serviço público que
// não pede cadastro nem chave de acesso.
Future<Endereco> buscarEndereco(String cep) async {
  final resposta = await http.get(Uri.https('viacep.com.br', '/ws/$cep/json/'));
  // ! CEP malformado (poucos dígitos) devolve 400 com uma página HTML.
  if (resposta.statusCode != 200) {
    throw Exception('o servidor respondeu ${resposta.statusCode}');
  }
  final mapa = jsonDecode(resposta.body) as Map<String, dynamic>;
  // ! CEP inexistente devolve 200 assim mesmo: o aviso vem dentro do corpo.
  if (mapa['erro'] != null) {
    throw Exception('CEP $cep não encontrado');
  }
  return Endereco.fromJson(mapa);
}

class TelaEndereco extends StatefulWidget {
  const TelaEndereco({super.key});

  @override
  State<TelaEndereco> createState() => _TelaEnderecoState();
}

class _TelaEnderecoState extends State<TelaEndereco> {
  final _campoCep = TextEditingController(text: '01001000');

  // Não é final: vamos reatribuir a cada busca.
  late Future<Endereco> _futureEndereco;

  @override
  void initState() {
    super.initState();
    _futureEndereco = buscarEndereco(_campoCep.text);
  }

  @override
  void dispose() {
    _campoCep.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buscar endereço')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _campoCep,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'CEP',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton(
                  onPressed: null,
                  child: const Text('Buscar'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: FutureBuilder<Endereco>(
                future: _futureEndereco,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Erro ao carregar: ${snapshot.error}');
                  }

                  return _CartaoEndereco(snapshot.data!);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class const _CartaoEndereco(final Endereco endereco) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(24),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.location_on, size: 40),
            const SizedBox(height: 16),
            Text(
              endereco.logradouro,
              style: const TextStyle(fontSize: 22),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text('${endereco.bairro} — ${endereco.localidade}/${endereco.uf}'),
            const SizedBox(height: 8),
            Text('CEP ${endereco.cep}'),
          ],
        ),
      ),
    );
  }
}
