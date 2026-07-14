import 'package:flutter/material.dart';
import 'consts.dart';

class ResultScreen extends StatelessWidget {
  final double bmi;
  final int age;
  final bool isMale;

  const ResultScreen({
    super.key,
    required this.bmi,
    required this.age,
    required this.isMale,
  });

  // دالة بتحدد (الحالة، الإيموجي، اللون، والنصيحة) تلقائي بناء على قيمة الـ BMI
  Map<String, dynamic> _getBMIData() {
    if (bmi < 18.5) {
      return {
        "status": "UNDERWEIGHT",
        "emoji": "🦴",
        "color": Colors.cyanAccent.shade400,
        "advice": "Your weight is below the normal range. You need to focus on foods rich in protein and building muscle mass.",
      };
    } else if (bmi >= 18.5 && bmi < 25) {
      return {
        "status": "NORMAL",
        "emoji": "💪",
        "color": Colors.greenAccent.shade400,
        "advice": "Your body is in perfect shape. Keep up this healthy lifestyle and your workouts.",
      };
    } else if (bmi >= 25 && bmi < 30) {
      return {
        "status": "OVERWEIGHT",
        "emoji": "⚠️",
        "color": Colors.orangeAccent.shade400,
        "advice": "You have a slight weight gain. Try cutting down on sugar and increasing physical activity or doing cardio every day.",
      };
    } else {
      return {
        "status": "OBESE",
        "emoji": "🚨",
        "color": Colors.redAccent.shade400,
        "advice": "Weight during obesity. It's very important to reorganize your diet and consult a specialist to protect your health.",
      };
    }
  }


  @override
  Widget build(BuildContext context) {
    // استخراج البيانات بناء على الحسبة
    final bmiData = _getBMIData();
    final Color statusColor = bmiData["color"];

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        toolbarHeight: 0,
        title: const Text("YOUR RESULT", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context), // زرار الرجوع للشاشة السابقة
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
              children: [ Container(
        color: backgroundColor, // الفلتر البنفسجي الشفاف
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Calculated Result",
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),
            SizedBox(height: MediaQuery.of(context).size.width * 0.065),

            // كارت النتيجة
            // Renders a glowing results card with dynamic border colors matched to the BMI health diagnosis
            Container(
                padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.15),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade900.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: statusColor.withValues(alpha: 0.3), // الإطار بينور بنفس لون الحالة
                    width: 2,
                  ),
                  boxShadow: [
                    // التوهج الخارجي المعتمد على حالة الجسم
                    BoxShadow(
                      color: statusColor.withValues(alpha: 0.15),
                      blurRadius: 25,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // عرض الجنس والعمر بشكل هادي فوق
                    Text(
                      "${isMale ? "MALE" : "FEMALE"}  |  $age YEARS OLD",
                      style: const TextStyle(color: Colors.white54, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                    ),

                    // اسم الحالة الصحية
                    Text(
                      bmiData["status"],
                      style: TextStyle(color: statusColor, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 2),
                    ),

                    // الرقم ال BMI مع إيموجي الحالة
                    Column(
                      children: [
                        Text(
                          bmiData["emoji"],
                          style: const TextStyle(fontSize: 50),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.width * 0.02),
                        Text(
                          bmi.toStringAsFixed(1), // تقريب الناتج لرقم عشري واحد
                          style: const TextStyle(color: Colors.white, fontSize: 75, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),

                    // النصيحة المخصصة للمستخدم
                    Text(
                      bmiData["advice"],
                      style: const TextStyle(color: Colors.white70, fontSize: 16, height: 1.5),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],),),
            SizedBox(height: MediaQuery.of(context).size.width * 0.1),

            // زرار إعادة الحساب السفلي (بنفس أنيميشن الانضغاط)
            _buildReCalculateButton(context),
          ],
        ),
      ),),
    );
  }

  // ويدجت زرار العودة للملف الرئيسي
  Widget _buildReCalculateButton(BuildContext context) {
    bool isPressed = false;
    return StatefulBuilder(
      builder: (context, setState) {
        return GestureDetector(
          onTapDown: (_) => setState(() => isPressed = true),
          onTapUp: (_) {
            setState(() => isPressed = false);
            Navigator.pop(context); // رجوع للشاشة الأولى
          },
          onTapCancel: () => setState(() => isPressed = false),
          child: AnimatedScale(
            scale: isPressed ? 0.96 : 1.0,
            duration: const Duration(milliseconds: 100),
            child: Container(
              height: MediaQuery.of(context).size.width * 0.167,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [buttonOne, buttonTwo],
                ),
                border: Border.all(color: Colors.purple.shade300.withValues(alpha: 0.4), width: 1.5),
              ),
              child: const Center(
                child: Text(
                  "RE-CALCULATE YOUR BMI",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}