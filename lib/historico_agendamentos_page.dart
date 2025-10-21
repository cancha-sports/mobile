import 'package:flutter/material.dart';
import 'api_config.dart';
import 'api_service.dart';

class TelaHistoricoAgendamentos extends StatefulWidget {
  const TelaHistoricoAgendamentos({super.key});

  @override
  State<TelaHistoricoAgendamentos> createState() =>
      _TelaHistoricoAgendamentosState();
}

class _TelaHistoricoAgendamentosState extends State<TelaHistoricoAgendamentos> {
  List<dynamic> historico = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarHistorico();
  }

  Future<void> _carregarHistorico() async {
    try {
      final data = await ApiService.get(ApiConfig.historyBookings);
      setState(() {
        historico = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao carregar histórico: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Agendamentos'),
        backgroundColor: const Color.fromARGB(255, 185, 180, 224),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Table(
                  border: TableBorder.all(color: Colors.grey.shade300),
                  children: [
                    // Cabeçalho da tabela
                    TableRow(
                      decoration: BoxDecoration(color: Colors.grey.shade200),
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Quadra',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Data',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Horário',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Status',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),

                    // Linhas da tabela com dados
                    ...historico.map((agendamento) {
                      return TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              agendamento['court']?['name'] ?? 'N/A',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              _formatarData(agendamento['start_time']),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              _formatarHorario(
                                agendamento['start_time'],
                                agendamento['end_time'],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              agendamento['status'] == 'confirmed'
                                  ? 'Concluído'
                                  : 'Cancelado',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: agendamento['status'] == 'confirmed'
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
      ),
    );
  }

  String _formatarData(String data) {
    final date = DateTime.parse(data);
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatarHorario(String inicio, String fim) {
    final start = DateTime.parse(inicio);
    final end = DateTime.parse(fim);
    return '${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')} - ${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}';
  }
}
