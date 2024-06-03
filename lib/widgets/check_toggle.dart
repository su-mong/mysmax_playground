import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mysmax_playground/colors.dart';

class CheckToggle extends StatelessWidget {
  const CheckToggle({
    super.key,
    required this.toggled,
    this.onCheck,
    this.size,
    this.color = AppColors.blue,
    this.margin,
  });

  final bool toggled;
  final Function(bool toggled)? onCheck;
  final double? size;
  final Color color;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: size,
        height: size,
        margin: margin,
        decoration: ShapeDecoration(
          color: toggled ? color : Colors.white,
          shape: RoundedRectangleBorder(
              side: toggled
                  ? BorderSide.none
                  : const BorderSide(
                      width: 1,
                      color: Color(0xFFDAE2EB),
                    ),
              borderRadius: BorderRadius.circular(toggled ? 3 : 4)),
        ),
        child: SvgPicture.asset(
          "assets/icons/check_icon.svg",
          color: Colors.white,
          height: size,
        ),
      ),
      onTap: () => onCheck?.call(!toggled),
    );
  }
}
