import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class CreatePostEvent extends Equatable {
  CreatePostEvent([List props = const []]) : super(props);
}

class TextChanged extends CreatePostEvent {
  final String postText;

  TextChanged({@required this.postText}) : super([postText]);

  @override
  String toString() => 'Text changed { text :$postText }';
}

class Submitted extends CreatePostEvent {
  final String postText;

  Submitted({@required this.postText})
      : super([postText]);

  @override
  String toString() {
    return 'Submitted{ text :$postText }';
  }
}
