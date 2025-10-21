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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao carregar quadras: $e'),
          backgroundColor: const Color(0xFFc33),
        ),
      );
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
        SnackBar(
          content: Text('Erro ao carregar horários da quadra: $e'),
          backgroundColor: const Color(0xFFc33),
        ),
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

  List<TimeOfDay> _getHorariosDisponiveis() {
    if (scheduleQuadra == null) return [];

    final openingTime = _parseTimeString(scheduleQuadra!['opening_time']);
    final closingTime = _parseTimeString(scheduleQuadra!['closing_time']);
    final gameDuration = scheduleQuadra!['game_duration'] as int;

    List<TimeOfDay> horarios = [];
    TimeOfDay currentTime = openingTime;

    while (currentTime.hour < closingTime.hour ||
        (currentTime.hour == closingTime.hour &&
            currentTime.minute <= closingTime.minute)) {
      final horarioFim = _calcularHorarioFim(currentTime);

      // Verifica se o horário final não ultrapassa o closing time
      if (horarioFim.hour < closingTime.hour ||
          (horarioFim.hour == closingTime.hour &&
              horarioFim.minute <= closingTime.minute)) {
        horarios.add(currentTime);
      }

      // Avança pelo game_duration em minutos
      int totalMinutes =
          currentTime.hour * 60 + currentTime.minute + gameDuration;
      int hour = totalMinutes ~/ 60;
      int minute = totalMinutes % 60;

      currentTime = TimeOfDay(hour: hour, minute: minute);
    }

    return horarios;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf5f5f5),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFf5f5f5), Color(0xFFe8f5e8)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // Header com logo e botão voltar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'assets/images/logo_transparent.png',
                      height: 40,
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF666666),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(color: const Color(0xFFe0e0e0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Novo Agendamento',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${widget.estabelecimento['name']}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF666666),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // CORREÇÃO: Adicionado SingleChildScrollView
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Informações do estabelecimento
                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFf8f8f8),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: const Color(0xFFe0e0e0),
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Informações do Estabelecimento',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF333333),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Dias de funcionamento: ${_formatarDiasTrabalho(widget.estabelecimento['working_days'])}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF666666),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // Dropdown de quadras
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Quadra *',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF333333),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    isLoading
                                        ? Container(
                                            height: 56,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFfafafa),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                color: const Color(0xFFe0e0e0),
                                              ),
                                            ),
                                            child: const Center(
                                              child: CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                      Color
                                                    >(Color(0xFF2db95c)),
                                              ),
                                            ),
                                          )
                                        : DropdownButtonFormField<String>(
                                            decoration: InputDecoration(
                                              hintText: 'Selecione uma quadra',
                                              hintStyle: const TextStyle(
                                                color: Color(0xFF999999),
                                              ),
                                              filled: true,
                                              fillColor: const Color(
                                                0xFFfafafa,
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: const BorderSide(
                                                  color: Color(0xFFe0e0e0),
                                                  width: 2,
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: const BorderSide(
                                                  color: Color(0xFF2db95c),
                                                  width: 2,
                                                ),
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 14,
                                                  ),
                                            ),
                                            items: quadras.map((quadra) {
                                              return DropdownMenuItem(
                                                value: quadra['id'].toString(),
                                                child: Text(
                                                  '${quadra['name']}',
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                  ),
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
                                              await _carregarScheduleQuadra(
                                                int.parse(value!),
                                              );
                                            },
                                          ),
                                  ],
                                ),
                                const SizedBox(height: 24),

                                // Informações da quadra selecionada
                                if (scheduleQuadra != null) ...[
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFf0f9f0),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: const Color(0xFFc8e6c9),
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Informações da Quadra',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF2a7a2a),
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          '⏰ Horário: ${scheduleQuadra!['opening_time']} - ${scheduleQuadra!['closing_time']}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Color(0xFF333333),
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          '⏱️ Duração: ${scheduleQuadra!['game_duration']} minutos',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Color(0xFF333333),
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          '💰 Preço: R\$${scheduleQuadra!['price_brl']} / U\$${scheduleQuadra!['price_uyu']}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Color(0xFF333333),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                ],

                                // Seleção de data
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Data *',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF333333),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    TextFormField(
                                      decoration: InputDecoration(
                                        hintText: 'Selecione a data',
                                        hintStyle: const TextStyle(
                                          color: Color(0xFF999999),
                                        ),
                                        filled: true,
                                        fillColor: const Color(0xFFfafafa),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Color(0xFFe0e0e0),
                                            width: 2,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Color(0xFF2db95c),
                                            width: 2,
                                          ),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 14,
                                            ),
                                        suffixIcon: const Icon(
                                          Icons.calendar_today,
                                          color: Color(0xFF666666),
                                        ),
                                      ),
                                      readOnly: true,
                                      onTap: () async {
                                        final DateTime? picked =
                                            await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime.now(),
                                              lastDate: DateTime(
                                                DateTime.now().month + 2,
                                              ),
                                              selectableDayPredicate:
                                                  (DateTime day) {
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
                                  ],
                                ),
                                const SizedBox(height: 24),

                                // Seleção de horário inicial
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Horário Inicial *',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF333333),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    TextFormField(
                                      decoration: InputDecoration(
                                        hintText: 'Selecione o horário inicial',
                                        hintStyle: const TextStyle(
                                          color: Color(0xFF999999),
                                        ),
                                        filled: true,
                                        fillColor: const Color(0xFFfafafa),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Color(0xFFe0e0e0),
                                            width: 2,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Color(0xFF2db95c),
                                            width: 2,
                                          ),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 14,
                                            ),
                                        suffixIcon: const Icon(
                                          Icons.access_time,
                                          color: Color(0xFF666666),
                                        ),
                                      ),
                                      readOnly: true,
                                      onTap: () async {
                                        if (scheduleQuadra == null) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Selecione primeiro uma quadra',
                                              ),
                                              backgroundColor: Color(0xFFc33),
                                            ),
                                          );
                                          return;
                                        }

                                        final horariosDisponiveis =
                                            _getHorariosDisponiveis();

                                        if (horariosDisponiveis.isEmpty) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Não há horários disponíveis para esta quadra',
                                              ),
                                              backgroundColor: Color(0xFFc33),
                                            ),
                                          );
                                          return;
                                        }

                                        final TimeOfDay?
                                        picked = await showTimePicker(
                                          context: context,
                                          initialTime:
                                              horariosDisponiveis.first,
                                          builder:
                                              (
                                                BuildContext context,
                                                Widget? child,
                                              ) {
                                                return MediaQuery(
                                                  data: MediaQuery.of(context)
                                                      .copyWith(
                                                        alwaysUse24HourFormat:
                                                            true,
                                                      ),
                                                  child: child!,
                                                );
                                              },
                                        );

                                        if (picked != null) {
                                          // Verifica se o horário selecionado está na lista de horários disponíveis
                                          bool horarioValido =
                                              horariosDisponiveis.any(
                                                (horario) =>
                                                    horario.hour ==
                                                        picked.hour &&
                                                    horario.minute ==
                                                        picked.minute,
                                              );

                                          if (horarioValido) {
                                            setState(() {
                                              horarioInicioSelecionado = picked;
                                            });
                                          } else {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Horário não permitido. Selecione um horário válido.',
                                                ),
                                                backgroundColor: Color(0xFFc33),
                                              ),
                                            );
                                          }
                                        }
                                      },
                                      controller: TextEditingController(
                                        text: horarioInicioSelecionado != null
                                            ? '${horarioInicioSelecionado!.hour.toString().padLeft(2, '0')}:${horarioInicioSelecionado!.minute.toString().padLeft(2, '0')}'
                                            : '',
                                      ),
                                    ),
                                  ],
                                ),

                                // Exibição do horário de fim calculado
                                if (horarioInicioSelecionado != null &&
                                    scheduleQuadra != null) ...[
                                  const SizedBox(height: 24),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFe8f5e8),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: const Color(0xFF2db95c),
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      children: [
                                        Text(
                                          '⏰ Horário de Término: ${_calcularHorarioFim(horarioInicioSelecionado!).hour.toString().padLeft(2, '0')}:${_calcularHorarioFim(horarioInicioSelecionado!).minute.toString().padLeft(2, '0')}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF333333),
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          '💰 Valor Total: R\$${scheduleQuadra!['price_brl']} / U\$${scheduleQuadra!['price_uyu']}',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF2a7a2a),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                ],
                              ],
                            ),
                          ),
                        ),

                        // Botão Confirmar Agendamento (mantido fora do ScrollView)
                        Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF2db95c), Color(0xFF25a050)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF2db95c).withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () async {
                              if (quadraSelecionada == null ||
                                  dataSelecionada == null ||
                                  horarioInicioSelecionado == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Preencha todos os campos'),
                                    backgroundColor: Color(0xFFc33),
                                  ),
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
                                  _calcularHorarioFim(
                                    horarioInicioSelecionado!,
                                  ).hour,
                                  _calcularHorarioFim(
                                    horarioInicioSelecionado!,
                                  ).minute,
                                );

                                // MODIFICAÇÃO AQUI: Usar o formato correto para o backend
                                final startTimeFormatted =
                                    _formatDateTimeForBackend(startTime);
                                final endTimeFormatted =
                                    _formatDateTimeForBackend(endTime);

                                // Verificar disponibilidade
                                final disponibilidade = await ApiService.post(
                                  ApiConfig.checkAvailability,
                                  {
                                    'court_id': int.parse(quadraSelecionada!),
                                    'start_time':
                                        startTimeFormatted, // Formato corrigido
                                    'end_time':
                                        endTimeFormatted, // Formato corrigido
                                  },
                                );

                                if (disponibilidade['available'] == true) {
                                  // Criar agendamento
                                  await ApiService.post(ApiConfig.bookings, {
                                    'court_id': int.parse(quadraSelecionada!),
                                    'start_time':
                                        startTimeFormatted, // Formato corrigido
                                    'end_time':
                                        endTimeFormatted, // Formato corrigido
                                    'status': 'confirmed',
                                  });

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Agendamento realizado com sucesso!',
                                      ),
                                      backgroundColor: Color(0xFF2a7a2a),
                                      duration: Duration(seconds: 3),
                                    ),
                                  );

                                  // MODIFICAÇÃO: Retorna true para indicar que um agendamento foi feito
                                  Navigator.pop(context, true);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Horário indisponível'),
                                      backgroundColor: Color(0xFFc33),
                                    ),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Erro ao criar agendamento: $e',
                                    ),
                                    backgroundColor: const Color(0xFFc33),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              "Confirmar Agendamento",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
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

  String _formatDateTimeForBackend(DateTime dateTime) {
    final year = dateTime.year.toString();
    final month = dateTime.month.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final second = dateTime.second.toString().padLeft(2, '0');

    return '$year-$month-$day $hour:$minute:$second';
  }
}
