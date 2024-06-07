import 'package:flutter/material.dart';
import 'package:mysmax_playground/app_text_styles.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class NumberSlider extends StatelessWidget {
  final bool enabled;
  final num value;
  final void Function(num newValue) onChanged;
  final num min;
  final num max;

  const NumberSlider({
    super.key,
    required this.enabled,
    required this.value,
    required this.onChanged,
    required this.min,
    required this.max,
  });

  @override
  Widget build(BuildContext context) {
    return SfSliderTheme(
      data: SfSliderThemeData(
        activeTrackHeight: 6,
        inactiveTrackHeight: 4,
        thumbRadius: 9,
        thumbColor: const Color(0xFFFFFFFF),
        activeTrackColor: const Color(0xFF5D7CFF),
        inactiveTrackColor: const Color(0xFFE9ECF5),
        tooltipBackgroundColor: Colors.transparent,
        tooltipTextStyle: AppTextStyles.size10Medium.copyWith(color: const Color(0xFF8F94A4)),
        disabledThumbColor: const Color(0xFFDDDDDD),
        disabledActiveTrackColor: const Color(0x775D7CFF),
        disabledInactiveTrackColor: const Color(0xFFE9ECF5),
      ),
      child: SfSlider(
        min: min,
        max: max,
        value: value,
        onChanged: enabled
            ? (value) => onChanged(value)
            : null,
        showLabels: false,
        shouldAlwaysShowTooltip: true,
        tooltipShape: const _SfTooltipShape(),
      ),
    );
  }
}

class _SfTooltipShape extends SfTooltipShape {
  const _SfTooltipShape();

  @override
  void paint(PaintingContext context, Offset thumbCenter, Offset offset,
      TextPainter textPainter,
      {required RenderBox parentBox,
        required SfSliderThemeData sliderThemeData,
        required Paint paint,
        required Animation<double> animation,
        required Rect trackRect}) {
    context.canvas.save();
    context.canvas.translate(thumbCenter.dx, thumbCenter.dy);
    context.canvas.scale(animation.value);
    textPainter.paint(
      context.canvas,
      Offset(-textPainter.width / 2, offset.dy), // Offset(offset.dx - textPainter.width / 2, offset.dy),
    );
    context.canvas.restore();
  }
}