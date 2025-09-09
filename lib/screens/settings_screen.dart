import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../services/api_service.dart';
import '../models/user.dart';
import 'home_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late Future<User> userFuture;

  @override
  void initState() {
    super.initState();
    userFuture = ApiService.fetchUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: const Color(0xFF594FB6),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => HomeScreen()),
            );
          },
        ),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text("Dark Mode"),
            value: themeProvider.themeMode == ThemeMode.dark,
            onChanged: (value) {
              themeProvider.toggleTheme(value);
            },
          ),
          const ListTile(
            title: Text("Language"),
            subtitle: Text("Coming soon..."),
          ),

          const Divider(),

          // ✅ User Info Section
          FutureBuilder<User>(
            future: userFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (snapshot.hasError) {
                return ListTile(
                  title: const Text("Error loading user info"),
                  subtitle: Text(snapshot.error.toString()),
                );
              } else if (!snapshot.hasData) {
                return const ListTile(title: Text("No user data found"));
              }

              final user = snapshot.data!;

              return Column(
                children: [
                  ListTile(
                    title: const Text("First Name"),
                    subtitle: Text(user.fname),
                  ),
                  ListTile(
                    title: const Text("Last Name"),
                    subtitle: Text(user.lname),
                  ),
                  ListTile(
                    title: const Text("Email"),
                    subtitle: Text(user.email),
                  ),
                  ListTile(
                    title: const Text("Phone"),
                    subtitle: Text(user.phone),
                  ),
                  ListTile(
                    title: const Text("Department"),
                    subtitle: Text(user.department),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.edit, color: Colors.black),
                        label: const Text(
                          "Edit Info",
                          style: TextStyle(color: Colors.black),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[200],
                        ),
                        onPressed: () {
                          _editUserInfo(user);
                        },
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.lock, color: Colors.black),
                        label: const Text(
                          "Change Password",
                          style: TextStyle(color: Colors.black),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[200],
                        ),
                        onPressed: () {
                          _changePassword();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  // ✅ Edit user info with fname + lname
  void _editUserInfo(User user) {
    final fnameController = TextEditingController(text: user.fname);
    final lnameController = TextEditingController(text: user.lname);
    final phoneController = TextEditingController(text: user.phone);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Info"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: fnameController,
              decoration: const InputDecoration(labelText: "First Name"),
            ),
            TextField(
              controller: lnameController,
              decoration: const InputDecoration(labelText: "Last Name"),
            ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: "Phone"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              await ApiService.updateUserInfo(
                fname: fnameController.text,
                lname: lnameController.text,
                phone: phoneController.text,
              );
              setState(() {
                userFuture = ApiService.fetchUserInfo();
              });
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  // ✅ Change password dialog
  void _changePassword() {
    final oldPassController = TextEditingController();
    final newPassController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Change Password"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldPassController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Old Password"),
            ),
            TextField(
              controller: newPassController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "New Password"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              await ApiService.changePassword(
                oldPassword: oldPassController.text,
                newPassword: newPassController.text,
              );
              Navigator.pop(context);
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }
}
