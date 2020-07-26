import 'package:meta/meta.dart';

@immutable
class SaveState {
  final bool isSave;
  final bool isUnsave;
  final bool isSaveButtonEnabled;
  final bool isSubmitting;
  final bool isSuccess;
  final bool failure_SAVE_PRESSED;

  SaveState({
   @required this.isSave,
   @required this.isUnsave,
   @required this.isSubmitting,
   @required this.isSaveButtonEnabled,
   @required this.isSuccess,
   @required this.failure_SAVE_PRESSED
  });


  factory SaveState.saved() {
    return SaveState(
      isSave: true,
      isUnsave: false,
      isSubmitting: false,
      isSaveButtonEnabled: true,
      isSuccess: false,
      failure_SAVE_PRESSED: false
    );
  }

  factory SaveState.unsaved() {
    return SaveState(
      isSave: false,
      isUnsave: true,
      isSubmitting: false,
      isSaveButtonEnabled: true,
      isSuccess: false,
      failure_SAVE_PRESSED: false
    );
  }

  factory SaveState.saveSubmitting() {
    return SaveState(
      isSave: true,
      isUnsave: false,
      isSubmitting: true,
      isSaveButtonEnabled: false,
      isSuccess: false,
      failure_SAVE_PRESSED: false
    );
  }

  factory SaveState.unsaveSubmitting() {
    return SaveState(
        isSave: false,
        isUnsave: true,
        isSubmitting: true,
        isSaveButtonEnabled: false,
        isSuccess: false,
        failure_SAVE_PRESSED: false
    );
  }
  
  factory SaveState.Failure_SAVE_PRESSED() {
    return SaveState(
      isSave: false,
      isUnsave: false,
      isSubmitting: false,
      isSuccess: false,
      isSaveButtonEnabled: false,
      failure_SAVE_PRESSED: true
    );
  }

  SaveState copyWith({
    bool isSave,
    bool isUnsave,
    bool isSubmitting,
    bool isSuccess,
    bool isSaveButtonEnabled,
    Failure_SAVE_PRESSED: false
  }) {
    return SaveState(
      isSave: isSave ?? this.isSave,
      isUnsave: isUnsave ?? this.isUnsave,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isSaveButtonEnabled: isSaveButtonEnabled ?? this.isSaveButtonEnabled,
      failure_SAVE_PRESSED: Failure_SAVE_PRESSED ?? this.failure_SAVE_PRESSED
    );
  }

  @override
  String toString() {
    return '''
      SaveState{
        isSave: $isSave,
        isUnsave: $isUnsave,
        isSubmitting: $isSubmitting,
        isSuccess: $isSuccess,
        isSaveButtonEnabled: $isSaveButtonEnabled,
        Failure_Save_PRESSED: $failure_SAVE_PRESSED
      }
    ''';
  }

}