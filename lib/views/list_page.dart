import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/space_data_model.dart';
import 'detail_page.dart';

class ListPage extends StatelessWidget {
  final String title; // "News", "Blog", "Report"
  final String endpoint; // 'articles', 'blogs', 'reports'

  const ListPage({super.key, required this.title, required this.endpoint});

  @override
  Widget build(BuildContext context) {
    final ApiService apiService = ApiService();

    // ==============================
    // UBAH JIKA API DIGANTI:
    // ------------------------------
    // - Di sini hanya teks judul AppBar saja.
    // - Kalau di kuis nanti nama endpoint untuk news/blog/report beda,
    //   logika ini boleh diubah sesuai kebutuhan tampilan.
    //   (misal endpoint 'news', 'blog_post', dst).
    // ==============================
    String appBarTitle;
    switch (endpoint) {
      case 'articles':
        appBarTitle = "Berita Terkini";
        break;
      case 'blogs':
        appBarTitle = "Blog Terkini";
        break;
      case 'reports':
        appBarTitle = "Report Terkini";
        break;
      default:
        appBarTitle = "$title Terkini";
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF3E8FF),
      appBar: AppBar(
        title: Text(appBarTitle),
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<List<SpaceData>>(
        // ======================================
        // UBAH JIKA API DIGANTI:
        // --------------------------------------
        // - Sekarang list data diambil dengan:
        //     GET {baseUrl}/{endpoint}/
        //   lewat ApiService.fetchData(endpoint).
        // - Kalau di kuis nanti:
        //     * URL-nya beda
        //     * atau butuh query param khusus
        //   maka yang diubah adalah isi fungsi
        //   ApiService.fetchData() dan cara
        //   memanggilnya di sini (misal:
        //   apiService.fetchData('news') atau
        //   apiService.fetchNews(page:1) dsb).
        //
        // - TAPI: struktur list yang dikembalikan
        //   ke sini tetap List<SpaceData>.
        //   Jadi model SpaceData.fromJson juga
        //   harus disesuaikan ketika API berubah.
        // ======================================
        future: apiService.fetchData(endpoint),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Tidak ada data"));
          }

          final dataList = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: dataList.length,
            itemBuilder: (context, index) {
              final data = dataList[index];

              // ======================================
              // UBAH JIKA API DIGANTI (LEVEL DATA):
              // --------------------------------------
              // - Field yang digunakan di sini:
              //     data.id         -> untuk detail
              //     data.imageUrl   -> gambar
              //     data.title
              //     data.newsSite
              //     data.publishedAt
              // - Kalau nama field di JSON beda,
              //   ubah mapping-nya di SpaceData.fromJson
              //   (bukan di sini).
              // ======================================
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(
                          endpoint: endpoint,
                          id: data.id, // <-- wajib ada id dari API
                          pageTitle: "$title Detail",
                        ),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (data.imageUrl.isNotEmpty)
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          child: Image.network(
                            data.imageUrl,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,

                            // ======================================
                            // AGAR TIDAK MUNCUL ERROR TEKS PANJANG
                            // KETIKA GAMBAR GAGAL DI-LOAD:
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 200,
                                width: double.infinity,
                                color: Colors.grey[300],
                                alignment: Alignment.center,
                                child: const Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.broken_image, size: 40),
                                    SizedBox(height: 8),
                                    Text(
                                      "Gambar tidak tersedia",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              data.newsSite,
                              style: const TextStyle(
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              data.publishedAt,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
