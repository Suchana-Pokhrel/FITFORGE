import 'package:fitforge/screens/admin_dashboard.dart';
import 'package:fitforge/screens/home_screen.dart';
import 'package:fitforge/screens/register_screen.dart';
import 'package:fitforge/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  final bool startAsAdmin;
  const LoginScreen({super.key, this.startAsAdmin = false});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;
  late bool isAdmin;

  // SAME URL THAT WORKED FOR REGISTER
  final String apiUrl =
      "http://192.168.1.9:8080/fitforge_backend/api/login.php";

  @override
  void initState() {
    super.initState();
    isAdmin = widget.startAsAdmin;
  }

  Future<void> login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"}, // ← SAME AS REGISTER
        body: json.encode({
          // ← SAME AS REGISTER
          "email": emailController.text.trim(),
          "password": passwordController.text,
          "role": isAdmin ? "admin" : "user",
        }),
      );

      // Debug print
      print("Status: ${response.statusCode}");
      print("Body: ${response.body}");

      final data = json.decode(response.body);

      if (data['success'] == true) {
        Fluttertoast.showToast(
          msg: "Welcome ${data['user']['name']}!",
          backgroundColor: Colors.green,
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => isAdmin
                ? AdminDashboard() // ← YOUR ADMIN SCREEN
                : HomeScreen(),
          ),
        );
      } else {
        Fluttertoast.showToast(
          msg: data['message'],
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "No internet");
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F9),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                const Icon(
                  Icons.fitness_center,
                  size: 80,
                  color: Color(0xFF6A1B9A),
                ),
                const SizedBox(height: 16),
                Text(
                  "FitForge",
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF6A1B9A),
                  ),
                ),
                Text(
                  "Personalized Fitness & Nutrition",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 30),

                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 30,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // TOGGLE
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => isAdmin = false),
                                child: Container(
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: !isAdmin
                                        ? const Color(0xFF6A1B9A)
                                        : Colors.transparent,
                                    borderRadius: const BorderRadius.horizontal(
                                      left: Radius.circular(14),
                                    ),
                                    border: Border.all(
                                      color: const Color(0xFF6A1B9A),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "User",
                                      style: GoogleFonts.poppins(
                                        color: !isAdmin
                                            ? Colors.white
                                            : const Color(0xFF6A1B9A),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => isAdmin = true),
                                child: Container(
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: isAdmin
                                        ? const Color(0xFF6A1B9A)
                                        : Colors.transparent,
                                    borderRadius: const BorderRadius.horizontal(
                                      right: Radius.circular(14),
                                    ),
                                    border: Border.all(
                                      color: const Color(0xFF6A1B9A),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Admin",
                                      style: GoogleFonts.poppins(
                                        color: isAdmin
                                            ? Colors.white
                                            : const Color(0xFF6A1B9A),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),

                        Text(
                          isAdmin ? "Admin Login" : "Welcome Back",
                          style: GoogleFonts.poppins(
                            fontSize: 26,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 32),

                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: isAdmin
                                ? "admin@fitforge.com"
                                : "your@email.com",
                            prefixIcon: const Icon(
                              Icons.email_outlined,
                              color: Colors.grey,
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF5F5F5),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: Validators.validateEmail,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: "••••••••",
                            prefixIcon: const Icon(
                              Icons.lock_outline,
                              color: Colors.grey,
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF5F5F5),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: Validators.validatePassword,
                        ),
                        const SizedBox(height: 20),

                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6A1B9A),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Text(
                                    "Sign In",
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      RegisterScreen(startAsAdmin: isAdmin),
                                ),
                              );
                            },
                            child: RichText(
                              text: TextSpan(
                                text: isAdmin
                                    ? "Need admin account? "
                                    : "Don't have an account? ",
                                style: GoogleFonts.poppins(
                                  color: Colors.grey[600],
                                ),
                                children: [
                                  TextSpan(
                                    text: isAdmin ? "Register" : "Sign up",
                                    style: GoogleFonts.poppins(
                                      color: const Color(0xFF6A1B9A),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  "Your personalized fitness journey starts here",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[600],
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
