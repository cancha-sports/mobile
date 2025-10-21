import 'package:flutter/material.dart';
import 'api_config.dart';
import 'api_service.dart';

class TelaNovoAgendamento extends StatefulWidget {
  final dynamic estabelecimento;

  const TelaNovoAgendamento({super.key, required this.estabelecimento});

  @override
  State<TelaNovoAgendamento> createState() => _TelaNovoAgendamentoState();
}

class _TelaNovoAgendamentoState extends State<TelaNovoAgendamento> {
  String? quadraSelecionada;
  DateTime? dataSelecionada;
  TimeOfDay? horarioInicioSelecionado;
  Map<String, dynamic>? scheduleQuadra;
  List<dynamic> quadras = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarQuadras();
  }

  Future<void> _carregarQuadras() async {
    try {
      final data = await ApiService.get(ApiConfig.courts);
      final quadrasFiltradas = data
          .where(
            (quadra) =>
                quadra['establishment_id'] == widget.estabelecimento['id'],
          )
          .toList();

      setState(() {
        quadras = quadrasFiltradas;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao carregar quadras: $e')));
    }
  }

  Future<void> _carregarScheduleQuadra(int courtId) async {
    try {
      final data = await ApiService.get(
        '${ApiConfig.courtSchedules}/court/$courtId',
      );
      if (data.isNotEmpty) {
        setState(() {
          scheduleQuadra = data[0];
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar horários da quadra: $e')),
      );
    }
  }

  bool _isDiaTrabalho(DateTime date) {
    // working_days: 1 = domingo, 2 = segunda, ..., 7 = sábado
    final weekday = date.weekday == 7
        ? 1
        : date.weekday + 1; // Ajuste para o formato do banco
    return widget.estabelecimento['working_days'].contains(weekday);
  }

  bool _isHorarioValido(TimeOfDay horario) {
    if (scheduleQuadra == null) return false;

    final openingTime = _parseTimeString(scheduleQuadra!['opening_time']);
    final closingTime = _parseTimeString(scheduleQuadra!['closing_time']);

    final horarioMinutes = horario.hour * 60 + horario.minute;
    final openingMinutes = openingTime.hour * 60 + openingTime.minute;
    final closingMinutes = closingTime.hour * 60 + closingTime.minute;

    return horarioMinutes >= openingMinutes && horarioMinutes <= closingMinutes;
  }

  TimeOfDay _parseTimeString(String timeString) {
    final parts = timeString.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }

  TimeOfDay _calcularHorarioFim(TimeOfDay inicio) {
    if (scheduleQuadra == null) return inicio;

    final gameDuration = scheduleQuadra!['game_duration'] as int;
    final totalMinutes = inicio.hour * 60 + inicio.minute + gameDuration;
    final hour = totalMinutes ~/ 60;
    final minute = totalMinutes % 60;

    return TimeOfDay(hour: hour, minute: minute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Agendamento'),
        backgroundColor: const Color.fromARGB(255, 185, 180, 224),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Informações do estabelecimento
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.estabelecimento['name'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Dias de funcionamento: ${_formatarDiasTrabalho(widget.estabelecimento['working_days'])}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Dropdown de quadras
            isLoading
                ? const CircularProgressIndicator()
                : DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Quadra',
                      border: OutlineInputBorder(),
                    ),
                    items: quadras.map((quadra) {
                      return DropdownMenuItem(
                        value: quadra['id'].toString(),
                        child: Text(
                          '${quadra['name']} - ${quadra['sport']?['name'] ?? 'Esporte'}',
                        ),
                      );
                    }).toList(),
                    onChanged: (value) async {
                      setState(() {
                        quadraSelecionada = value;
                        dataSelecionada = null;
                        horarioInicioSelecionado = null;
                        scheduleQuadra = null;
                      });
                      await _carregarScheduleQuadra(int.parse(value!));
                    },
                  ),
            const SizedBox(height: 16),

            // Informações da quadra selecionada
            if (scheduleQuadra != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Informações da Quadra:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Horário de funcionamento: ${scheduleQuadra!['opening_time']} - ${scheduleQuadra!['closing_time']}',
                      ),
                      Text(
                        'Duração do jogo: ${scheduleQuadra!['game_duration']} minutos',
                      ),
                      Text(
                        'Preço: R\$${scheduleQuadra!['price_brl']} / U\$${scheduleQuadra!['price_uyu']}',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Seleção de data
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Data',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(DateTime.now().year + 1),
                  selectableDayPredicate: (DateTime day) {
                    return _isDiaTrabalho(day);
                  },
                );
                if (picked != null) {
                  setState(() {
                    dataSelecionada = picked;
                  });
                }
              },
              controller: TextEditingController(
                text: dataSelecionada != null
                    ? '${dataSelecionada!.day.toString().padLeft(2, '0')}/${dataSelecionada!.month.toString().padLeft(2, '0')}/${dataSelecionada!.year.toString()}'
                    : '',
              ),
            ),
            const SizedBox(height: 16),

            // Seleção de horário inicial
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Horário Inicial',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.access_time),
              ),
              readOnly: true,
              onTap: () async {
                if (scheduleQuadra == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Selecione primeiro uma quadra'),
                    ),
                  );
                  return;
                }

                final TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: _parseTimeString(
                    scheduleQuadra!['opening_time'],
                  ),
                );

                if (picked != null && _isHorarioValido(picked)) {
                  setState(() {
                    horarioInicioSelecionado = picked;
                  });
                } else if (picked != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Horário fora do funcionamento da quadra'),
                    ),
                  );
                }
              },
              controller: TextEditingController(
                text: horarioInicioSelecionado != null
                    ? horarioInicioSelecionado!.format(context)
                    : '',
              ),
            ),
            const SizedBox(height: 16),

            // Exibição do horário de fim calculado
            if (horarioInicioSelecionado != null && scheduleQuadra != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Horário de Término: ${_calcularHorarioFim(horarioInicioSelecionado!).format(context)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Valor Total: R\$${scheduleQuadra!['price_brl']} / U\$${scheduleQuadra!['price_uyu']}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () async {
                if (quadraSelecionada == null ||
                    dataSelecionada == null ||
                    horarioInicioSelecionado == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Preencha todos os campos')),
                  );
                  return;
                }

                try {
                  final startTime = DateTime(
                    dataSelecionada!.year,
                    dataSelecionada!.month,
                    dataSelecionada!.day,
                    horarioInicioSelecionado!.hour,
                    horarioInicioSelecionado!.minute,
                  );

                  final endTime = DateTime(
                    dataSelecionada!.year,
                    dataSelecionada!.month,
                    dataSelecionada!.day,
                    _calcularHorarioFim(horarioInicioSelecionado!).hour,
                    _calcularHorarioFim(horarioInicioSelecionado!).minute,
                  );

                  // Verificar disponibilidade
                  final disponibilidade =
                      await ApiService.post(ApiConfig.checkAvailability, {
                        'court_id': int.parse(quadraSelecionada!),
                        'start_time': startTime.toIso8601String(),
                        'end_time': endTime.toIso8601String(),
                      });

                  if (disponibilidade['available'] == true) {
                    // Criar agendamento
                    await ApiService.post(ApiConfig.bookings, {
                      'court_id': int.parse(quadraSelecionada!),
                      'start_time': startTime.toIso8601String(),
                      'end_time': endTime.toIso8601String(),
                      'status': 'confirmed',
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Agendamento realizado com sucesso!'),
                        duration: Duration(seconds: 3),
                      ),
                    );
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Horário indisponível')),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao criar agendamento: $e')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text("CONFIRMAR AGENDAMENTO"),
            ),
          ],
        ),
      ),
    );
  }

  String _formatarDiasTrabalho(List<dynamic> workingDays) {
    final dias = {
      1: 'Dom',
      2: 'Seg',
      3: 'Ter',
      4: 'Qua',
      5: 'Qui',
      6: 'Sex',
      7: 'Sáb',
    };

    return workingDays.map((day) => dias[day] ?? '?').join(', ');
  }
}
