import 'package:fitforge/screens/questionnaire_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  //Auto generated plan for total beginner

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: _buildAppBar(context),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isSmall = constraints.maxWidth < 650; // Responsive check
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // MAIN TITLE
                Center(
                  child: Text(
                    "Start Your Fitness Journey",
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                Text(
                  "Select the path that best describes your fitness knowledge",
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),

                // RESPONSIVE LAYOUT
                isSmall
                    ? Column(
                        children: [
                          _buildPathCard(
                            context: context,
                            icon: Icons.sentiment_satisfied,
                            iconColor: const Color(0xFFE1BEE7),
                            title: "I'm a Total Beginner",
                            subtitle:
                                "\nWe'll guide you with safe, proven beginner programs.",
                            features: const [
                              "Auto-filled with safest beginner defaults",
                              "Nepali-friendly food options included",
                              "20 hand-picked world-famous beginner programs",
                            ],
                            buttonText: "Start as Beginner",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      QuestionnaireScreen(isBeginnerMode: true),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          _buildPathCard(
                            context: context,
                            icon: Icons.psychology,
                            iconColor: const Color(0xFFB3E5FC),
                            title: "I know about Fitness",
                            subtitle:
                                "Answer our detailed questionnaire for perfect plans",
                            features: const [
                              "Customized questionnaire based on your goals",
                              "Precise matching with 500+ expert-created plans",
                              "Choose intensity, equipment, and schedule",
                            ],
                            buttonText: "Take Questionnaire",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const QuestionnaireScreen(
                                        isBeginnerMode: false,
                                      ),
                                ),
                              );
                            },
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: _buildPathCard(
                              context: context,
                              icon: Icons.sentiment_satisfied,
                              iconColor: const Color(0xFFE1BEE7),
                              title: "I'm a Total Beginner",
                              subtitle:
                                  "\nWe'll guide you with safe, proven beginner programs.",
                              features: const [
                                "Auto-filled with safest beginner defaults",
                                "Nepali-friendly food options included",
                                "20 hand-picked world-famous beginner programs",
                              ],
                              buttonText: "Start as Beginner",
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => QuestionnaireScreen(
                                      isBeginnerMode: true,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: _buildPathCard(
                              context: context,
                              icon: Icons.psychology,
                              iconColor: const Color(0xFFB3E5FC),
                              title: "I know about Fitness",
                              subtitle:
                                  "Answer our detailed questionnaire for perfect plans",
                              features: const [
                                "Customized questionnaire based on your goals",
                                "Precise matching with 500+ expert-created plans",
                                "Choose intensity, equipment, and schedule",
                              ],
                              buttonText: "Take Questionnaire",
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const QuestionnaireScreen(
                                          isBeginnerMode: false,
                                        ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),

                const SizedBox(height: 40),

                // FOOTER TEXT
                Text(
                  "Your personalized fitness journey starts here",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }

  // APP BAR

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF6A1B9A),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.fitness_center,
              size: 28,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "FitForge",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                "Choose Your Path",
                style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/login',
              (route) => false,
            );
          },
          child: Text(
            "Logout",
            style: GoogleFonts.poppins(
              color: const Color(0xFF6A1B9A),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const Icon(Icons.logout, size: 18, color: Color(0xFF6A1B9A)),
        const SizedBox(width: 16),
      ],
    );
  }

  // CARD WIDGET

  Widget _buildPathCard({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required List<String> features,
    required String buttonText,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: iconColor, shape: BoxShape.circle),
            child: Icon(icon, size: 42, color: const Color(0xFF6A1B9A)),
          ),

          const SizedBox(height: 18),

          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),

          Text(
            subtitle,
            style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[700]),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 18),

          // FEATURES
          ...features.map(
            (f) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    size: 18,
                    color: Color(0xFF6A1B9A),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(f, style: GoogleFonts.poppins(fontSize: 13)),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // BUTTON
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6A1B9A),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                buttonText,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
