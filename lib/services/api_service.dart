import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/medicine_model.dart';

class ApiService {
  static const _baseUrl = 'https://yassa-hany.com/api/MD';
  static const _headers = {
    'User-Agent': 'Dart/3.7 (dart:io)',
    'Accept-Encoding': 'gzip',
  };

  static Future<List<Medicine>> searchMedicine(String query) async {
    try {
      final uri = Uri.parse('$_baseUrl/search.php').replace(
        queryParameters: {'name': query},
      );
      final response = await http.get(uri, headers: _headers)
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          return data.map((e) => Medicine.fromSearchJson(e)).toList();
        } else if (data is Map && data['data'] is List) {
          return (data['data'] as List)
              .map((e) => Medicine.fromSearchJson(e))
              .toList();
        }
      }
      return [];
    } catch (e) {
      throw Exception('فشل الاتصال بالخادم');
    }
  }

  static Future<Medicine?> getMedicineInfo(String id) async {
    try {
      final uri = Uri.parse('$_baseUrl/info.php').replace(
        queryParameters: {'id': id},
      );
      final response = await http.get(uri, headers: _headers)
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is Map<String, dynamic>) {
          return Medicine.fromInfoJson(data);
        }
      }
      return null;
    } catch (e) {
      throw Exception('فشل تحميل تفاصيل الدواء');
    }
  }
}
