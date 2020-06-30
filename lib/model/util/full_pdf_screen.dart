import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';

class FullPDFScreen extends StatelessWidget {
  FullPDFScreen({Key key, this.pdfPath, this.filename}) : super(key : key);

  final String pdfPath;
  final String filename;

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
      appBar: AppBar(
//        brightness: Brightness.dark,
        title: Text(filename, style: TextStyle(color: Colors.black),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black,),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      path: pdfPath,
    );
  }
}