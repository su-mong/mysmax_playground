import 'package:flutter/cupertino.dart';

extension NavigatorHelper on Widget {
  Future pushByPageRoute(BuildContext context, {String? routeName}) {
    return Navigator.push(
      context,
      CupertinoPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => this,
      ),
    );
  }

  Future pushReplaceByPageRoute(BuildContext context, {String? routeName}) {
    return Navigator.pushReplacement(
      context,
      CupertinoPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => this,
      ),
    );
  }

  Future pushReplaceWithPopAnimation(BuildContext context) {
    return Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => this,
        transitionsBuilder: _popTransitionBuilder,
        transitionDuration: const Duration(milliseconds: 100),
        reverseTransitionDuration: const Duration(milliseconds: 100),
      ),
    );
  }

  Widget _popTransitionBuilder(
    _,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1.0, 0.0),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }
}

//임시
Route defaultPageRoute({required Widget Function(BuildContext) builder}) {
  return CupertinoPageRoute(builder: builder);
}
