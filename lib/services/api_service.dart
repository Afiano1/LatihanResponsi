import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/space_data_model.dart';

/// Service untuk komunikasi dengan API SpaceFlight.
class ApiService {
  /// Base URL API.
  ///
  /// UBAH JIKA API BERBEDA:
  /// - Kalau di quiz nanti base URL-nya beda,
  ///   misal 'https://myapi.com/v1', ganti saja di sini.
  final String _baseUrl = "https://api.spaceflightnewsapi.net/v4";

  /// Mengambil list data (articles, blogs, reports).
  ///
  /// [endpoint] bisa berupa:
  /// - 'articles'
  /// - 'blogs'
  /// - 'reports'
  ///
  /// UBAH JIKA API BERBEDA:
  /// - Jika endpoint nya beda, misal 'news' bukan 'articles',
  ///   maka yang diganti adalah nilai [endpoint] saat pemanggilan
  ///   di HomePage / ListPage, bukan di fungsi ini.
  Future<List<SpaceData>> fetchData(String endpoint) async {
    final response = await http.get(Uri.parse('$_baseUrl/$endpoint/'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      /// UBAH JIKA API BERBEDA:
      /// - Di API ini, list ada di key 'results'.
      /// - Kalau API lain pakai 'data' atau 'items', ganti di sini.
      final List results = jsonResponse['results'];

      return results.map((e) => SpaceData.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat data');
    }
  }

  /// Mengambil detail data sesuai id
  /// Contoh: https://api.spaceflightnewsapi.net/v4/articles/27413/
  ///
  /// UBAH JIKA API BERBEDA:
  /// - Kalau pattern URL detailnya beda, sesuaikan format Uri.parse di bawah.
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
