import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:warehouse/stock_recon/models/modelsRecon.dart';

class ApiService {
  final String apiUrl;
  final String token;

  ApiService({required this.apiUrl, required this.token});

  Future<ReconDetails> fetchUnacknowledgedData(String id) async {
    final uri = Uri.parse('$apiUrl/$id');
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final reconDetails = ReconDetails.fromJson(jsonData);
      return reconDetails;
    } else {
      throw Exception('Failed to load data');
    }
  }
}
