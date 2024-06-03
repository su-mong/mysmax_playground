import 'package:flutter/material.dart';
import 'package:mysmax_playground/core/scenario_code_parser/block.dart';
import 'package:mysmax_playground/scenario_mixin.dart';
import 'package:provider/provider.dart';

class ScenarioItemPreviewPage extends StatefulWidget {
  final Block item;
  const ScenarioItemPreviewPage({Key? key, required this.item})
      : super(key: key);

  @override
  _ScenarioItemPreviewPageState createState() =>
      _ScenarioItemPreviewPageState();
}

class _ScenarioItemPreviewPageState extends State<ScenarioItemPreviewPage> {
  // TODO: viewmodel에 임시 아이템 추가해야할듯함
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('시나리오 만들기'),
        backgroundColor: const Color(0xffF9FAFC),
        actions: [
          TextButton(
            onPressed: () {
              final viewModel = context.read<ScenarioMixin>();
              viewModel.addScenarioItem(widget.item);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text(
              '완료',
              style: TextStyle(
                color: const Color(0xff45507B),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Container();
    // return Container(
    //   child: Column(
    //     children: [
    //       ScenarioItemWidget(widget.item),
    //     ],
    //   ),
    // );
  }
}
