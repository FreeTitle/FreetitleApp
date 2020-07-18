import 'package:meta/meta.dart';

@immutable
class CommentState {
  final bool isTextValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool failure_ERROR_TEXT_REACHES_MAXIMUM;

  CommentState({
    @required this.isTextValid,
    @required this.isSubmitting,
    @required this.isSuccess,
    @required this.failure_ERROR_TEXT_REACHES_MAXIMUM
  });

  factory CommentState.empty() {
    return CommentState(
      isTextValid: true,
      isSubmitting: false,
      isSuccess: false,
      failure_ERROR_TEXT_REACHES_MAXIMUM: false
    );
  }

  factory CommentState.submitting() {
    return CommentState(
      isTextValid: true,
      isSubmitting: true,
      isSuccess: false,
      failure_ERROR_TEXT_REACHES_MAXIMUM: false
    );
  }

  factory CommentState.success() {
    return CommentState(
      isTextValid: true,
      isSubmitting: false,
      isSuccess: true,
      failure_ERROR_TEXT_REACHES_MAXIMUM: false
    );
  }

  factory CommentState.failure_ERROR_TEXT_REACHES_MAXIMUM() {
    return CommentState(
      isTextValid: false,
      isSubmitting: false,
      isSuccess: false,
      failure_ERROR_TEXT_REACHES_MAXIMUM: true
    );
  }
}