import 'package:flutter/material.dart';

class AppWidgets {
  static Widget scaffold(
      {PreferredSizeWidget? appBar,
      required Widget body,
      EdgeInsets? padding,
      Color? backgroundColor,
      bool? resizeToAvoidBottomInset}) {
    return Scaffold(
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        appBar: appBar,
        backgroundColor: backgroundColor ?? const Color(0xffF8F9FD),
        body: SafeArea(
          child: Padding(
            padding: padding ??
                const EdgeInsets.symmetric(
                  horizontal: 30.0,
                ),
            child: body,
          ),
        ));
  }
}