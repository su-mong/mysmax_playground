import 'package:flutter/material.dart';
import 'package:mysmax_playground/colors.dart';

class RadioToggleButton extends StatelessWidget {
  const RadioToggleButton({
    super.key,
    required this.toggled,
    this.size = 24,
    this.innerSize = 7.0,
    this.color = AppColors.blue,
  });
  final double size;
  final double innerSize;
  final bool toggled;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          width: 1,
          color: toggled ? color : Color(0xffe9ecf5),
        ),
      ),
      padding: EdgeInsets.all((size - innerSize) / 2),
      width: size,
      height: size,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: toggled ? color : Colors.transparent,
        ),
        height: innerSize,
        width: innerSize,
      ),
    );
  }
}
