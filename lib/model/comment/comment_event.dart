import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class CommentEvent extends Equatable {
  CommentEvent([List props = const []]) : super(props);
}

class UploadCommentButtonPressed extends CommentEvent {
  @override
  String toString() => "Upload Comment Button Pressed";
}
