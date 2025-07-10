import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();

  Future<T?> pushNamed<T extends Object?>(
      String routeName, {
        Object? args,
      }) async {
    return navigationKey.currentState?.pushNamed<T>(
      routeName,
      arguments: args,
    );
  }

  Future<T?> push<T extends Object?>(Route<T> route) async {
    return navigationKey.currentState?.push<T>(route);
  }

  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
      String routeName, {
        Object? args,
        TO? result,
      }) async {
    return navigationKey.currentState?.pushReplacementNamed<T, TO>(
      routeName,
      arguments: args,
      result: result,
    );
  }

  Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
      String routeName, {
        bool Function(Route<dynamic>)? predicate,
        Object? args,
      }) async {
    return navigationKey.currentState?.pushNamedAndRemoveUntil<T>(
      routeName,
      predicate ?? (_) => false,
      arguments: args,
    );
  }

  Future<T?> pushAndRemoveUntil<T extends Object?>(
      Route<T> route, {
        bool Function(Route<dynamic>)? predicate,
      }) async {
    return navigationKey.currentState?.pushAndRemoveUntil<T>(
      route,
      predicate ?? (_) => false,
    );
  }

  Future<bool?> maybePop<T extends Object?>([T? result]) async {
    return navigationKey.currentState?.maybePop<T>(result);
  }

  bool canPop() => navigationKey.currentState!.canPop();

  void goBack<T extends Object?>({T? result}) {
    navigationKey.currentState?.pop<T>(result);
  }

  void popUntil(String route) {
    navigationKey.currentState?.popUntil(ModalRoute.withName(route));
  }

  void pop() {
    navigationKey.currentState?.pop();
  }

  RouteSettings? pageSettings(BuildContext context) {
    return ModalRoute.of<RouteSettings>(context)?.settings;
  }
}