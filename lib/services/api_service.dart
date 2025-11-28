import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/space_data_model.dart';


class ApiService {

  final String _baseUrl = "https://api.spaceflightnewsapi.net/v4";


  Future<List<SpaceData>> fetchData(String endpoint) async {
    final response = await http.get(Uri.parse('$_baseUrl/$endpoint/'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);


      final List results = jsonResponse['results'];

      return results.map((e) => SpaceData.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat data');
    }
  }


  Future<SpaceData> fetchDetail(String endpoint, int id) async {
    final response = await http.get(Uri.parse('$_baseUrl/$endpoint/$id/'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      return SpaceData.fromJson(jsonResponse);
    } else {
      throw Exception('Gagal memuat detail data');
    }
  }
}
