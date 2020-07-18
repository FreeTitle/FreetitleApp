import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freetitle/bloc/post/create/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:freetitle/model/post_repository.dart';
import 'package:freetitle/model/util/validators.dart';

class CreatePostBloc extends Bloc<CreatePostEvent, CreatePostState> {

  PostRepository _postRepository;

  CreatePostBloc({@required postRepository})
      : assert(postRepository != null), _postRepository = postRepository;

  @override
  CreatePostState get initialState => CreatePostState.empty();

  @override
  Stream<CreatePostState> transform(
      Stream<CreatePostEvent> events,
      Stream<CreatePostState> Function(CreatePostEvent event) next
  ) {
    final observableStream = events as Observable<CreatePostEvent>;
    final nonDebounceStream = observableStream.where((event) {
      return (event is! TextChanged && event is! Submitted);
    });
    final debounceStream = observableStream.where((event) {
      return (event is TextChanged || event is Submitted);
    }).debounceTime(Duration(milliseconds: 300));
    return super.transform(nonDebounceStream.mergeWith([debounceStream]), next);
  }

  @override
  Stream<CreatePostState> mapEventToState(CreatePostEvent event) async* {
    if(event is TextChanged){
      yield*_mapTextChangedToState(event.postText);
    }
    else if (event is Submitted){
    }
  }

  Stream<CreatePostState> _mapTextChangedToState(postText) async* {
    yield currentState.update(
      isTextValid: Validators.isValidPostText(postText)
    );
  }

  Stream<CreatePostState> _mapSubmittedToState(postText)async* {
    yield CreatePostState.loading();
    try {
      await _postRepository.createPost(Map());
      yield CreatePostState.success();
    } catch (e) {
      /* TBD */
    }
  }

}