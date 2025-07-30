import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('About Ofijan'),
        content: const Text(
          'Ofijan is an exam preparation platform providing access to model exams, exit exams, and more.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              launchUrl(Uri.parse('https://ofijan.com'));
            },
            child: const Text('Visit Website'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _launchURL(String url) async {
    if (!await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF594FB6), // Full purple background
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ Custom logo image
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage('images/ofijan_logo.png'),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Ofijan",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                const Text(
                  "Empowering Exam Prep",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Help?'),
            onTap: () => _showHelpDialog(context),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
          ListTile(
            leading: const Icon(Icons.article),
            title: const Text('Blog'),
            onTap: () {
              _launchURL('https://ofijan.com/blog');
            },
          ),
          ListTile(
            leading: const Icon(Icons.school),
            title: const Text('Scholarship'),
            onTap: () {
              _launchURL('https://ofijan.com/scholarship');
            },
          ),
          const Spacer(),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.telegram),
            title: const Text('Join Telegram'),
            onTap: () {
              _launchURL('https://t.me/OfijanTelegram');
            },
          ),
          ListTile(
            leading: const Icon(Icons.link),
            title: const Text('Visit Website'),
            onTap: () {
              _launchURL('https://ofijan.com');
            },
          ),
        ],
      ),
    );
  }
}
