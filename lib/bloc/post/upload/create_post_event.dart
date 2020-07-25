import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class UploadPostEvent extends Equatable {
  UploadPostEvent([List props = const []]) : super(props);
}

class TextChanged extends UploadPostEvent {
  final String postText;

  TextChanged({@required this.postText}) : super([postText]);

  @override
  String toString() => 'Text changed { text :$postText }';
}

class Submitted extends UploadPostEvent {
  final String postText;

  Submitted({@required this.postText})
      : super([postText]);

  @override
  String toString() {
    return 'Submitted{ text :$postText }';
  }
}
