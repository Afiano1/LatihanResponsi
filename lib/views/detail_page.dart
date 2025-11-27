import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/space_data_model.dart';
import '../services/api_service.dart';

class DetailPage extends StatelessWidget {
  final String endpoint; // 'articles', 'blogs', 'reports'
  final int id;
  final String pageTitle; // contoh: 'News Detail', 'Blog Detail', dll

  const DetailPage({
    super.key,
    required this.endpoint,
    required this.id,
    required this.pageTitle,
  });

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $uri');
    }
  }

  @override
  Widget build(BuildContext context) {
    final apiService = ApiService();

    // Di sini kita pakai FutureBuilder sekali saja,
    // dan di dalamnya kita bangun Scaffold, body, dan FAB
    // supaya tidak memanggil API dua kali.
    return FutureBuilder<SpaceData>(
      // ======================================
      // UBAH JIKA API DIGANTI:
      // --------------------------------------
      // - Sekarang detail diambil dari:
      //     GET {baseUrl}/{endpoint}/{id}/
      //   lewat ApiService.fetchDetail(endpoint, id).
      // - Jika di kuis URL detail berbeda
      //   (misal pakai query ?id=, atau endpoint lain),
      //   ubah logika di ApiService.fetchDetail().
      //
      // - Premis: API tetap mengembalikan 1 objek
      //   yang bisa dimapping ke SpaceData.
      // ======================================
      future: apiService.fetchDetail(endpoint, id),
      builder: (context, snapshot) {
        final isLoading = snapshot.connectionState == ConnectionState.waiting;

        return Scaffold(
          backgroundColor: const Color(0xFFF3E8FF),
          appBar: AppBar(
            title: Text(pageTitle),
            backgroundColor: Colors.deepPurple,
          ),
          body: isLoading
              ? const Center(child: CircularProgressIndicator())
              : snapshot.hasError
                  ? Center(child: Text('Error: ${snapshot.error}'))
                  : !snapshot.hasData
                      ? const Center(child: Text('Data tidak ditemukan'))
                      : SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (snapshot.data!.imageUrl.isNotEmpty)
                                Image.network(
                                  snapshot.data!.imageUrl,
                                  width: double.infinity,
                                  fit: BoxFit.cover,

                                  // Sama seperti di ListPage:
                                  // kalau gambar gagal di-load, tampilkan
                                  // placeholder, bukan teks error HTTP.
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      height: 220,
                                      width: double.infinity,
                                      color: Colors.grey[300],
                                      alignment: Alignment.center,
                                      child: const Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.broken_image, size: 50),
                                          SizedBox(height: 8),
                                          Text(
                                            "Gambar tidak tersedia",
                                            style: TextStyle(fontSize: 13),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              Container(
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(24),
                                    topRight: Radius.circular(24),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // ======================================
                                      // UBAH JIKA API DIGANTI (LEVEL DATA):
                                      // --------------------------------------
                                      // - Field yang digunakan:
                                      //     snapshot.data!.title
                                      //     snapshot.data!.newsSite
                                      //     snapshot.data!.publishedAt
                                      //     snapshot.data!.summary
                                      //     snapshot.data!.url  (untuk See More)
                                      // - Kalau nama field di JSON beda,
                                      //   ubah mapping di SpaceData.fromJson.
                                      // ======================================
                                      Text(
                                        snapshot.data!.title,
                                        style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.public,
                                            size: 18,
                                            color: Colors.deepPurple,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            snapshot.data!.newsSite,
                                            style: const TextStyle(
                                              color: Colors.deepPurple,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.calendar_today,
                                            size: 16,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            snapshot.data!.publishedAt,
                                            style: const TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      Text(
                                        snapshot.data!.summary,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
          floatingActionButton: snapshot.hasData
              ? FloatingActionButton.extended(
                  onPressed: () => _launchUrl(snapshot.data!.url),
                  icon: const Icon(Icons.open_in_browser),
                  label: const Text("See More"),
                )
              : null,
        );
      },
    );
  }
}
