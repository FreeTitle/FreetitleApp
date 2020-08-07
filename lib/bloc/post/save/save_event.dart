import 'package:freetitle/model/post_repository.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class SaveEvent extends Equatable {
  SaveEvent([List props = const []]) : super(props);
}

class PostLoaded extends SaveEvent {
  @override
  String toString() => "Post Loaded";
}

class SavePressed extends SaveEvent {

  final PostType type;

  SavePressed({@required this.type}): super([type]);

  @override
  String toString() => 'Save Pressed on $type';
}

class UnsavePressed extends SaveEvent {

  final PostType type;

  UnsavePressed({@required this.type}): super([type]);

  @override
  String toString() => "Unsave Pressed $type";
}


