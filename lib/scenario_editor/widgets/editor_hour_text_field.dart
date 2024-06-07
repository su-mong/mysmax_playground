import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mysmax_playground/app_text_styles.dart';

/// [EditorNumberTextField]와 거의 같으나, 시간을 표시하기 위한 기능만 변경된 버전이다.
/// (시간은 12, 1, 2, ..., 11 이 순서이기 때문에 여기에 맞추고자 별도로 클래스를 분리함)
class EditorHourTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;
  final void Function(int value)? onChanged;

  const EditorHourTextField({
    super.key,
    required this.controller,
    required this.enabled,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 61,
      height: 34,
      padding: const EdgeInsets.fromLTRB(11, 0, 6, 0),
      decoration: BoxDecoration(
        color: enabled
            ? const Color(0xFFFFFFFF)
            : const Color(0xFFF8F9FD),
        border: Border.all(width: 1, color: const Color(0xFFE9ECF5)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              /// TODO padding 지우고도 가운데로 맞출 수 있도록 수정
              padding: const EdgeInsets.only(top: 8.5),
              child: TextField(
                enabled: enabled,
                controller: enabled ? controller : null,
                keyboardType: TextInputType.number,
                maxLines: 1,
                maxLength: 2,
                onChanged: (strValue) {
                  if(strValue.isEmpty) {
                    if(onChanged != null) {
                      onChanged!(12);
                    }
                    return;
                  }

                  if(int.tryParse(strValue) != null) {
                    int num = int.parse(strValue);
                    if(num > 12) {
                      num = 11;
                      controller.text = '11';
                    } else if(num < 1) {
                      num = 12;
                      controller.text = '12';
                    }

                    if(onChanged != null) {
                      onChanged!(num);
                    }
                  } else {
                    controller.text = '12';
                    if(onChanged != null) {
                      onChanged!(12);
                    }
                  }
                },
                style: AppTextStyles.size12Regular.copyWith(height: 15 / 12),
                textAlignVertical: TextAlignVertical.center,
                decoration: const InputDecoration(
                  isDense: true,
                  isCollapsed: true,
                  contentPadding: EdgeInsets.zero,
                  counter: SizedBox.shrink(),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  if(enabled) {
                    int? currentNum = int.tryParse(controller.text);
                    if (currentNum != null) {
                      if (currentNum == 12) {
                        currentNum = 1;
                      } else if (currentNum >= 11) {
                        currentNum = 11;
                      } else if (currentNum < 1) {
                        currentNum == 12;
                      } else {
                        currentNum += 1;
                      }

                      controller.text = currentNum.toString();

                      if(onChanged != null) {
                        onChanged!(currentNum);
                      }
                    } else {
                      controller.text = '11';
                      if(onChanged != null) {
                        onChanged!(11);
                      }
                    }
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(1),
                  child: SvgPicture.asset(
                    'assets/icons/number_text_field_up.svg',
                    height: 4,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: () {
                  if(enabled) {
                    int? currentNum = int.tryParse(controller.text);
                    if (currentNum != null) {
                      if (currentNum == 1 || currentNum == 12) {
                        currentNum = 12;
                      } else if (currentNum >= 13) {
                        currentNum = 11;
                      } else if (currentNum <= 0) {
                        currentNum == 12;
                      } else {
                        currentNum -= 1;
                      }

                      controller.text = currentNum.toString();

                      if(onChanged != null) {
                        onChanged!(currentNum);
                      }
                    } else {
                      controller.text = '12';
                      if(onChanged != null) {
                        onChanged!(12);
                      }
                    }
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(1),
                  child: SvgPicture.asset(
                    'assets/icons/number_text_field_down.svg',
                    height: 4,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}