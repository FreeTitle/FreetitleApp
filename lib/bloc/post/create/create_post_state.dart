import 'package:meta/meta.dart';
import 'package:provider/provider.dart';

@immutable
class CreatePostState {
  final bool isTextValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool failure_INVALID_NUMBER_OF_WORDS;

  CreatePostState({
    @required this.isTextValid,
    @required this.isSubmitting,
    @required this.isSuccess,
    @required this.failure_INVALID_NUMBER_OF_WORDS
  });

  factory CreatePostState.empty() {
    return CreatePostState(
      isTextValid: true,
      isSubmitting: false,
      isSuccess: false,
      failure_INVALID_NUMBER_OF_WORDS: false
    );
  }

  factory CreatePostState.loading() {
    return CreatePostState(
      isTextValid: true,
      isSubmitting: true,
      isSuccess: true,
      failure_INVALID_NUMBER_OF_WORDS: false
    );
  }

  factory CreatePostState.failure_INVALID_NUMBER_OF_WORDS() {
    return CreatePostState(
      isTextValid: false,
      isSubmitting: false,
      isSuccess: false,
      failure_INVALID_NUMBER_OF_WORDS: true
    );
  }

  factory CreatePostState.success() {
    return CreatePostState(
      isTextValid: true,
      isSubmitting: false,
      isSuccess: true,
      failure_INVALID_NUMBER_OF_WORDS: false
    );
  }

  CreatePostState update({
    bool isTextValid
  }){
    return copyWith(
      isTextValid: isTextValid,
      isSubmitting: false,
      isSuccess: false,
      failure_INVALID_NUMBER_OF_WORDS: false
    );
  }


  CreatePostState copyWith({
    bool isTextValid,
    bool isSubmitting,
    bool isSuccess,
    bool failure_INVALID_NUMBER_OF_WORDS
  }){
    return CreatePostState(
        isTextValid: isTextValid ?? this.isTextValid,
        isSubmitting: isSubmitting ?? this.isSubmitting,
        isSuccess: isSuccess ?? this.isSuccess,
        failure_INVALID_NUMBER_OF_WORDS: failure_INVALID_NUMBER_OF_WORDS ?? this.failure_INVALID_NUMBER_OF_WORDS
    );
  }

  @override
  String toString() {
    return '''CreatePostState(
        isTextValid: $isTextValid,
        isSubmitting: $isSubmitting,,
        isSuccess: $isSuccess,,
        failure_INVALID_NUMBER_OF_WORDS: $failure_INVALID_NUMBER_OF_WORDS
        )''';
  }

}