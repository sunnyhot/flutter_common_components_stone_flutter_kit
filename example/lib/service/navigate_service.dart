import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigateService {
  static NavigateService _instance;

  static NavigateService get instance {
    _instance ??= NavigateService._();
    return _instance;
  }

  static NavigateService get I => instance;

  NavigateService._();

  final GlobalKey<NavigatorState> key = GlobalKey(debugLabel: 'navigate_key');

  NavigatorState get navigator => key.currentState;

  Future<T> push<T extends Object>(Widget page, {String routeName, Object arguments}) {
    return navigator.push<T>(
      CupertinoPageRoute(
        settings: RouteSettings(
          name: routeName,
          arguments: arguments,
        ),
        builder: (_) => page,
      ),
    );
  }

  Future<T> pushNamed<T extends Object>(String routeName, {Object arguments}) {
    return navigator.pushNamed<T>(routeName, arguments: arguments);
  }

  Future<T> pushReplacement<T extends Object, TO extends Object>(Widget page, {
    String routeName,
    Object arguments,
    TO result,
  }) {
    return navigator.pushReplacement<T, TO>(
      CupertinoPageRoute(
        settings: RouteSettings(
          name: routeName,
          arguments: arguments,
        ),
        builder: (_) => page,
      ),
      result: result,
    );
  }

  Future<T> pushReplacementNamed<T extends Object, TO extends Object>(String routeName, {Object arguments, TO result}) {
    return navigator.pushReplacementNamed<T, TO>(routeName, arguments: arguments, result: result);
  }

  Future<T> pushAndRemoveUntil<T extends Object>(Widget page, {String routeName, Object arguments, untilRouteName}) {
    return navigator.pushAndRemoveUntil<T>(
      CupertinoPageRoute(
        settings: RouteSettings(
          name: routeName,
          arguments: arguments,
        ),
        builder: (_) => page,
      ), (_) => false,
    );
  }

  bool pop<T extends Object>([T result]) {
    return navigator.pop<T>(result);
  }

  void popUntil(String routeName) {
    navigator.popUntil(ModalRoute.withName(routeName));
  }

  void popToHome() {
    navigator.popUntil(ModalRoute.withName('/'));
  }

  bool canPop() {

    return navigator.canPop();
  }

  Future<bool> maybePop<T extends Object>([T result]) async {
    return navigator.maybePop<T>(result);
  }
}