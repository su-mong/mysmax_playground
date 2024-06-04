import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mysmax_playground/app_text_styles.dart';
import 'package:mysmax_playground/colors.dart';
import 'package:mysmax_playground/core/scenario_code_parser/enums.dart';
import 'package:mysmax_playground/core/viewmodels/mqtt_view_model.dart';
import 'package:mysmax_playground/helper/icon_helper.dart';
import 'package:provider/provider.dart';

import '../../../core/scenario_code_parser/expression.dart';

class LiteralBlockWidget extends StatefulWidget {
  final LiteralExpression item;
  final Function(LiteralExpression block) onBlockChanged;
  const LiteralBlockWidget(this.item, {required this.onBlockChanged, Key? key})
      : super(key: key);

  @override
  _LiteralBlockWidgetState createState() => _LiteralBlockWidgetState();
}

class _LiteralBlockWidgetState extends State<LiteralBlockWidget> {
  bool _expanded = false;
  TextEditingController _textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var mqttViewModel = context.watch<MqttViewModel>();
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: ExpansionTile(
        initiallyExpanded: _textEditingController.text.isEmpty ? true : false,
        onExpansionChanged: (value) {
          setState(() {
            _expanded = value;
          });
        },
        tilePadding: const EdgeInsets.symmetric(
          horizontal: 19,
          vertical: 15,
        ).copyWith(right: 12),
        title: Row(
          children: [
            Text(
              widget.item.literalType.toDisplayName,
              style: AppTextStyles.size17Bold.singleLine,
            ),
          ],
        ),
        subtitle: _expanded
            ? null
            : Text(widget.item.valueString,
                style: AppTextStyles.size13Medium.singleLine.copyWith(
                  color: AppColors.blue,
                )),
        iconColor: AppColors.defaultTextColor,
        collapsedIconColor: AppColors.defaultTextColor,
        children: [
          if (widget.item.literalType == LiteralType.DOUBLE ||
              widget.item.literalType == LiteralType.INTEGER)
            _buildNumberInput()
          else if (widget.item.literalType == LiteralType.STRING)
            _buildStringInput()
          // TODO: bool, variable
        ],
      ),
    );
  }

  Widget _buildIcon(String valueName) {
    var service = context.read<MqttViewModel>().getValueInfoByValueName(valueName);
    var defaultWidget = Container(
      width: 19,
      height: 19,
      decoration: const ShapeDecoration(
        gradient: LinearGradient(
          begin: Alignment(-0.68, 0.74),
          end: Alignment(0.68, -0.74),
          colors: [Color(0xFF8198F5), Color(0xFF83CDF6)],
        ),
        shape: OvalBorder(),
      ),
    );

    return CachedNetworkImage(
      imageUrl: IconHelper.getServiceIcon(service?.category ?? ''),
      height: 19,
      fit: BoxFit.fitHeight,
      placeholder: (context, url) => defaultWidget,
      errorWidget: (context, url, error) => defaultWidget,
    );
  }

  Widget _buildDeviceIcon(String? thingCategory) {
    var defaultWidget = Container(
      width: 19,
      height: 19,
      decoration: const ShapeDecoration(
        gradient: LinearGradient(
          begin: Alignment(-0.68, 0.74),
          end: Alignment(0.68, -0.74),
          colors: [Color(0xFF8198F5), Color(0xFF83CDF6)],
        ),
        shape: OvalBorder(),
      ),
    );

    return CachedNetworkImage(
      imageUrl: IconHelper.getDeviceIcon(thingCategory ?? ''),
      height: 19,
      fit: BoxFit.fitHeight,
      placeholder: (context, url) => defaultWidget,
      errorWidget: (context, url, error) => defaultWidget,
    );
  }

  void _onBlockChanged() {
    var value;
    switch (widget.item.literalType) {
      case LiteralType.DOUBLE:
        value = double.tryParse(_textEditingController.text);
        break;
      case LiteralType.INTEGER:
        value = int.tryParse(_textEditingController.text);
        break;
      case LiteralType.STRING:
        value = _textEditingController.text;
        break;
      default:
        value = _textEditingController.text;
    }

    var block = LiteralExpression(value, literalType: widget.item.literalType);
    widget.onBlockChanged(block);
  }

  Widget _buildNumberInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: _textEditingController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xffE9ECF5),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xff5D7CFF),
            ),
          ),
          hintText: '숫자를 입력하세요',
          hintStyle: AppTextStyles.size13Medium.singleLine.copyWith(
            color: const Color(0xff8F94A4),
          ),
        ),
        onChanged: (value) {
          _onBlockChanged();
        },
      ),
    );
  }

  Widget _buildStringInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: _textEditingController,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xffE9ECF5),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xff5D7CFF),
            ),
          ),
          hintText: '문자를 입력하세요',
          hintStyle: AppTextStyles.size13Medium.singleLine.copyWith(
            color: const Color(0xff8F94A4),
          ),
        ),
        onChanged: (value) {
          _onBlockChanged();
        },
      ),
    );
  }
}
