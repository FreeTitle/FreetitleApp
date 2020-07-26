import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class MetaDataProvider extends InheritedWidget {
  final EasyRefreshController postListRefreshController;
  final EasyRefreshController eventListRefreshController;
  final EasyRefreshController projectListRefreshController;

  MetaDataProvider({
    Widget child,
    this.postListRefreshController,
    this.eventListRefreshController,
    this.projectListRefreshController
  }) : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) =>  true;

  static MetaDataProvider of(BuildContext context) => context.dependOnInheritedWidgetOfExactType();
}