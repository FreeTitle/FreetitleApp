import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class LikeEvent extends Equatable {
  LikeEvent([List props = const []]) : super(props);
}

class PostLoaded extends LikeEvent {
  @override
  String toString() => "Post Loaded";
}

class LikePressed extends LikeEvent {
  @override
  String toString() => 'Like Pressed';
}

class UnlikePressed extends LikeEvent {
  @override
  String toString() => "Unlike Pressed";
}


