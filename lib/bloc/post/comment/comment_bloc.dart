import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freetitle/bloc/post/comment/comment_event.dart';
import 'package:freetitle/bloc/post/comment/comment_state.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:freetitle/model/comment_repository.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {

  CommentRepository _commentRepository;
  String _postID;
  String _commentID;

  CommentBloc({@required commentRepository, @required postID, @required commentID})
    : assert(commentRepository != null), assert(postID != null), assert(commentID !=null),
      _commentRepository = commentRepository,
      _postID = postID,
      _commentID = commentID;

  @override get initialState => CommentState.empty();

  @override
  Stream<CommentState> transform (Stream<CommentEvent> events,
      Stream<CommentState> Function(CommentEvent event) next
  ) {
    final observableStream = events as Observable<CommentEvent>;
    final nonDebounceStream = observableStream.where((event) {
      return (event is! UploadCommentButtonPressed);
    });
    final debounceStream = observableStream.where((event) {
      return (event is UploadCommentButtonPressed);
    }).debounceTime(Duration(milliseconds: 300));
    return super.transform(nonDebounceStream.mergeWith([debounceStream]), next);
  }

  @override
  Stream<CommentState> mapEventToState(CommentEvent event) async* {
    if(event is UploadCommentButtonPressed) {
      yield* _mapUploadCommentButtonPressedToState();
    }
  }


  Stream<CommentState> _mapUploadCommentButtonPressedToState() async* {
    try{
      yield CommentState.submitting();
      /* TODO data needs to be changed */
      var result = await _commentRepository.uploadCommentPressed(Map());
      if(result) {
        yield CommentState.success();
      }
    } catch(e) {
      /* TBD */
    }
  }
}