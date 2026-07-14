import 'package:flutter/material.dart';
import 'consts.dart';

class CalculateButton extends StatefulWidget {
  final VoidCallback onTap;

  const CalculateButton({super.key, required this.onTap});

  @override
  State<CalculateButton> createState() => _CalculateButtonState();
}

class _CalculateButtonState extends State<CalculateButton> {
  // متغير لمراقبة هل المستخدم ضاغط حاليا على الزرار ولا لأ
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    // Tracks instant user touch down to dynamically scale the button down and dim its neon glow
    return GestureDetector(
      // أول ما يضع صباعه: اقلب الحالة لـ مضغوط عشان يصغر
      onTapDown: (_) => setState(() => _isPressed = true),
      // أول ما يرفع صباعه: رجع الحجم الطبيعي ونفذ دالة الحساب
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      // لو سحب صباعه لبره واللمسة اتلغت: رجع الحجم الطبيعي بدون حساب
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        // الزرار بينضغط لداخل الشاشة بنسبة 4% عند اللمس
        scale: _isPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity, // يفرش بكامل العرض المتاح
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [buttonOne, buttonTwo],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            // توهج نيون (Glow) يقل خفيفا لما ينضغط اكن الطاقة انضغطت جوه الزرار
            boxShadow: [
              BoxShadow(
                color: Colors.purple.shade400.withValues(alpha: _isPressed ? 0.25 : 0.45),
                offset: const Offset(0, 6),
                blurRadius: _isPressed ? 10 : 20,
              ),
            ],
            // إطار رفيع جدا منور
            border: Border.all(
              color: Colors.purple.shade300.withValues(alpha: 0.4),
              width: 1.5,
            ),
          ),
          child: const Center(
            child: Text(
              "CALCULATE BMI",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}