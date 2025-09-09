import 'package:flutter/material.dart';
import '../widgets/exam_card.dart';
import '../widgets/exam_section.dart';
import '../widgets/custom_drawer.dart';
import 'login_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<ExamSection> sections = const [
    ExamSection(title: 'Model Exam', icon: Icons.book),
    ExamSection(title: 'MoE Exit Exam', icon: Icons.school),
    ExamSection(title: 'EuEE', icon: Icons.edit_document),
    ExamSection(title: 'Blueprint', icon: Icons.library_books),
  ];

  void _showDownloadMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Download not available now"),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ keep the sidebar (drawer)
      drawer: CustomDrawer(),

      appBar: AppBar(
        title: const Text("Ofijan"),
        centerTitle: true,
        backgroundColor: const Color(0xFF594FB6),
        elevation: 0,
        // ensure hamburger shows & opens the drawer
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),

      backgroundColor: const Color(0xFFF7F7F7),

      body: SingleChildScrollView(
        child: Column(
          children: [
            // ✅ inspirational rounded card
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF594FB6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  // text side
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Welcome Back!",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "Keep learning, keep growing 💡",
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  // image side (uses your existing asset path)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset(
                      "assets/images/student.png",
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),

            // ✅ stacked modern cards (use your existing ExamCard)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: sections
                    .map(
                      (section) => Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: ExamCard(section: section),
                      ),
                    )
                    .toList(),
              ),
            ),

            // ✅ download button (shows not available)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: () => _showDownloadMessage(context),
                icon: const Icon(Icons.download, color: Colors.black),
                label: const Text(
                  "Download PDF",
                  style: TextStyle(color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Color(0xFF594FB6)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // ✅ footer with logout (left), home (middle), profile/settings (right)
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // logout -> login screen
              IconButton(
                icon: const Icon(Icons.logout, color: Color(0xFF594FB6)),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
              ),

              // center home icon
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFF594FB6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.home, color: Colors.white, size: 28),
              ),

              // profile -> settings screen
              IconButton(
                icon: const Icon(Icons.person, color: Color(0xFF594FB6)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SettingsScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
