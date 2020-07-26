import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freetitle/bloc/post/save/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:freetitle/model/post_repository.dart';

class SaveBloc extends Bloc<SaveEvent, SaveState> {

  PostRepository _postRepository;
  String _postID;

  SaveBloc({@required PostRepository postRepository, @required String postID})
    : assert(postRepository != null), assert(postID != null),
        _postRepository = postRepository,
        _postID = postID;

  @override
  SaveState get initialState => SaveState.unsaved();

  @override
  Stream<SaveState> transform (
      Stream<SaveEvent> events,
      Stream<SaveState> Function(SaveEvent event) next
  ) {
    final observableStream = events as Observable<SaveEvent>;
    final nonDebounceStream = observableStream.where((event) {
      return (event is! SavePressed && event is! UnsavePressed && event is! PostLoaded);
    });
    final debounceStream = observableStream.where((event) {
      return (event is SavePressed || event is UnsavePressed || event is PostLoaded);
    }).debounceTime(Duration(milliseconds: 300));
    return super.transform(nonDebounceStream.mergeWith([debounceStream]), next);
  }

  @override
  Stream<SaveState> mapEventToState(
      SaveEvent event,
  ) async* {
    if (event is PostLoaded){
      yield* _mapPostLoadedToState();
    }
    else if (event is SavePressed){
      yield* _mapSavePressedToState();
    }
    else if (event is UnsavePressed){
      yield* _mapUnsavePressedToState();
    }
  }

  Stream<SaveState> _mapPostLoadedToState() async* {
    print("_mapPostLoadedToState");
    try{
      bool saved = await _postRepository.isPostSaved(_postID);
      if(saved){
        yield SaveState.saved();
      } else {
        yield SaveState.unsaved();
      }
    } catch (e) {
      yield SaveState.unsaved();
    }
  }

  Stream<SaveState> _mapSavePressedToState() async* {
    print("_mapSavePressedToState");
    try {
      yield SaveState.saveSubmitting();
      var result = await _postRepository.saveButtonPressed(_postID);
      if(result){
        yield SaveState.saved();
      }
      else {
        yield SaveState.Failure_SAVE_PRESSED();
        yield SaveState.unsaved();
      }
    } catch(e) {
      switch(e.code){
        /* TBD */
      }
    }
  }

  Stream<SaveState> _mapUnsavePressedToState() async* {
    print("_mapUnsavePressedToState");
    try {
      yield SaveState.unsaveSubmitting();
      var result = await _postRepository.saveButtonPressed(_postID);
      if(result) {
        yield SaveState.unsaved();
      }
      else {
        yield SaveState.Failure_SAVE_PRESSED();
        yield SaveState.saved();
      }
    }
    catch(e) {
      switch(e.code){
      /* TBD */
      }
    }
  }

}