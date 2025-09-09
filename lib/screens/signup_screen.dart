// lib/screens/signup_screen.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // ✅ Add this
import '../services/api_service.dart';
import '../models/department.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _form = GlobalKey<FormState>();
  final _first = TextEditingController();
  final _last = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _pass = TextEditingController();
  final _confirm = TextEditingController();

  bool _loading = false;
  String? _error;
  int? _selectedDepartment;
  List<Department> _departments = [];

  @override
  void initState() {
    super.initState();
    _loadDeps();
  }

  Future<void> _loadDeps() async {
    try {
      final deps = await ApiService.fetchDepartments();
      setState(() {
        _departments = deps;
      });
    } catch (e) {
      // ignore
    }
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    if (_selectedDepartment == null) {
      setState(() {
        _error = 'Please select department';
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final success = await ApiService.register(
        firstName: _first.text.trim(),
        lastName: _last.text.trim(),
        email: _email.text.trim(),
        phone: _phone.text.trim(),
        password: _pass.text,
        departmentId: _selectedDepartment!,
      );

      if (!mounted) return;

      if (success) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => LoginScreen()),
          (r) => false,
        );
      } else {
        setState(() {
          _error = "Registration failed. Please try again.";
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString().replaceAll("Exception: ", "");
      });
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<void> _openWebsiteSignup() async {
    const url = "https://ofijan.com/signup";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  @override
  void dispose() {
    _first.dispose();
    _last.dispose();
    _email.dispose();
    _phone.dispose();
    _pass.dispose();
    _confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final purple = const Color(0xFF694BCF);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: purple,
        title: const Text('Create account'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Form(
            key: _form,
            child: Column(
              children: [
                Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      children: [
                        // --- Name fields ---
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _first,
                                decoration: const InputDecoration(
                                  labelText: 'First name',
                                ),
                                validator: (v) => v == null || v.isEmpty
                                    ? 'Enter first'
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: _last,
                                decoration: const InputDecoration(
                                  labelText: 'Last name',
                                ),
                                validator: (v) => v == null || v.isEmpty
                                    ? 'Enter last'
                                    : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // --- Email ---
                        TextFormField(
                          controller: _email,
                          decoration: const InputDecoration(labelText: 'Email'),
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) => v == null || !v.contains('@')
                              ? 'Enter valid email'
                              : null,
                        ),
                        const SizedBox(height: 12),

                        // --- Phone + Department ---
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _phone,
                                decoration: const InputDecoration(
                                  labelText: 'Phone',
                                ),
                                keyboardType: TextInputType.phone,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: DropdownButtonFormField<int>(
                                value: _selectedDepartment,
                                items: _departments
                                    .map(
                                      (d) => DropdownMenuItem(
                                        value: d.id,
                                        child: Text(d.title),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (v) =>
                                    setState(() => _selectedDepartment = v),
                                decoration: const InputDecoration(
                                  labelText: 'Department',
                                ),
                                validator: (v) =>
                                    v == null ? 'Choose department' : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // --- Passwords ---
                        TextFormField(
                          controller: _pass,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                          ),
                          obscureText: true,
                          validator: (v) => (v == null || v.length < 6)
                              ? 'Min 6 chars'
                              : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _confirm,
                          decoration: const InputDecoration(
                            labelText: 'Confirm password',
                          ),
                          obscureText: true,
                          validator: (v) =>
                              v != _pass.text ? 'Passwords do not match' : null,
                        ),
                        const SizedBox(height: 12),

                        if (_error != null)
                          Text(
                            _error!,
                            style: const TextStyle(color: Colors.red),
                          ),

                        const SizedBox(height: 8),

                        // --- Submit Button ---
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _loading ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: purple,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: _loading
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Sign Up',
                                    style: TextStyle(fontSize: 16),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // --- Divider with OR ---
                Row(
                  children: const [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text("or"),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),

                const SizedBox(height: 12),

                // --- Website Signup ---
                OutlinedButton(
                  onPressed: _openWebsiteSignup,
                  child: const Text("Use website to signup"),
                ),

                const SizedBox(height: 12),

                // --- Google Signup (placeholder) ---
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Google signup not available yet"),
                      ),
                    );
                  },
                  icon: const Icon(Icons.g_mobiledata, size: 28),
                  label: const Text("Sign up with Google"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 48),
                    side: const BorderSide(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
