import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freetitle/bloc/post/like/like_event.dart';
import 'package:freetitle/bloc/post/like/like_state.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:freetitle/model/post_repository.dart';

class LikeBloc extends Bloc<LikeEvent, LikeState> {

  PostRepository _postRepository;
  String _postID;

  LikeBloc({@required PostRepository postRepository, @required String postID})
    : assert(postRepository != null), assert(postID != null),
        _postRepository = postRepository,
        _postID = postID;

  @override
  LikeState get initialState => LikeState.unliked();

  @override
  Stream<LikeState> transform (
      Stream<LikeEvent> events,
      Stream<LikeState> Function(LikeEvent event) next
  ) {
    final observableStream = events as Observable<LikeEvent>;
    final nonDebounceStream = observableStream.where((event) {
      return (event is! LikePressed && event is! UnlikePressed && event is! PostLoaded);
    });
    final debounceStream = observableStream.where((event) {
      return (event is LikePressed || event is UnlikePressed || event is PostLoaded);
    }).debounceTime(Duration(milliseconds: 300));
    return super.transform(nonDebounceStream.mergeWith([debounceStream]), next);
  }

  @override
  Stream<LikeState> mapEventToState(
      LikeEvent event,
  ) async* {
    if (event is PostLoaded){
      yield* _mapPostLoadedToState();
    }
    else if (event is LikePressed){
      yield* _mapLikePressedToState();
    }
    else if (event is UnlikePressed){
      yield* _mapUnlikePressedToState();
    }
  }

  Stream<LikeState> _mapPostLoadedToState() async* {
    try{
      bool liked = await _postRepository.isPostLiked(_postID);
      if(liked){
        yield LikeState.liked();
      } else {
        yield LikeState.unliked();
      }
    } catch (e) {
      yield LikeState.unliked();
    }
  }

  Stream<LikeState> _mapLikePressedToState() async* {
    try {
      yield LikeState.likeSubmitting();
      var result = await _postRepository.likeButtonPressed();
      if(result){
        yield LikeState.liked();
      }
      else {
        yield LikeState.unliked();
      }
    } catch(e) {
      switch(e.code){
        /* TBD */
      }
    }
  }

  Stream<LikeState> _mapUnlikePressedToState() async* {
    try {
      yield LikeState.unlikeSubmitting();
      var result = await _postRepository.likeButtonPressed();
      if(result) {
        yield LikeState.unliked();
      }
      else {
        yield LikeState.liked();
      }
    }
    catch(e) {
      switch(e.code){
      /* TBD */
      }
    }
  }

}