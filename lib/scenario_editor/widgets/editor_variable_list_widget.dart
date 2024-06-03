import 'package:flutter/material.dart';
import 'package:mysmax_playground/app_text_styles.dart';

/// NOTE| 현재 동작은 다음과 같다.
/// NOTE| 1. 기존에 선택된 변수가 있다 : 해당 변수 선택된 상태, 변수명 변경 및 추가 불가능
/// NOTE| 2. 기존에 선택된 변수가 없다 : 변수 미선택 상태, 변수명 추가 가능
/// NOTE| 2-1. 선택된 변수가 없는 상태에서 새 변수 추가 : 추가된 변수 자동 선택.
/// TODO: 현재는 한 번 선택된 변수는 해제가 불가능하다. 이거 변경이 필요하긴 함.
class EditorVariableListWidget extends StatefulWidget {
  final List<String> variableList;
  final String? initialSelectedVariable;
  final VoidCallback addNewVariable;

  const EditorVariableListWidget({
    super.key,
    required this.variableList,
    required this.initialSelectedVariable,
    required this.addNewVariable,
  });

  @override
  State<StatefulWidget> createState() => _EditorVariableListWidgetState();
}

class _EditorVariableListWidgetState extends State<EditorVariableListWidget> {
  late final TextEditingController _searchController;
  late final FocusNode _searchFocusNode;

  List<String> _variableList = [];

  @override
  void initState() {
    super.initState();

    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();
    _variableList = widget.variableList;
  }

  @override
  void didUpdateWidget(covariant EditorVariableListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if(oldWidget != widget) {
      _searchController.clear();
      _variableList = widget.variableList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '변수값 저장',
          style: AppTextStyles.size11Medium.copyWith(color: const Color(0xFF8F94A4)),
        ),

        const SizedBox(height: 12),
        TextFormField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          keyboardType: TextInputType.name,
          onChanged: onChangedSearchTerm,
          // textInputAction: TextInputAction.search,
          // onFieldSubmitted: onSearch,
          style: AppTextStyles.size12Regular.copyWith(
            height: 22 / 12,
            letterSpacing: -0.36,
          ),
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 9,
              vertical: 8,
            ),
            hintText: '변수 값 검색',
            hintStyle: AppTextStyles.size12Regular.copyWith(
              color: const Color(0xFFADB3C6),
              height: 22 / 12,
              letterSpacing: -0.36,
            ),
            fillColor: const Color(0xFFFFFFFF),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(width: 1, color: Color(0xFFE9ECF5)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(width: 1, color: Color(0xFFE9ECF5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(width: 1, color: Color(0xFFE9ECF5)),
            ),
            /*
            suffixIconConstraints: const BoxConstraints(minHeight: 38, maxHeight: 38),
            suffixIcon: GestureDetector(
              onTap: () => onSearch(_searchController.text),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 12),
                child: SvgPicture.asset(
                  'assets/icons/scenario_editor_search.svg',
                  height: 13,
                ),
              ),
            ),
            */
          ),
        ),

        const SizedBox(height: 4),
        ListView.separated(
          shrinkWrap: true,
          itemCount: _variableList.length,
          itemBuilder: (_, index) => Container(
            height: 30,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: _variableList[index] == widget.initialSelectedVariable
                  ? const Color(0xFFEBEFF9)
                  : null,
              borderRadius: BorderRadius.circular(7),
            ),
            child: Text(
              _variableList[index],
              style: AppTextStyles.size13Medium.singleLine,
            ),
          ),
          separatorBuilder: (_, __) => const Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Divider(height: 1, color: Color(0xFFF0F2F9)),
          ),
        ),

        if(widget.initialSelectedVariable == null) ...[
          const SizedBox(height: 12),
          GestureDetector(
            onTap: widget.addNewVariable,
            child: Text(
              '자동으로 변수명 추가',
              style: AppTextStyles.size13Bold.copyWith(
                letterSpacing: -0.39,
                color: const Color(0xFF5D7CFF),
              ),
            ),
          ),
        ],
      ],
    );
  }

  void onChangedSearchTerm(String term) {
    setState(() {
      _variableList = widget.variableList.where(
        (element) {
          if(term.isEmpty) {
            return true;
          } else {
            return element.contains(term);
          }
        }
      ).toList();
    });
  }
}