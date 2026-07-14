import 'dart:async';
import 'package:flutter/material.dart';
import 'consts.dart';

class CountersSection extends StatefulWidget {
  final Function(int weight) onWeightChanged;
  final Function(int age) onAgeChanged;

  const CountersSection({
    super.key,
    required this.onWeightChanged,
    required this.onAgeChanged,
  });

  @override
  State<CountersSection> createState() => _CountersSectionState();
}

class _CountersSectionState extends State<CountersSection> {
  int weight = 1;
  int age = 1;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // كارت الوزن (الحد الأقصى 200)
        Expanded(
          child: CounterCard(
            title: "WEIGHT",
            value: weight,
            emojiWidget: _buildWeightEmoji(weight),
            onDecrement: () {
              if (weight > 1) {
                setState(() => weight--);
                widget.onWeightChanged(weight);
              }
            },
            onIncrement: () {
              if (weight < 200) {
                setState(() => weight++);
                widget.onWeightChanged(weight);
              }
            },
          ),
        ),
        const SizedBox(width: 16),
        // كارت العمر (الحد الأقصى 150)
        Expanded(
          child: CounterCard(
            title: "AGE",
            value: age,
            emojiWidget: _buildAgeEmoji(age),
            onDecrement: () {
              if (age > 1) {
                setState(() => age--);
                widget.onAgeChanged(age);
              }
            },
            onIncrement: () {
              if (age < 150) {
                setState(() => age++);
                widget.onAgeChanged(age);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildWeightEmoji(int w) {
    String emoji = "🫒";
    if (w >= 40 && w <= 50) emoji = "🍎";
    if (w > 50 && w <= 70) emoji = "🍊";
    if (w > 70 && w <= 100) emoji = "🍉";
    if (w > 100 && w <= 120) emoji = "🪨";
    if (w > 120) emoji = "🐘";

    return Text(
      emoji,
      key: ValueKey(emoji),
      style: const TextStyle(fontSize: 40),
    );
  }

  Widget _buildAgeEmoji(int a) {
    String emoji = "👶";
    if (a >= 11 && a <= 20) emoji = "🧑";
    if (a > 20 && a <= 40) emoji = "👨‍💼";
    if (a > 40 && a <= 60) emoji = "👨";
    if (a > 60 && a <= 99) emoji = "👴";
    if (a >= 100) emoji = "💀";

    return Text(
      emoji,
      key: ValueKey(emoji),
      style: const TextStyle(fontSize: 40),
    );
  }
}

// كرت العداد (يدعم التسارع والموتور التفاعلي)
class CounterCard extends StatefulWidget {
  final String title;
  final int value;
  final Widget emojiWidget;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const CounterCard({
    super.key,
    required this.title,
    required this.value,
    required this.emojiWidget,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  State<CounterCard> createState() => _CounterCardState();
}

class _CounterCardState extends State<CounterCard> with SingleTickerProviderStateMixin {
  // Animation controller for physics-based card shaking and self-invoking timer for speed acceleration
  late AnimationController _shakeController;
  Timer? _timer;

  // إعدادات سرعة الـ Acceleration
  int _currentDelay = 200;       // بيبدأ بـ 200 مللي ثانية (بطيء)
  final _startDelay = 200;
  final _minDelay = 15;       // بينتهي بـ 15 مللي ثانية (سرعة عالية)

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 45), // هزة سريعة جدا
      vsync: this,
    );
  }

  // للحفاظ على الجهاز من ال Leak Memory
  @override
  void dispose() {
    _shakeController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  // دالة البداية: بتصفر العداد وتبدأ أول خطوة تسارع
  void _startContinuousChange(VoidCallback action) {
    _shakeController.repeat(reverse: true);
    _currentDelay = _startDelay; // إعادة ضبط السرعة للبداية البطيئة
    action(); // تنفيذ أول عدة بدون انتظار
    _runAcceleratingTimer(action);
  }

  // Self-invoking timer that implements custom physics-based acceleration on long press
  // الدالة المستدعاة ذاتيا لتقليل الوقت (زيادة السرعة)
  void _runAcceleratingTimer(VoidCallback action) {
    _timer = Timer(Duration(milliseconds: _currentDelay), () {
      action(); // عد الرقم

      // معادلة التسارع: تقليله وتسريعه بـ 18% في كل خطوة
      if (_currentDelay > _minDelay) {
        _currentDelay = (_currentDelay * 0.82).toInt();
        if (_currentDelay < _minDelay) _currentDelay = _minDelay; // الأمان عشان مايقلش عن الصفر
      }

      // استدعي الدالة تاني بالـ Delay الجديد
      _runAcceleratingTimer(action);
    });
  }

  // إيقاف وتصفير كل حاجة عند رفع الإصبع
  void _stopContinuousChange() {
    _timer?.cancel();
    _shakeController.stop();
    _shakeController.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.03), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            offset: const Offset(4, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: AnimatedBuilder(
        animation: _shakeController,
        builder: (context, child) {
          double dx = 0.0;
          if (_shakeController.isAnimating) {
            // كل ما الـ _currentDelay يصغر (يعني السرعة تزيد) الرقم الناتج من الحسبة دي بيكبر
            // الهزة هتبدأ بـ 1.5 بكسل خفيف وتوصل لـ 6.5 بكسل عالي لما السرعة تقفل العداد
            double currentIntensity = 1.5 + ((_startDelay - _currentDelay) / 35);
            dx = (_shakeController.value * currentIntensity) - (currentIntensity / 2);
          }
          return Transform.translate(
            offset: Offset(dx, 0),
            child: child,
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.title,
              style: const TextStyle(color: Colors.white60, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.5),
            ),
            SizedBox(height: MediaQuery.of(context).size.width * 0.01),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.14,
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(scale: animation, child: FadeTransition(opacity: animation, child: child));
                  },
                  child: widget.emojiWidget,
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.width * 0.01),
            Text(
              widget.value.toString(),
              style: TextStyle(color: Colors.purple.shade300, fontSize: 35, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: MediaQuery.of(context).size.width * 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Binds raw touch interactions to control both the counter speed and shake intensity
                _buildNeomorphicActionButton(
                  icon: Icons.remove,
                  onTap: widget.onDecrement,
                  onLongPressStart: () => _startContinuousChange(widget.onDecrement),
                  onLongPressEnd: _stopContinuousChange,
                ),
                const SizedBox(width: 14),
                _buildNeomorphicActionButton(
                  icon: Icons.add,
                  onTap: widget.onIncrement,
                  onLongPressStart: () => _startContinuousChange(widget.onIncrement),
                  onLongPressEnd: _stopContinuousChange,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // العوامل المؤثرة في ازرار الزيادة والنقصان لكروت الوزن والعمر
  Widget _buildNeomorphicActionButton({
    required IconData icon,
    required VoidCallback onTap,
    required VoidCallback onLongPressStart,
    required VoidCallback onLongPressEnd,
  }) {
    return GestureDetector(
      onTap: onTap,
      onLongPressStart: (_) => onLongPressStart(),
      onLongPressEnd: (_) => onLongPressEnd(),
      onLongPressUp: onLongPressEnd,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: buttonColor,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }
}