import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mysmax_playground/app_text_styles.dart';
import 'package:mysmax_playground/colors.dart';
import 'package:mysmax_playground/models/tag.dart';

class TagListWidget extends StatefulWidget {
  final bool isEditTagMode;
  final bool isDeleteTagMode;
  final Function(bool) onIsEditTagModeChanged;
  final Function(bool)? onIsDeleteTagModeChanged;
  final TextEditingController controller;
  final FocusNode focusNode;
  final List<Tag> totalTags;
  final List<Tag> initialSelectedTags;
  final Function(Tag) onAddTagChanged;
  final Function(Tag)? onDeleteTagChanged;
  final Function(List<Tag>) onSelectedTagsChanged;

  const TagListWidget({
    Key? key,
    required this.isEditTagMode,
    this.isDeleteTagMode = false,
    required this.onIsEditTagModeChanged,
    this.onIsDeleteTagModeChanged,
    required this.controller,
    required this.focusNode,
    required this.totalTags,
    required this.initialSelectedTags,
    required this.onAddTagChanged,
    this.onDeleteTagChanged,
    required this.onSelectedTagsChanged,
  }) : super(key: key);

  @override
  _TagListWidgetState createState() => _TagListWidgetState();
}

class _TagListWidgetState extends State<TagListWidget> {
  List<Tag> selectedTags = [];

  @override
  void initState() {
    selectedTags = widget.initialSelectedTags;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Wrap(
            spacing: 6,
            runSpacing: 6,
            children: List.generate(widget.totalTags.length + 1, (index) {
              if (index == widget.totalTags.length && !widget.isEditTagMode) {
                return GestureDetector(
                    child: SvgPicture.asset('assets/icons/add.svg'),
                    onTap: () {
                      widget.onIsEditTagModeChanged(true);
                      widget.focusNode.requestFocus();
                    });
              } else if (index == widget.totalTags.length &&
                  widget.isEditTagMode) {
                return Container(
                  constraints: BoxConstraints(
                    maxWidth: 1000,
                  ),
                  height: 25,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                  alignment: Alignment.center,
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1, color: Color(0xFFE9ECF5)),
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: TextField(
                    controller: widget.controller,
                    focusNode: widget.focusNode,
                    textAlignVertical: TextAlignVertical.center,
                    style: AppTextStyles.size12Medium.singleLine,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                        bottom: 25 / 2, // HERE THE IMPORTANT PART
                      ),
                      hintText: '태그 추가',
                      hintStyle: AppTextStyles.size12Medium.singleLine.copyWith(
                        color: const Color(0xff3F424B).withOpacity(0.5),
                      ),
                    ),
                    onSubmitted: (value) {
                      widget.onAddTagChanged(Tag(name: value));
                      widget.controller.clear();
                      widget.onIsEditTagModeChanged(false);
                      FocusScope.of(context).unfocus();
                    },
                  ),
                );
              }
              var e = widget.totalTags[index];
              return Stack(
                alignment: AlignmentDirectional.topEnd,
                children: [
                  GestureDetector(
                    onLongPress: () {
                      if (widget.onIsDeleteTagModeChanged != null) {
                        widget.onIsDeleteTagModeChanged!(true);
                      }
                    },
                    onTap: () {
                      setState(() {
                        if (selectedTags.contains(e)) {
                          selectedTags.remove(e);
                        } else {
                          selectedTags.add(e);
                        }
                      });
                      widget.onSelectedTagsChanged(selectedTags);
                    },
                    child: Container(
                      margin: widget.isDeleteTagMode
                          ? const EdgeInsets.only(right: 4, top: 4)
                          : null,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 9, vertical: 5),
                      clipBehavior: Clip.antiAlias,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              width: 1,
                              color: selectedTags.contains(e)
                                  ? AppColors.blue
                                  : Color(0xFFE9ECF5)),
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        e.name,
                        style: AppTextStyles.size11Medium.singleLine.copyWith(
                          color: selectedTags.contains(e)
                              ? AppColors.blue
                              : const Color(0xff3F424B),
                        ),
                      ),
                    ),
                  ),
                  if (widget.isDeleteTagMode) ...[
                    GestureDetector(
                      onTap: () {
                        widget.onDeleteTagChanged!(e);
                      },
                      child: Icon(
                        Icons.remove_circle,
                        color: AppColors.red,
                        size: 16,
                      ),
                    )
                  ]
                ],
              );
            }),
            // shrinkWrap: true,
            // scrollDirection: Axis.horizontal,
            // itemCount: widget.totalTags.length + 1,
            // itemBuilder: (context, index) {
            //
            // },
          ),
        )
      ],
    );
  }
}
