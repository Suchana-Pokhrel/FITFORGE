import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'login_screen.dart'; // ← Make sure this file exists

class RegisterScreen extends StatefulWidget {
  final bool startAsAdmin;
  const RegisterScreen({super.key, this.startAsAdmin = false});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final secretKeyController = TextEditingController();

  bool isLoading = false;
  late bool isAdmin;

  // YOUR WORKING URL
  final String apiUrl =
      "http://192.168.1.9:8080/fitforge_backend/api/register.php";

  @override
  void initState() {
    super.initState();
    isAdmin = widget.startAsAdmin;
  }

  Future<void> register() async {
    if (!_formKey.currentState!.validate()) return;

    if (isAdmin && secretKeyController.text.trim() != "FITFORGE_ADMIN_2025") {
      Fluttertoast.showToast(
        msg: "Wrong Admin Key",
        backgroundColor: Colors.red,
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "name": nameController.text.trim(),
          "email": emailController.text.trim(),
          "password": passwordController.text,
          "role": isAdmin ? "admin" : "user",
          "secret_key": isAdmin ? secretKeyController.text.trim() : "",
        }),
      );

      final data = json.decode(response.body);

      if (data['success'] == true) {
        Fluttertoast.showToast(
          msg: data['message'] ?? "Registered Successfully!",
          backgroundColor: Colors.green,
        );
        // SUCCESS → GO TO LOGIN
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(startAsAdmin: isAdmin),
          ),
          (route) => false,
        );
      } else {
        Fluttertoast.showToast(
          msg: data['message'] ?? "Registration failed",
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "No internet or server down");
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
                const SizedBox(height: 40),
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
                const SizedBox(height: 50),

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
                                    borderRadius: BorderRadius.horizontal(
                                      left: Radius.circular(14),
                                    ),
                                    border: Border.all(
                                      color: Color(0xFF6A1B9A),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "User",
                                      style: GoogleFonts.poppins(
                                        color: !isAdmin
                                            ? Colors.white
                                            : Color(0xFF6A1B9A),
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
                                        ? Color(0xFF6A1B9A)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.horizontal(
                                      right: Radius.circular(14),
                                    ),
                                    border: Border.all(
                                      color: Color(0xFF6A1B9A),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Admin",
                                      style: GoogleFonts.poppins(
                                        color: isAdmin
                                            ? Colors.white
                                            : Color(0xFF6A1B9A),
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
                          isAdmin ? "Admin Registration" : "Create Account",
                          style: GoogleFonts.poppins(
                            fontSize: 26,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Full Name
                        TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                            hintText: "Full Name",
                            prefixIcon: Icon(Icons.person_outline),
                            filled: true,
                            fillColor: Color(0xFFF5F5F5),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (v) => v!.isEmpty ? "Name required" : null,
                        ),
                        const SizedBox(height: 20),

                        // Admin Secret Key (only shows when Admin)
                        if (isAdmin) ...[
                          TextFormField(
                            controller: secretKeyController,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: "Enter admin secret key",
                              prefixIcon: Icon(Icons.key),
                              filled: true,
                              fillColor: Color(0xFFF5F5F5),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            validator: (v) => v!.isEmpty ? "Required" : null,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Demo key: FITFORGE_ADMIN_2025",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],

                        // Email
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: "your@email.com",
                            prefixIcon: Icon(Icons.email_outlined),
                            filled: true,
                            fillColor: Color(0xFFF5F5F5),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (v) => v!.isEmpty || !v.contains('@')
                              ? "Valid email"
                              : null,
                        ),
                        const SizedBox(height: 20),

                        // Password
                        TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: "••••••••",
                            prefixIcon: Icon(Icons.lock_outline),
                            filled: true,
                            fillColor: Color(0xFFF5F5F5),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (v) =>
                              v!.length < 6 ? "Min 6 chars" : null,
                        ),
                        const SizedBox(height: 40),

                        // Button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : register,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF6A1B9A),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: isLoading
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text(
                                    isAdmin ? "Register Admin" : "Sign Up",
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Back to Login
                        Center(
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: RichText(
                              text: TextSpan(
                                text: isAdmin
                                    ? "Already have admin account? "
                                    : "Already have an account? ",
                                style: GoogleFonts.poppins(
                                  color: Colors.grey[600],
                                ),
                                children: [
                                  TextSpan(
                                    text: "Sign in",
                                    style: GoogleFonts.poppins(
                                      color: Color(0xFF6A1B9A),
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
