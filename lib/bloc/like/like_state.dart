import 'package:meta/meta.dart';

@immutable
class LikeState {
  final bool isLike;
  final bool isUnlike;
  final bool isLikeButtonEnabled;
  final bool isSubmitting;
  final bool isSuccess;
  final bool failure_LIKE_PRESSED;

  LikeState({
   @required this.isLike,
   @required this.isUnlike,
   @required this.isSubmitting,
   @required this.isLikeButtonEnabled,
   @required this.isSuccess,
   @required this.failure_LIKE_PRESSED
  });


  factory LikeState.liked() {
    return LikeState(
      isLike: true,
      isUnlike: false,
      isSubmitting: false,
      isLikeButtonEnabled: true,
      isSuccess: false,
      failure_LIKE_PRESSED: false
    );
  }

  factory LikeState.unliked() {
    return LikeState(
      isLike: false,
      isUnlike: true,
      isSubmitting: false,
      isLikeButtonEnabled: true,
      isSuccess: false,
      failure_LIKE_PRESSED: false
    );
  }

  factory LikeState.likeSubmitting() {
    return LikeState(
      isLike: true,
      isUnlike: false,
      isSubmitting: true,
      isLikeButtonEnabled: false,
      isSuccess: false,
      failure_LIKE_PRESSED: false
    );
  }

  factory LikeState.unlikeSubmitting() {
    return LikeState(
        isLike: false,
        isUnlike: true,
        isSubmitting: true,
        isLikeButtonEnabled: false,
        isSuccess: false,
        failure_LIKE_PRESSED: false
    );
  }

//  factory LikeState.likeSuccess() {
//    return LikeState(
//      isLike: true,
//      isUnlike: false,
//      isSubmitting: false,
//      isLikeButtonEnabled: true,
//      isSuccess: true,
//      Failure_LIKE_PRESSED: false
//    );
//  }
//
//  factory LikeState.unlikeSucceess() {
//    return LikeState(
//      isLike: false,
//      isUnlike: true,
//      isSubmitting: false,
//      isLikeButtonEnabled: true,
//      isSuccess: true,
//      Failure_LIKE_PRESSED: false
//    );
//  }
//
//  factory LikeState.Failure_LIKE_PRESSED() {
//    return LikeState(
//      isLike: false,
//      isUnlike: false,
//      isSubmitting: false,
//      isSuccess: false,
//      Failure_LIKE_PRESSED: true
//    );
//  }

  LikeState copyWith({
    bool isLike,
    bool isUnlike,
    bool isSubmitting,
    bool isSuccess,
    bool isLikeButtonEnabled,
    Failure_LIKE_PRESSED: false
  }) {
    return LikeState(
      isLike: isLike ?? this.isLike,
      isUnlike: isUnlike ?? this.isUnlike,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isLikeButtonEnabled: isLikeButtonEnabled ?? this.isLikeButtonEnabled,
      failure_LIKE_PRESSED: Failure_LIKE_PRESSED ?? this.failure_LIKE_PRESSED
    );
  }

  @override
  String toString() {
    return '''
      LikeState{
        isLike: $isLike,
        isUnlike: $isUnlike,
        isSubmitting: $isSubmitting,
        isSuccess: $isSuccess,
        Failure_LIKE_PRESSED: $failure_LIKE_PRESSED
      }
    ''';
  }

}