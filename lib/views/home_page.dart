import 'package:flutter/material.dart';
import '../config/session_manager.dart';
import 'list_page.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String username = "";

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    String? u = await SessionManager().getUsername();
    setState(() {
      username = u ?? "User";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3E8FF),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.deepPurple,
  
        title: Text("Hai, $username!"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await SessionManager().logout();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              }
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "SpaceFlight News",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Pilih kategori untuk melihat informasi terbaru.",
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 24),
            _buildMenuCard(
              context,
              "News",
              "articles", // (nama endpoint untuk news)
              Icons.newspaper,
              Colors.blue[100]!,
              "Get an overview of the latest SpaceFlight news.",
            ),
            _buildMenuCard(
              context,
              "Blog",
              "blogs", //  (nama endpoint untuk blog)
              Icons.book,
              Colors.green[100]!,
              "Blogs provide more detailed overview of launches.",
            ),
            _buildMenuCard(
              context,
              "Report",
              "reports", //  (nama endpoint untuk report)
              Icons.analytics,
              Colors.purple[100]!,
              "Reports berisi data dan analisis misi.",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    String title,
    String endpoint,
    IconData icon,
    Color color,
    String description,
  ) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ListPage(title: title, endpoint: endpoint),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, size: 32, color: Colors.deepPurple),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
