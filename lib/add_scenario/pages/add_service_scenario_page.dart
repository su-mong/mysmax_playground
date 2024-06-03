import 'package:flutter/material.dart';
import 'package:mysmax_playground/add_scenario/view_models/add_service_scenario_view_model.dart';
import 'package:mysmax_playground/add_scenario/widgets/default_sliver_scaffold.dart';
import 'package:mysmax_playground/add_scenario/widgets/device_list_view.dart';
import 'package:mysmax_playground/add_scenario/widgets/service_list_view.dart';
import 'package:mysmax_playground/app_text_styles.dart';
import 'package:mysmax_playground/colors.dart';
import 'package:mysmax_playground/core/scenario_code_parser/block.dart';
import 'package:mysmax_playground/helper/navigator_helper.dart';
import 'package:mysmax_playground/widgets/home_app_bar.dart';
import 'package:provider/provider.dart';

class AddServiceScenarioPage extends StatefulWidget {
  final Block? parentBlock;
  const AddServiceScenarioPage({Key? key, this.parentBlock}) : super(key: key);

  Future push(BuildContext context) {
    final viewModel = AddServiceScenarioViewModel();
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: this,
    ).pushByPageRoute(context);
  }

  @override
  _AddServiceScenarioPageState createState() => _AddServiceScenarioPageState();
}

class _AddServiceScenarioPageState extends State<AddServiceScenarioPage>
    with TickerProviderStateMixin {
  late final Map<String, Widget> _kTapMap;

  late final TabController tabController;
  final PageController _pageController = PageController(initialPage: 0);
  PageController get pageController => _pageController;

  int _currentServiceIndex = 0;
  int get currentServiceIndex => _currentServiceIndex;
  set currentServiceIndex(int index) {
    setState(() {
      _currentServiceIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _kTapMap = {
      '서비스': ServiceListView(parentBlock: widget.parentBlock),
      '디바이스': DeviceListView(parentBlock: widget.parentBlock),
    };

    tabController = TabController(
      vsync: this,
      length: _kTapMap.keys.length,
    );

    tabController.addListener(() {
      if (tabController.index != tabController.previousIndex) {
        currentServiceIndex = tabController.index;
      }
    });
    /*Future.delayed(const Duration(seconds: 8), () {
      if (currentServiceIndex == 0 && pageController.page == 0 && PrimaryScrollController.of(context).offset == 0) {
        PrimaryScrollController.of(context).animateTo(
          kMinInteractiveDimension,
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease,
        );
      }
    });*/
  }

  @override
  Widget build(BuildContext context) {
    return DefaultSliverScaffold(
      title: '서비스 실행',
      titleStyle: AppTextStyles.size17Medium.singleLine,
      appBar: LinedAppBar.buildWithTitle(
        title: '서비스 실행',
        backgroundColor: AppColors.cardBackground,
      ),
      backgroundColor: AppColors.cardBackground,
      centerTitle: true,
      tabController: tabController,
      tabViews: _kTapMap.values.toList(),
      tabs: _kTapMap.keys.map((e) => _buildTabWidget(e)).toList(),
      actions: [],
      isScrollable: true,
      centerTab: false,
      labelStyle: AppTextStyles.size21Bold.singleLine,
      selectedLabelColor: const Color(0xff3F424A),
      unselectedLabelStyle: AppTextStyles.size21Bold.singleLine,
      unselectedLabelColor: const Color(0xffC8CDDD),
      labelPadding: 6.0,
      tabBarSidePadding: const EdgeInsets.symmetric(horizontal: 6.0),
      onTapTab: (index) {
        if (!tabController.indexIsChanging) {
          PrimaryScrollController.of(context).jumpTo(0);
        }
      },
    );
  }

  Tab _buildTabWidget(String title) {
    return Tab(
      child: Padding(
        padding: const EdgeInsets.only(right: 4.0, top: 4.0, left: 4.0),
        child: Text(
          title,
        ),
      ),
    );
  }


}
