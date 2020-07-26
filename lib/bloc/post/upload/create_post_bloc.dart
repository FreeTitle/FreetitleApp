import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freetitle/bloc/post/upload/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:freetitle/model/post_repository.dart';
import 'package:freetitle/model/util/validators.dart';

class UploadPostBloc extends Bloc<UploadPostEvent, UploadPostState> {

  PostRepository _postRepository;

  UploadPostBloc({@required postRepository})
      : assert(postRepository != null), _postRepository = postRepository;

  @override
  UploadPostState get initialState => UploadPostState.empty();

  @override
  Stream<UploadPostState> transform(
      Stream<UploadPostEvent> events,
      Stream<UploadPostState> Function(UploadPostEvent event) next
  ) {
    final observableStream = events as Observable<UploadPostEvent>;
    final nonDebounceStream = observableStream.where((event) {
      return (event is! TextChanged && event is! Submitted);
    });
    final debounceStream = observableStream.where((event) {
      return (event is TextChanged || event is Submitted);
    }).debounceTime(Duration(milliseconds: 300));
    return super.transform(nonDebounceStream.mergeWith([debounceStream]), next);
  }

  @override
  Stream<UploadPostState> mapEventToState(UploadPostEvent event) async* {
    if(event is TextChanged){
      yield*_mapTextChangedToState(event.postText);
    }
    else if (event is Submitted){
    }
  }

  Stream<UploadPostState> _mapTextChangedToState(postText) async* {
    yield currentState.update(
      isTextValid: Validators.isValidPostText(postText)
    );
  }

  Stream<UploadPostState> _mapSubmittedToState(postText)async* {
    yield UploadPostState.loading();
    try {
      await _postRepository.createPost(Map());
      yield UploadPostState.success();
    } catch (e) {
      /* TBD */
    }
  }

}