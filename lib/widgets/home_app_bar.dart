import 'package:flutter/material.dart';
import 'package:mysmax_playground/app_text_styles.dart';
import 'package:mysmax_playground/colors.dart';

final _kAppBarTitleTextStyle = AppTextStyles.size17Medium.singleLine;
const _kAppBarBackgroundColor = AppColors.bottomNavigatorBackgroundColor;

final kTextActionTextStyle = AppTextStyles.size14Medium.singleLine;

class LinedAppBar {
  static AppBar build(
      BuildContext context, {
        Color? backgroundColor,
        List<Widget>? actions,
      }) {
    return AppBar(
      toolbarHeight: 40,
      backgroundColor: backgroundColor ?? _kAppBarBackgroundColor,
      title: const Text('_buildUserInfo'),
      actions: actions,
    );
  }

  static AppBar buildWithTitle({
    required String title,
    Widget? titleWidget,
    Widget? leading,
    List<Widget>? actions,
    PreferredSizeWidget? bottom,
    double elevation = 0,
    bool centerTitle = true,
    Color? backgroundColor,
    IconThemeData? iconTheme,
  }) {
    return AppBar(
      title: titleWidget ?? _buildTitleText(title),
      backgroundColor: backgroundColor ?? _kAppBarBackgroundColor,
      elevation: elevation,
      leading: leading,
      centerTitle: centerTitle,
      actions: actions,
      bottom: bottom,
      iconTheme: iconTheme,
    );
  }

  static _buildTitleText(String title) {
    return Text(
      title,
      style: _kAppBarTitleTextStyle,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
  }

  static Color indexToCircleColor(int index) {
    switch (index) {
      case 0:
        return Color(0xffcad0e0);
      default:
        return Color(0xffe8ebf5);
    }
  }
}
