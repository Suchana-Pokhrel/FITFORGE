import 'package:fitforge/screens/Result_Screen.dart';
import 'package:fitforge/screens/plan_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class QuestionnaireScreen extends StatefulWidget {
  final bool isBeginnerMode;
  const QuestionnaireScreen({super.key, this.isBeginnerMode = false});

  @override
  State<QuestionnaireScreen> createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  int currentStep = 0;
  bool isLoading = false;

  // All answers
  List<String> selectedGoals = [];
  List<String> selectedWorkoutTypes = [];
  String? selectedExperience;
  String? selectedDiet;
  int trainingDays = 3;
  String? selectedEquipment;
  List<String> selectedInjuries = [];
  int mealsPerDay = 4;

  final List<Map<String, dynamic>> steps = [
    {
      "title": "What are your fitness goals",
      "subtitle": "Select all that apply",
      "type": "multi",
      "options": [
        "Lose Weight",
        "Gain Muscle",
        "Improve Endurance",
        "Increase Flexibility",
        "General Fitness",
      ],
      "key": "goals",
    },
    {
      "title": "What workout type interests you?",
      "subtitle": "Select all that apply",
      "type": "multi",
      "options": [
        "Full Body Workouts",
        "Upper/Lower Split",
        "Push/Pull/Legs",
        "Cardio Training",
        "Yoga & Flexibility",
      ],
      "key": "workout_types",
    },
    {
      "title": "What's your current fitness level?",
      "type": "single",
      "options": ["Beginner", "Intermediate", "Advanced"],
      "key": "experience",
    },
    {
      "title": "What's your Diet Preference?",
      "type": "single",
      "options": ["Vegetarian", "Non-Vegetarian", "Eggetarian", "Vegan"],
      "key": "diet", // ← FIXED: was "experience" before
    },
    {
      "title": "How many days can you train per week?",
      "type": "slider",
      "key": "training_days",
    },
    {
      "title": "What equipment do you have access to?",
      "type": "single",
      "options": [
        "Full Gym",
        "Dumbbells",
        "Bodyweight Only",
        "Resistance Bands",
      ],
      "key": "equipment",
    },
    {
      "title": "Any injuries or Limitations",
      "subtitle": "Select all that apply",
      "type": "multi",
      "options": [
        "Knee Pain",
        "Back Pain",
        "Shoulder Pain",
        "Wrist Pain",
        "None",
      ],
      "key": "injuries",
    },
    {
      "title": "How many meals do you prefer per day?",
      "type": "single",
      "options": ["3", "4", "5+"],
      "key": "meals",
    },
  ];

  @override
  void initState() {
    super.initState();
    if (widget.isBeginnerMode) {
      _applyBeginnerDefaults(); // ← THIS WAS MISSING IN YOUR CODE
    }
  }

  // ← THIS FUNCTION WAS MISSING — NOW ADDED
  void _applyBeginnerDefaults() {
    setState(() {
      selectedGoals = ["General Fitness"];
      selectedWorkoutTypes = ["Full Body Workouts"];
      selectedExperience = "Beginner";
      selectedDiet = "Vegetarian";
      trainingDays = 3;
      selectedEquipment = "Bodyweight Only";
      selectedInjuries = ["None"];
      mealsPerDay = 4;
    });
  }

  void nextStep() {
    if (currentStep < steps.length - 1) {
      setState(() {
        currentStep++;
      });
    } else {
      _submit();
    }
  }

  void previousStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
    }
  }

  Future<void> _submit() async {
    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse("http://192.168.1.9:8080/fitforge_backend/api/recommend.php"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "goals": selectedGoals,
          "workout_types": selectedWorkoutTypes,
          "experience": selectedExperience,
          "diet": selectedDiet,
          "training_days": trainingDays,
          "equipment": selectedEquipment,
          "injuries": selectedInjuries,
          "meals": mealsPerDay,
        }),
      );

      final data = json.decode(response.body);
      if (data['success']) {
        Fluttertoast.showToast(
          msg: "Plan generated!",
          backgroundColor: Colors.green,
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                ResultScreen(plans: data['plans'], isBeginner: false),
          ),
        );
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Server Error");
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final step = steps[currentStep];
    return Scaffold(
      backgroundColor: Color(0xFFF5F5FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: previousStep,
        ),
        title: Text(
          "Step ${currentStep + 1} of ${steps.length}",
          style: GoogleFonts.poppins(color: Colors.grey[700]),
        ),
      ),

      //BODY FOR DESIGNING
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            //PROGRESS BAR
            LinearProgressIndicator(
              value: (currentStep + 1) / steps.length,
              backgroundColor: Colors.grey[300],
              color: const Color(0xFF6A1B9A),
            ),
            const SizedBox(height: 30),

            //MAIN CARD
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "Fitness Questionnaire",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6A1B9A),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        "Help us understand your fitness preferences",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Center(
                      child: Text(
                        step["title"],
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    if (step["subtitle"] != null) ...[
                      const SizedBox(height: 8),
                      Center(
                        child: Text(
                          step["subtitle"],
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),

                    //Dynamic Options
                    if (step["type"] == "multi")
                      ...step["options"].map<Widget>((option) {
                        final selected = step["key"] == "goals"
                            ? selectedGoals.contains(option)
                            : step["key"] == "workout_types"
                            ? selectedWorkoutTypes.contains(option)
                            : selectedInjuries.contains(option);

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (selected) {
                                  if (step['key'] == 'goals') {
                                    selectedGoals.remove(option);
                                  } else if (step['key'] == 'workout_types') {
                                    selectedWorkoutTypes.remove(option);
                                  } else {
                                    selectedInjuries.remove(option);
                                  }
                                } else {
                                  if (step['key'] == 'goals') {
                                    selectedGoals.add(option);
                                  } else if (step['key'] == 'workout_types') {
                                    selectedWorkoutTypes.add(option);
                                  } else {
                                    selectedInjuries.add(option);
                                  }
                                }
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 10,
                              ),
                              decoration: BoxDecoration(
                                color: selected
                                    ? const Color(0xFF6A1B9A)
                                    : Colors.grey[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: selected
                                      ? const Color(0xFF6A1B9A)
                                      : Colors.grey[300]!,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    selected
                                        ? Icons.check_box
                                        : Icons.check_box_outline_blank,
                                    color: selected
                                        ? Colors.white
                                        : Colors.grey,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    option,
                                    style: GoogleFonts.poppins(
                                      color: selected
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList()
                    else if (step['type'] == 'single')
                      ...step['options'].map<Widget>((option) {
                        final selected = step['key'] == 'experience'
                            ? selectedExperience == option
                            : step['key'] == 'diet'
                            ? selectedDiet == option
                            : selectedEquipment == option;

                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 6),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (step['key'] == 'experience') {
                                  selectedExperience = option;
                                } else if (step['key'] == 'diet') {
                                  selectedDiet = option;
                                } else {
                                  selectedEquipment = option;
                                }
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 10,
                              ),
                              decoration: BoxDecoration(
                                color: selected
                                    ? const Color(0xFF6A1B9A)
                                    : Colors.grey[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: selected
                                      ? const Color(0xFF6A1B9A)
                                      : Colors.grey[300]!,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    selected
                                        ? Icons.radio_button_checked
                                        : Icons.radio_button_off,
                                    color: selected
                                        ? Colors.white
                                        : Colors.grey,
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    option,
                                    style: GoogleFonts.poppins(
                                      color: selected
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList()
                    else if (step['type'] == 'slider')
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Days per week",
                            style: GoogleFonts.poppins(fontSize: 16),
                          ),
                          Slider(
                            value: trainingDays.toDouble(),
                            min: 1,
                            max: 7,
                            divisions: 6,
                            label: trainingDays.toString(),
                            activeColor: const Color(0xFF6A1B9A),
                            onChanged: (v) => setState(() {
                              trainingDays = v.round();
                            }),
                          ),
                          Center(
                            child: Text(
                              "$trainingDays days",
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    const Spacer(),

                    //Next Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : nextStep,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1A1A3A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Next",
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
