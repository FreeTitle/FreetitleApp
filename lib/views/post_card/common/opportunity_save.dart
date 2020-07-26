import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freetitle/bloc/post/save/bloc.dart';
import 'package:freetitle/model/post_repository.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toast/toast.dart';

class SaveButton extends StatefulWidget {

  SaveButton({Key key, @required this.type}) : assert(type == PostType.event || type == PostType.project), super(key: key);

  final PostType type;

  _SaveButtonState createState() =>  _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton> {

  SaveBloc _saveBloc;
  bool isSaved = false;

  @override
  void initState() {
    super.initState();
    _saveBloc = BlocProvider.of<SaveBloc>(context);
    BlocProvider.of<SaveBloc>(context).dispatch(PostLoaded());
  }

  void tapSave() {
    isSaved ? _saveBloc.dispatch(UnsavePressed(type: widget.type)) : _saveBloc.dispatch(SavePressed(type: widget.type));

  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _saveBloc,
      listener: (BuildContext context, SaveState state) {
        if(state.isSave){
          isSaved = true;
          setState(() {

          });
        }
        else if(state.isUnsave){
          isSaved = false;
          setState(() {

          });
        }
        else if(state.failure_SAVE_PRESSED) {
          Toast.show("Like failed", context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        }
      },
      child: BlocBuilder(
        bloc: _saveBloc,
        builder: (BuildContext context, SaveState state) {
          return widget.type == PostType.project ? Container(
            height: 35,
            width: 92,
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: () {
                  tapSave();
                  print("Project save pressed");
                },
                highlightColor: Colors.transparent,
                child: Container(
                  padding:
                  EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: <Widget>[
                      Icon(
                          isSaved
                              ? Icons.done
                              : Icons.favorite,
                          color: isSaved
                              ? Colors.blue[300]
                              : Colors.white,
                          size: 15),
                      SizedBox(
                          width: isSaved ? 3 : 10),
                      Text(
                        isSaved ? "SAVED" : "SAVE",
                        style: GoogleFonts.galdeano(
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .merge(
                            TextStyle(
                              fontSize: 19,
                              color: isSaved
                                  ? Colors.blue[300]
                                  : Colors.white,
                              fontWeight:
                              FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: isSaved
                  ? Colors.white
                  : Colors.blue[300],
              borderRadius:
              BorderRadius.all(Radius.circular(30)),
              border: Border.all(
                  color: Colors.blue[300], width: 1.5),
            ),
          ) : Material(
            type: MaterialType.transparency,
            child: Ink(
              width: 45,
              height: 45,
              child: IconButton(
                iconSize: 28,
                color: Theme.of(context).highlightColor,
                icon: isSaved ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
                onPressed: () {
                  tapSave();
                  print("Event like pressed");
                },
              ),
            ),
          );
        },
      ),
    );
  }
}