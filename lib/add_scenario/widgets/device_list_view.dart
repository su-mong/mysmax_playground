import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mysmax_playground/add_scenario/view_models/add_scenario_view_model.dart';
import 'package:mysmax_playground/app_text_styles.dart';
import 'package:mysmax_playground/colors.dart';
import 'package:mysmax_playground/core/scenario_code_parser/block.dart';
import 'package:mysmax_playground/core/viewmodels/mqtt_view_model.dart';
import 'package:mysmax_playground/helper/icon_helper.dart';
import 'package:mysmax_playground/models/thing_function.dart';
import 'package:provider/provider.dart';

class DeviceListView extends StatefulWidget {
  final Block? parentBlock;
  const DeviceListView({Key? key, this.parentBlock}) : super(key: key);

  @override
  _DeviceListViewState createState() => _DeviceListViewState();
}

class _DeviceListViewState extends State<DeviceListView> {
  TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var mqttViewModel = context.watch<MqttViewModel>();
    var things = mqttViewModel.thingList
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
                  hintText: '디바이스 검색',
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
            itemBuilder: (context, index) {
              var thing = things[index];
              return ExpansionTile(
                initiallyExpanded: true,
                backgroundColor: Colors.white,
                collapsedBackgroundColor: Colors.white,
                title: Text(
                  things[index].name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF45507D),
                  ),
                ),
                children: things[index]
                    .functions
                    .map((e) => _buildFunctionItem(e))
                    .toList(),
              );
            },
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: Color(0xfff0f2f9),
              indent: 18,
              endIndent: 18,
            ),
            itemCount: things.length,
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
      IconHelper.getServiceIcon(function.category ?? ''),
      height: 19,
      fit: BoxFit.fitHeight,
      errorBuilder: IconHelper.iconErrorWidgetBuilder(height: 19),
    );
  }
}
