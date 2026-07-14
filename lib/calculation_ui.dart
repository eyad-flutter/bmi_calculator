import 'package:bmi_calc/gender_cards.dart';
import 'counters_card.dart';
import 'height_card.dart';
import 'calculate_button.dart';
import 'result_ui.dart';
import 'consts.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class CalculationUi extends StatefulWidget {
  const CalculationUi({super.key});

  @override
  State<CalculationUi> createState() => _CalculationUiState();
}

class _CalculationUiState extends State<CalculationUi> {

  // الثوابت اللي هيكون ظاهر عليها الUi في بداية تشغيله
  bool isMale = true;
  double currentHeight = 100.0;
  int currentWeight = 1;
  int currentAge = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "BMI CALCULATOR",
          style: TextStyle(
            color: text,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      // Establishes a fully responsive layout to safely prevent layout overflows on landscape orientation or tablets
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
              children: [
                Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // كروت اختيار الجنس (Gender Selection)
            GenderCards(
              onGenderChanged: (selectedGender) {
                setState(() {
                  // وقت اختيار الجنس بيأثر على الBool تبع الMale لو false بينطفي ال Male والعكس مع true
                  isMale = selectedGender;
                });
              },
            ),

            // المسافة بين اول عنصرين والمنتصف
            SizedBox(height: MediaQuery.of(context).size.width * 0.04),

            // كارت الطول (Height Selection)
            HeightCard(
              onHeightChanged: (selectedHeight) {
                setState(() {
                  // وقت اختيار الطول بيأثر على الرقم المحدد
                  currentHeight = selectedHeight;
                });
              },
            ),

            // المسافة بين المنتصف وآخر عنصرين
            SizedBox(height: MediaQuery.of(context).size.width * 0.04),

            // 3. كروت الوزن والعمر (Weight & Age)
            CountersSection(
              onWeightChanged: (selectedWeight) {
                setState(() {
                  // وقت اختيار الوزن بيأثر على الرقم المحدد
                  currentWeight = selectedWeight;
                });
              },
              onAgeChanged: (selectedAge) {
                setState(() {
                  // وقت اختيار العمر بيأثر على الرقم المحدد
                  currentAge = selectedAge;
                });
              },
            ),

            // المساحة بين آخر كارتين وزرار الحساب
            SizedBox(height: MediaQuery.of(context).size.width * 0.057),

            //  زرار الحساب السفلي (Calculate Button)
            CalculateButton(
              onTap: () {
                // Calculates the medical BMI formula and pushes clean results to the ResultScreen
                // الحسبة الرياضية اللي بتتم بعد الضغط على الزر
                double heightInMeters = currentHeight / 100;
                double bmiResult = currentWeight / pow(heightInMeters, 2);

                // ️الانتقال لشاشة النتيجة مع تمرير كافة المتغيرات
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResultScreen(
                      bmi: bmiResult,
                      age: currentAge,
                      isMale: isMale,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),],),),),
    );
  }
}