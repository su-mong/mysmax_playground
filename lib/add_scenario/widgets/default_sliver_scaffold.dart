import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mysmax_playground/app_text_styles.dart';
import 'package:mysmax_playground/colors.dart';
import 'package:mysmax_playground/widgets/home_app_bar.dart';

const _kBackgroundColor = AppColors.cardBackground;

class DefaultSliverScaffold extends StatelessWidget {
  const DefaultSliverScaffold({
    Key? key,
    this.tabBackgroundColor = AppColors.cardBackground,
    required this.tabViews,
    this.actions,
    this.isScrollable = false,
    required this.tabs,
    this.tabController,
    this.title,
    this.centerTitle = false,
    this.centerTab = true,
    this.hasBottomSafeArea = true,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.titleStyle,
    this.labelStyle,
    this.unselectedLabelStyle,
    this.unselectedLabelColor,
    this.selectedLabelColor,
    this.labelPadding,
    this.onTapTab,
    this.headerSliver,
    this.indicatorPadding,
    this.tabBarSidePadding,
    this.backgroundColor,
    this.appBar,
    this.translateTabY = 0,
  }) : super(key: key);

  final Color tabBackgroundColor;
  final String? title;
  final List<Widget> tabs;
  final List<Widget> tabViews;
  final List<Widget>? actions;
  final bool isScrollable;
  final TabController? tabController;
  final bool centerTitle;
  final bool centerTab;
  final bool hasBottomSafeArea;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final TextStyle? titleStyle;
  final TextStyle? labelStyle;
  final TextStyle? unselectedLabelStyle;
  final Color? unselectedLabelColor;
  final Color? selectedLabelColor;
  final double? labelPadding;
  final ValueChanged<int>? onTapTab;
  final Widget? headerSliver;
  final EdgeInsets? indicatorPadding;
  final EdgeInsets? tabBarSidePadding;
  final double translateTabY;
  final Color? backgroundColor;
  final PreferredSizeWidget? appBar;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor ?? _kBackgroundColor,
      child: SafeArea(
        bottom: hasBottomSafeArea,
        child: Scaffold(
          appBar: appBar ??
              LinedAppBar.build(
                context,
                backgroundColor: tabBackgroundColor,
                actions: actions,
              ),
          backgroundColor: tabBackgroundColor,
          body: _buildBody(),
          floatingActionButtonLocation: floatingActionButtonLocation,
          floatingActionButton: floatingActionButton,
        ),
      ),
    );
  }

  Widget _buildBody() {
    return DefaultTabController(
      length: tabViews.length,
      child: ExtendedNestedScrollView(
        pinnedHeaderSliverHeightBuilder: () {
          return kTextTabBarHeight - translateTabY * 2;
        },
        onlyOneScrollInBody: true,
        floatHeaderSlivers: true,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            // SliverToBoxAdapter(child: Container(height: kToolbarHeight)),
            _buildTabBar(),
            if (headerSliver != null) headerSliver!,
          ];
        },
        body: TabBarView(
          children: tabViews,
          controller: tabController,
        ),
      ),
    );
  }

  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      primary: false,
      title: title != null
          ? Text(
              title!,
              style: titleStyle ?? AppTextStyles.size41Bold,
            )
          : null,
      backgroundColor: backgroundColor ?? _kBackgroundColor,
      elevation: 0,
      centerTitle: centerTitle,
      floating: true,
      actions: actions,
      systemOverlayStyle: SystemUiOverlayStyle.light,
    );
  }

  SliverAppBar _buildTabBar() {
    return SliverAppBar(
      titleSpacing: 0,
      automaticallyImplyLeading: false,
      pinned: true,
      backgroundColor: backgroundColor ?? _kBackgroundColor,
      toolbarHeight: kTextTabBarHeight,
      centerTitle: centerTab,
      title: TabBar(
        onTap: onTapTab,
        controller: tabController,
        tabs: tabs,
        indicatorColor: Colors.transparent,
        padding: tabBarSidePadding ??
            const EdgeInsets.symmetric(horizontal: 30.0),
        labelPadding: labelPadding != null
            ? EdgeInsets.symmetric(horizontal: labelPadding!)
            : null,
        labelStyle: labelStyle ?? AppTextStyles.size16Medium,
        labelColor: selectedLabelColor ?? const Color(0xff3F424A),
        unselectedLabelStyle:
            unselectedLabelStyle ?? AppTextStyles.size11Medium,
        unselectedLabelColor:
            unselectedLabelColor ?? AppColors.deactivateTabColor,
        isScrollable: isScrollable,
        indicatorPadding: indicatorPadding ?? EdgeInsets.zero,
      ),
      elevation: 0,
      // bottom: _buildTabBarBottom(),
    );
  }
}
