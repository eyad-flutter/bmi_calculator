import 'package:bmi_calc/calculation_ui.dart';
import 'package:flutter/material.dart';
import 'consts.dart';

class WelcomeUi extends StatelessWidget {
  const WelcomeUi({super.key});


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.deepPurple.shade900.withValues(alpha: 0.2),
      // Establishes a fully responsive layout to safely prevent layout overflows on landscape orientation or tablets
      body: SafeArea(
    child: SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.width * 1,),
          Align(alignment: Alignment(0.04, 0.9),
        child: GestureDetector(
          onTap: () {
            // للانتقال بأنيميشن الـ Fade
            Navigator.of(context).pushReplacement(_createFadeRoute());
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            height: MediaQuery.of(context).size.width * 0.17,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
                colors: [
                  buttonOne,
                  buttonTwo
              ]),
              borderRadius: BorderRadius.circular(20),
              // تأثير الـ Neomorphism: ظل فاتح من فوق وشديد من تحت
              boxShadow: [
                BoxShadow(
                  color: Colors.white70.withValues(alpha: 0.2),
                  offset: const Offset(1, 1),
                  blurRadius: 8,
                ),
                BoxShadow(
                  color: Colors.grey.shade800.withValues(alpha: 0.8),
                  offset: const Offset(2, 2),
                  blurRadius: 8,
                ),
              ],
              border: Border.all(
                color: backgroundColor.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
              "GET STARTED",
              style: TextStyle(
                color: text,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 3,
              ),
            ),
          ),),
        ),
      ),],),),),
      );
  }

  // ️دالة الأنيميشن (Fade Transition)
  Route _createFadeRoute() {
    return PageRouteBuilder(
      // الشاشة اللي رايحين لها (calculation_ui)
      pageBuilder: (context, animation, secondaryAnimation) => CalculationUi(),
      // وقت اختفاء شاشة الترحيب وظهور الشاشة الجديدة
      transitionDuration: const Duration(milliseconds: 700),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // ويدجت فلاتر الجاهزة لعمل الـ Fade
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }
}
