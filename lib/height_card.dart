import 'package:flutter/material.dart';
import 'consts.dart';

class HeightCard extends StatefulWidget {
  final Function(double height) onHeightChanged;

  const HeightCard({super.key, required this.onHeightChanged});

  @override
  State<HeightCard> createState() => _HeightCardState();
}

class _HeightCardState extends State<HeightCard> {
  // الطول الافتراضي
  double currentHeight = 100.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.03),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            offset: const Offset(4, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "HEIGHT",
            style: TextStyle(
              color: Colors.white60,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.width * 0.01),

          // صف بيجمع بين السلايدر ورقم الطول والشجرة
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // الجزء الأيسر: الرقم والـ Slider جوه Column
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    // عرض رقم الطول بشكل كبير ومتوهج
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          currentHeight.round().toString(),
                          style: TextStyle(
                            color: Colors.purple.shade200,
                            fontSize: 45,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          "cm",
                          style: TextStyle(color: Colors.white60, fontSize: 16),
                        ),
                      ],
                    ),

                    // Custom SliderTheme to design a premium glowing track and interactive thumb overlay
                    // الـ Slider الأفقي
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: buttonTwo,
                        inactiveTrackColor: Colors.deepPurple.shade900.withValues(alpha: 0.4),
                        thumbColor: Colors.white,
                        overlayColor: buttonTwo.withValues(alpha: 0.2),
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.0),
                        overlayShape: const RoundSliderOverlayShape(overlayRadius: 24.0),
                      ),
                      child: Slider(
                        value: currentHeight,
                        min: 50.0,
                        max: 220.0,
                        onChanged: (newValue) {
                          setState(() {
                            currentHeight = newValue;
                          });
                          widget.onHeightChanged(currentHeight); // إرسال الطول الجديد للشاشة الرئيسية
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // الجزء الأيمن: الشجرة التفاعلية والمتحركة
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: MediaQuery.of(context).size.width * 0.34, // أقصى ارتفاع متاح للـ Animation
                  child: Center(
                    // ال AnimatedSwitcher لعمل Fade ناعم عند تغيير شكل الشجرة
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        return FadeTransition(opacity: animation, child: ScaleTransition(scale: animation, child: child));
                      },
                      child: _buildDynamicTree(currentHeight),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Dynamic widget factory that scales and toggles nature icons based on height value
  // المصنع اللي بيبني الشجرة وبيغير حجمها وشكلها بناء على رقم السنتيمترات
  Widget _buildDynamicTree(double height) {
    // حساب الارتفاع : كل ما تسحب يزيد حجم الأيقونة
    // الحسبة دي بتخلي الحجم يتراوح بين 30 و 90 تقريباً بسلاسة
    double calculatedSize = 30 + ((height - 100) * 0.5);

    if (height < 140) {
      // شجرة صغيرة
      return Icon(
        Icons.yard_outlined,
        key: const ValueKey('small_tree'),
        size: calculatedSize,
        color: Colors.purple.shade300,
      );
    } else if (height < 190) {
      // شجرة طبيعية كاملة
      return Icon(
        Icons.nature_rounded,
        key: const ValueKey('normal_tree'),
        size: calculatedSize,
        color: Colors.purple.shade300,
      );
    } else {
      // غابة تدل اكتر على ان الطول كبير
      return Icon(
        Icons.forest_rounded,
        key: const ValueKey('huge_tree'),
        size: calculatedSize,
        color: Colors.purple.shade300,
      );
    }
  }
}