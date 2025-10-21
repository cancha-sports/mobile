import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class ApiService {
  static String? _token;

  static void setToken(String token) {
    _token = token;
  }

  static void clearToken() {
    _token = null;
  }

  static Map<String, String> get _headers {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (_token != null) 'Authorization': 'Bearer $_token',
    };
  }

  static Future<Map<String, dynamic>> post(
    String url,
    Map<String, dynamic> data,
  ) async {
    try {
      print('POST Request to: $url');
      print('Request data: $data');

      final response = await http.post(
        Uri.parse(url),
        headers: _headers,
        body: json.encode(data),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        throw Exception('Credenciais inválidas. Verifique email e senha.');
      } else if (response.statusCode == 400) {
        final errorData = json.decode(response.body);
        throw Exception(errorData['error'] ?? 'Dados inválidos');
      } else {
        throw Exception('Erro ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('Error in POST request: $e');
      rethrow;
    }
  }

  static Future<List<dynamic>> get(String url) async {
    try {
      print('GET Request to: $url');

      final response = await http.get(Uri.parse(url), headers: _headers);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        throw Exception('Não autorizado. Token inválido ou expirado.');
      } else {
        throw Exception('Falha na requisição: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in GET request: $e');
      rethrow;
    }
  }

  // Novo método para buscar estabelecimentos
  static Future<List<dynamic>> getEstablishments() async {
    return await get(ApiConfig.establishments);
  }

  // Novo método para buscar quadras por estabelecimento
  static Future<List<dynamic>> getCourtsByEstablishment(
    int establishmentId,
  ) async {
    return await get('${ApiConfig.courts}/establishment/$establishmentId');
  }

  // Novo método para buscar histórico de agendamentos
  static Future<List<dynamic>> getBookingHistory() async {
    return await get(ApiConfig.historyBookings);
  }
}
