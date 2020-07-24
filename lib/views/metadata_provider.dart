import 'package:flutter/material.dart';
import 'package:freetitle/model/post_repository.dart';

class MetaDataProvider extends InheritedWidget {
  int tabIndex = 0;

  MetaDataProvider({
    Widget child,
  }) : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) =>  true;

  static MetaDataProvider of(BuildContext context) => context.dependOnInheritedWidgetOfExactType();
}