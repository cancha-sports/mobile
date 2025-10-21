import 'package:flutter/material.dart';
import 'api_config.dart';
import 'api_service.dart';
import 'novo_agendamento_page.dart';

class TelaSelecionarEstabelecimento extends StatefulWidget {
  const TelaSelecionarEstabelecimento({super.key});

  @override
  State<TelaSelecionarEstabelecimento> createState() =>
      _TelaSelecionarEstabelecimentoState();
}

class _TelaSelecionarEstabelecimentoState
    extends State<TelaSelecionarEstabelecimento> {
  List<dynamic> estabelecimentos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarEstabelecimentos();
  }

  Future<void> _carregarEstabelecimentos() async {
    try {
      final data = await ApiService.get(ApiConfig.establishments);
      setState(() {
        estabelecimentos = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar estabelecimentos: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecionar Estabelecimento'),
        backgroundColor: const Color.fromARGB(255, 185, 180, 224),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: estabelecimentos.length,
              itemBuilder: (context, index) {
                final estabelecimento = estabelecimentos[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(estabelecimento['name']),
                    subtitle: Text(
                      'Lat: ${estabelecimento['latitude']}, Long: ${estabelecimento['longitude']}',
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TelaNovoAgendamento(
                            estabelecimento: estabelecimento,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
