import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/space_data_model.dart';
import 'detail_page.dart';

class ListPage extends StatelessWidget {
  final String title; 
  final String endpoint; 

  const ListPage({super.key, required this.title, required this.endpoint});

  @override
  Widget build(BuildContext context) {
    final ApiService apiService = ApiService();

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
                          id: data.id, // <--  id dari API
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
