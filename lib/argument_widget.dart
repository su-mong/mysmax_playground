import 'package:flutter/material.dart';
import 'package:mysmax_playground/app_text_styles.dart';
import 'package:mysmax_playground/models/enums/argument_type.dart';
import 'package:mysmax_playground/models/function_argument.dart';

class ArgumentWidget extends StatefulWidget {
  final FunctionArgument argument;
  final Function(dynamic)? onChanged;
  const ArgumentWidget(this.argument, {Key? key, this.onChanged})
      : super(key: key);

  @override
  _ArgumentWidgetState createState() => _ArgumentWidgetState();
}

class _ArgumentWidgetState extends State<ArgumentWidget> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    _controller.text = (widget.argument.value != null) ? widget.argument.value.toString() : '';
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ArgumentWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if(widget != oldWidget) {
      _controller.text = (widget.argument.value != null) ? widget.argument.value.toString() : '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(widget.argument.name),
        const SizedBox(width: 12),
        Expanded(
          child: _buildValue(),
        ),
      ],
    );
  }

  Widget _buildValue() {
    switch (widget.argument.type) {
      case ArgumentType.bool:
        return _buildBoolValue();
      case ArgumentType.double:
        return _buildDoubleValue();
      case ArgumentType.int:
        return _buildIntValue();
      case ArgumentType.string:
        return _buildStringValue();
      default:
        return Container();
    }
  }

  Widget _buildBoolValue() {
    return Checkbox(
      value: widget.argument.value ?? false,
      onChanged: (value) {
        widget.onChanged?.call(value);
      },
    );
  }

  Widget _buildDoubleValue() {
    var minValue = widget.argument.bound?.min_value;
    var maxValue = widget.argument.bound?.max_value;
    var numberizeMinValue =
        minValue is String ? double.parse(minValue) : minValue ?? 0.0;
    var numberizeMaxValue =
        maxValue is String ? double.parse(maxValue) : maxValue ?? 100.0;

    return TextField(
      keyboardType: TextInputType.number,
      controller: _controller,
      focusNode: _focusNode,
      style: AppTextStyles.size13Regular.copyWith(
        color: Color(0xff1b1b1b),
      ),
      decoration: InputDecoration(
        hintText: '숫자',
        hintStyle: AppTextStyles.size13Regular.copyWith(
          color: Color(0xffC0C0C0),
        ),
        isCollapsed: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Color(0xffE9ECF5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Color(0xffE9ECF5),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Color(0xffE9ECF5),
          ),
        ),
      ),
      onChanged: (value) {
        widget.onChanged?.call(double.parse(value));
      },
    );
  }

  Widget _buildIntValue() {
    var minValue = widget.argument.bound?.min_value;
    var maxValue = widget.argument.bound?.max_value;

    var numberizeMinValue =
        minValue is String ? int.parse(minValue) : minValue ?? 0;
    var numberizeMaxValue =
        maxValue is String ? int.parse(maxValue) : maxValue ?? 100;
    // if (numberizeMaxValue - numberizeMinValue > 50) {
    return TextField(
      keyboardType: TextInputType.number,
      focusNode: _focusNode,
      controller: _controller,
      style: AppTextStyles.size13Regular.copyWith(
        color: Color(0xff1b1b1b),
      ),
      decoration: InputDecoration(
        hintText: '숫자',
        hintStyle: AppTextStyles.size13Regular.copyWith(
          color: Color(0xffC0C0C0),
        ),
        isCollapsed: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Color(0xffE9ECF5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Color(0xffE9ECF5),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Color(0xffE9ECF5),
          ),
        ),
      ),
      onChanged: (value) {
        widget.onChanged?.call(int.parse(value));
      },
    );
    // }
    // return SfSliderTheme(
    //     data: SfSliderThemeData(
    //       activeTrackColor: AppColors.blue,
    //       inactiveTrackColor: const Color(0xffE9ECF5),
    //       thumbColor: Colors.white,
    //       tooltipBackgroundColor: Colors.transparent,
    //       tooltipTextStyle: AppTextStyles.size10Medium.singleLine.copyWith(
    //         color: AppColors.disableTextColor,
    //       ),
    //     ),
    //     child: SfSlider(
    //       min: numberizeMinValue,
    //       max: numberizeMaxValue,
    //       enableTooltip: true,
    //       value: widget.argument.value ?? 0.0,
    //       tooltipTextFormatterCallback:
    //           (dynamic actualValue, String formattedText) {
    //         return formattedText;
    //       },
    //       onChanged: (dynamic value) {
    //         widget.onChanged?.call((value as double).toInt());
    //       },
    //     ));
  }

  Widget _buildStringValue() {
    return TextField(
      keyboardType: TextInputType.text,
      focusNode: _focusNode,
      controller: _controller,
      style: AppTextStyles.size13Regular.copyWith(
        color: Color(0xff1b1b1b),
      ),
      decoration: InputDecoration(
        hintText: '문자열',
        hintStyle: AppTextStyles.size13Regular.copyWith(
          color: Color(0xffC0C0C0),
        ),
        isCollapsed: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Color(0xffE9ECF5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Color(0xffE9ECF5),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Color(0xffE9ECF5),
          ),
        ),
      ),
      onChanged: (value) {
        widget.onChanged?.call(value);
      },
    );
  }
}
