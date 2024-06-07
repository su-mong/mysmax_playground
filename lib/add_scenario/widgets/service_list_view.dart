import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mysmax_playground/add_scenario/view_models/add_scenario_view_model.dart';
import 'package:mysmax_playground/colors.dart';
import 'package:mysmax_playground/core/scenario_code_parser/block.dart';
import 'package:mysmax_playground/core/viewmodels/mqtt_view_model.dart';
import 'package:mysmax_playground/helper/icon_helper.dart';
import 'package:mysmax_playground/models/thing_function.dart';
import 'package:provider/provider.dart';

import '../../app_text_styles.dart';

class ServiceListView extends StatefulWidget {
  final Block? parentBlock;
  const ServiceListView({Key? key, this.parentBlock}) : super(key: key);

  @override
  _ServiceListViewState createState() => _ServiceListViewState();
}

class _ServiceListViewState extends State<ServiceListView> {
  TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var mqttViewModel = context.watch<MqttViewModel>();
    var functions = mqttViewModel.serviceFunctionList
        .where((element) => _searchController.text.isEmpty
            ? true
            : element.name
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()))
        .toList();
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppColors.cardBackground,
            flexibleSpace: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: '서비스 검색',
                  hintStyle: AppTextStyles.size14Regular
                      .heightWith(1)
                      .copyWith(color: Color(0xffadb3c6)),
                  suffixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Color(0xffe9ecf5),
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Color(0xffe9ecf5),
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),
            floating: true,
            snap: true,
            automaticallyImplyLeading: false,
          ),
          SliverList.separated(
            itemBuilder: (_, index) {
              var function = functions[index];
              return _buildFunctionItem(function);
            },
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: Color(0xfff0f2f9),
              indent: 18,
              endIndent: 18,
            ),
            itemCount: functions.length,
          )
        ],
      ),
    );
  }

  Widget _buildFunctionItem(ThingFunction function) {
    return GestureDetector(
      onTap: () {
        var viewModel = context.read<AddScenarioViewModel>();
        if (widget.parentBlock != null) {
          viewModel.addChildScenarioItem(
              parent: widget.parentBlock!,
              child: FunctionServiceBlock.fromService(function));
        } else {
          viewModel.addScenarioItem(FunctionServiceBlock.fromService(function));
        }
        Navigator.pop(context);
      },
      child: ListTile(
        tileColor: Colors.white,
        leading: _buildIcon(function),
        title: Text(
          function.name,
          style: AppTextStyles.size16Medium.singleLine,
        ),
      ),
    );
  }

  Widget _buildIcon(ThingFunction function) {
    return Image.asset(
      IconHelper.getServiceIcon(function.category),
      height: 19,
      fit: BoxFit.fitHeight,
      errorBuilder: IconHelper.iconErrorWidgetBuilder(height: 19),
    );
  }
}
