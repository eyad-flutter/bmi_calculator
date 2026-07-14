import 'package:flutter/material.dart';
import 'consts.dart';

class GenderCards extends StatefulWidget {

  // Callback function to instantly notify the parent screen about gender changes
  final Function(bool isMale) onGenderChanged;

  const GenderCards({super.key, required this.onGenderChanged});

  @override
  State<GenderCards> createState() => _GenderCardsState();
}

class _GenderCardsState extends State<GenderCards> {

  // بنعرف المتغير جوه الـ State عشان الكلاس يشوفه
  bool isMale = true;

  @override
  Widget build(BuildContext context) {

    // دالة الـ build بتعمل return للـ Widget الأساسي وبدون تعقيد
    // كارتين الجنس ومربوطين ب ويدجيت تكبير وتلوين الكارت المختار
    return Row(
      children: [
        Expanded(
          child: _buildGenderCard(
            genderName: "MALE",
            icon: Icons.male_rounded,
            isSelected: isMale,
            onTap: () {
              setState(() {
                isMale = true;
              });
              widget.onGenderChanged(true); // تبلغ الشاشة الكبيرة
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildGenderCard(
            genderName: "FEMALE",
            icon: Icons.female_rounded,
            isSelected: !isMale,
            onTap: () {
              setState(() {
                isMale = false;
              });
              widget.onGenderChanged(false); // تبلغ الشاشة الكبيرة
            },
          ),
        ),
      ],
    );
  }

  // Generic interactive card for gender selection with dynamic scaling and custom callbacks
  // الدالة المساعدة بقت بره الـ build وجوه الكلاس بشكل قانوني وسليم
  Widget _buildGenderCard({
    required String genderName,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {

    return GestureDetector(
      onTap: onTap,
      // Triggers micro-scaling and smooth gradient transitions based on selection state
      child: AnimatedScale(
        scale: isSelected ? 1.05 : 0.92,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutBack,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: isSelected
                ? LinearGradient(
              colors: [buttonOne, buttonTwo],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
                : null,
            color: isSelected ? null : inactiveColor,
            boxShadow: isSelected
                ? [
              BoxShadow(
                color: Colors.purple.shade400.withValues(alpha: 0.4),
                offset: const Offset(0, 8),
                blurRadius: 16,
              ),
            ]
                : [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                offset: const Offset(4, 4),
                blurRadius: 10,
              ),
            ],
            border: Border.all(
              color: isSelected
                  ? Colors.purple.shade300.withValues(alpha: 0.5)
                  : Colors.white.withValues(alpha: 0.03),
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 50,
                color: isSelected ? Colors.white : Colors.purple.shade300.withValues(alpha: 0.5),
              ),
              SizedBox(height: MediaQuery.of(context).size.width * 0.01),
              Text(
                genderName,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.purple.shade300.withValues(alpha: 0.5),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}