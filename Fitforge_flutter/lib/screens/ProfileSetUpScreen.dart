// screens/profile_setup_screen.dart
import 'package:fitforge/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileSetupScreen extends StatefulWidget {
  final int userId;
  final String userName;
  final VoidCallback onComplete;

  const ProfileSetupScreen({
    Key? key,
    required this.userId,
    required this.userName,
    required this.onComplete,
  }) : super(key: key);

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final ageC = TextEditingController();
  final heightC = TextEditingController();
  final weightC = TextEditingController();

  String gender = "Male";
  String goal = "Weight Loss";
  String activity = "Moderately Active";

  final goals = [
    "Weight Loss",
    "Muscle Gain",
    "Toning",
    "General Fitness",
    "Improve Endurance",
  ];
  final activities = [
    "Sedentary",
    "Lightly Active",
    "Moderately Active",
    "Very Active",
    "Super Active",
  ];

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: Color(0xFF6A1B9A)),
      ),
    );

    try {
      final response = await http.post(
        Uri.parse(
          "http://192.168.1.9:8080/fitforge_backend/api/save_profile.php",
        ),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "user_id": widget.userId,
          "age": int.tryParse(ageC.text) ?? 0,
          "height": int.tryParse(heightC.text) ?? 0,
          "weight": int.tryParse(weightC.text) ?? 0,
          "gender": gender,
          "goal": goal,
          "activity_level": activity,
        }),
      );

      final res = json.decode(response.body);

      // Close loading
      Navigator.pop(context);

      if (res['success']) {
        // SUCCESS → GO TO HOMESCREEN AND LET IT DO ITS JOB
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to save profile. Try again.")),
        );
      }
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("No internet")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F9),
      appBar: AppBar(
        title: Text(
          "Complete Your Profile",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: const Color(0xFF6B4EFF),
                child: const Icon(Icons.person, size: 60, color: Colors.white),
              ),
              const SizedBox(height: 20),
              Text(
                "Hi ${widget.userName}!",
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Tell us about yourself to get perfect plans",
                style: const TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 30),

              TextFormField(
                controller: ageC,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Age",
                  prefixIcon: Icon(Icons.cake),
                ),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField(
                value: gender,
                decoration: const InputDecoration(
                  labelText: "Gender",
                  prefixIcon: Icon(Icons.wc),
                ),
                items: ["Male", "Female", "Other"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => gender = v!),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: heightC,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Height (cm)",
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: weightC,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Weight (kg)",
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField(
                value: goal,
                decoration: const InputDecoration(labelText: "Main Goal"),
                items: goals
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => goal = v!),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField(
                value: activity,
                decoration: const InputDecoration(labelText: "Activity Level"),
                items: activities
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => activity = v!),
              ),

              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6A1B9A),
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  "Save & Start Journey",
                  style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
